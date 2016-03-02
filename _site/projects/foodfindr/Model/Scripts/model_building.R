############################
# Author: Daniel Martin
# EDA and model building for
# menupages data
############################

rm(list = ls())

library(XML)
library(dplyr)
library(randomForest)
library(glmnet)
library(ROCR)
library(ggplot2)

set.seed(1260) # set seed for reproducibility

# set working directory here

#################
# Read in data

restaurant_data <- read.csv("Data/restaurant_info.csv") %>%
  mutate(tags = gsub(".*'cuisine', |);\n", "", as.character(tags)))

# Fix html in restaurant names

html2txt <- function(str) {
  xpathApply(htmlParse(str, asText=TRUE),
             "//body//text()", 
             xmlValue)[[1]] 
}

fixed_names <- c(NA)

for(i in 1:length(restaurant_data$name)){
  
  fixed_names[i] <- html2txt(as.character(restaurant_data$name[i]))

}

restaurant_data$name <- fixed_names

# Create vegan/vegetarian variables for the application

restaurant_data$isVegan <- ifelse(grepl("vegan", restaurant_data$tags), "vegan", "")
restaurant_data$isVegetarian <- ifelse(grepl("vegetarian", restaurant_data$tags), "vegetarian-friendly", "")
restaurant_data$isGluten <- ifelse(restaurant_data$isGluten == 1, "gluten-free", "")
restaurant_data <- within(restaurant_data, special_diet <- paste(isVegan, isVegetarian, isGluten))

# Set healthy labels based on tags:
# vegan, vegetarian, local/organic, health food, and sandwiches (but not pizza)

restaurant_data$isHealthy <- NA
restaurant_data$isHealthy[grep("vegan|vegetarian|local|salads|health-food|sandwiches", restaurant_data$tags)] <- 1
restaurant_data$isHealthy[grep("\\['seafood'\\]", restaurant_data$tags)] <- 1
restaurant_data$isHealthy[grep("pizza", restaurant_data$tags)] <- 0
restaurant_data$isHealthy[is.na(restaurant_data$isHealthy)] <- 0
restaurant_data$isHealthy <- factor(restaurant_data$isHealthy)

summary(restaurant_data$isHealthy) # 22% "healthy"
485/(485 + 1673)

menu_data <- read.csv("Data/menu_words.csv")

##############################
# EDA on word counts
# (python only kept top 5000)

pdf("Figure/word_count.pdf", height = 5, width = 5)
plot(sort(colSums(menu_data[, -1]), decreasing = TRUE),
     main = "Total Word Count", xlab = "", ylab = "Frequency Count")
dev.off()

# Keep only the top 1000 words

menu_data <- menu_data[, -1]
menu_sub <- menu_data[, names(menu_data) %in% names(sort(colSums(menu_data), decreasing = TRUE))[1:1000]]
menu_sub$isHealthy <- restaurant_data$isHealthy

##########################################
# Compare a random forest and LASSO using 
# either straight frequencies or tf-idf 
# weighting and estimate AUC using 5-fold 
# cross-validation on the training set

# split into training and testing (70/30)

train_ids <- sample(1:nrow(menu_sub), floor(nrow(menu_sub) * .70), replace = FALSE)

training <- menu_sub[train_ids,]
testing <- menu_sub[-train_ids,]

conditions <- expand.grid(mtry = c(10, 31, 60),
                          ntree = c(100, 500, 800),
                          auc_freq = NA,
                          auc_idf = NA)

training$fold <- sample(x = 1:5, size = nrow(training), replace = TRUE)

# calculate tf-idf

tf <- training[, -1001]
idf <- log(nrow(training[, -1001])/colSums(training[, -1001]))
tfidf <- training[, -1001]

for(word in names(idf)){
  tfidf[,word] <- tf[,word] * idf[word]
}

tfidf$isHealthy <- training$isHealthy
tfidf$fold <- training$fold

# Run the random forest across different values for both hyperparameters (ntree and mtry)

for(num_cond in 1:nrow(conditions)){
  
  df <- conditions[num_cond, ]
  auc_freq <- c(NA)
  auc_idf <- c(NA)
  
  for(i in 1:5){
    
    rf_mod_freq <- randomForest(x = training[training$fold != i, 1:1000],
                                y = training[training$fold != i, 1001],
                                ntree = df$ntree, mtry = df$mtry)
    
    rf_mod_idf <- randomForest(x = tfidf[tfidf$fold != i, 1:1000],
                               y = tfidf[tfidf$fold != i, 1002],
                               ntree = df$ntree, mtry = df$mtry)
    
    auc_freq[i] <- predict(rf_mod_freq, type = "prob", newdata = training[training$fold == i, ])[, 2] %>%
      prediction(training[training$fold == i, 1001]) %>%
      performance("auc") %>%
      slot("y.values") %>%
      unlist()
    
    auc_idf[i] <- predict(rf_mod_idf, type = "prob", newdata = tfidf[tfidf$fold == i, ])[, 2] %>%
      prediction(tfidf[tfidf$fold == i, 1002]) %>%
      performance("auc") %>%
      slot("y.values") %>%
      unlist()
    
    print(i)
    
  }
  
  conditions$auc_freq[num_cond] <- mean(auc_freq)
  conditions$auc_idf[num_cond] <- mean(auc_idf)
  
  print(paste("Number", num_cond, "of", nrow(conditions), "found"))
  
}

conditions

# Fairly close, but ntree = 500 and mtry = 10 seems to work best
# with traditional frequency weighting

# Run a LASSO model for both frequency counts and tf-idf weighting

auc_freq <- c(NA)
auc_idf <- c(NA)

for(i in 1:5){
  
  lambda_freq <- cv.glmnet(x = as.matrix(training[training$fold != i, 1:1000]),
                          y = training[training$fold != i, 1001],
                          alpha = 1, family = 'binomial')
  
  lasso_freq <- glmnet(x = as.matrix(training[training$fold != i, 1:1000]),
                      y = training[training$fold !=i, 1001],
                      alpha = 1, family = 'binomial',
                      lambda = lambda_freq$lambda.1se)
  
  auc_freq[i] <- predict(lasso_freq,
                      type = "response",
                      s = 'lambda.min',
                      newx = as.matrix(training[training$fold == i, 1:1000])) %>%
    prediction(training[training$fold == i, 1001]) %>%
    performance("auc") %>%
    slot("y.values") %>%
    unlist()

  lambda_idf <- cv.glmnet(x = as.matrix(tfidf[tfidf$fold != i, 1:1000]),
                          y = tfidf[tfidf$fold != i, 1002],
                          alpha = 1, family = 'binomial')
  
  lasso_idf <- glmnet(x = as.matrix(tfidf[tfidf$fold != i, 1:1000]),
                      y = tfidf[tfidf$fold !=i, 1002],
                      alpha = 1, family = 'binomial',
                      lambda = lambda_idf$lambda.1se)
  
  auc_idf[i] <- predict(lasso_idf,
                    type = "response",
                    s = 'lambda.min',
                    newx = as.matrix(tfidf[tfidf$fold == i, 1:1000])) %>%
    prediction(tfidf[tfidf$fold == i, 1002]) %>%
    performance("auc") %>%
    slot("y.values") %>%
    unlist()
  
  print(i)
  
}

mean(auc_freq)
mean(auc_idf)

# LASSO model with counts rather than tf-idf works better.

##############################
# Perform final model
# validation for randomForest
# with standard defaults
# and a LASSO

rf_mod <- randomForest(x = training[, 1:1000],
                       y = training[, 1001],
                       mtry = 10)

rf_auc <- predict(rf_mod, type = "prob", newdata = testing[, 1:1000])[, 2] %>%
  prediction(testing[, 1001]) %>%
  performance("auc") %>%
  slot("y.values") %>%
  unlist()

lasso_lambda <- cv.glmnet(x = as.matrix(training[, 1:1000]),
                          y = training[, 1001],
                          alpha = 1, family = 'binomial')

lasso_mod <- glmnet(x = as.matrix(training[, 1:1000]),
                    y = training[, 1001],
                    alpha = 1, family = 'binomial',
                    lambda = lasso_lambda$lambda.min)

lasso_auc <- predict(lasso_mod,
                     type = "response",
                     s = 'lambda.min',
                     newx = as.matrix(testing[, 1:1000])) %>%
  prediction(testing[, 1001]) %>%
  performance("auc") %>%
  slot("y.values") %>%
  unlist()

# AUC for lasso is 0.82

#########################
# Interpret final rf
# model, create plots,
# and calculate predicted
# probabilities to create
# health ratings

# Variable importance

rf_importance <- as.data.frame(rf_mod$importance) %>%
  mutate(food = row.names(.)) %>%
  arrange(desc(MeanDecreaseGini)) %>%
  head(n = 10)

names(rf_importance)[1] <- "Importance"
rf_importance$food <- factor(rf_importance$food, levels = rev(rf_importance$food))

# Examine partial dependence for postitive/negative

partialPlot(x = rf_mod, x.var = "turkey", pred.data = testing) # positive
partialPlot(x = rf_mod, x.var = "swiss", pred.data = testing) # positive
partialPlot(x = rf_mod, x.var = "roast", pred.data = testing) # positive
partialPlot(x = rf_mod, x.var = "cheddar", pred.data = testing) # positive
partialPlot(x = rf_mod, x.var = "fried", pred.data = testing) # negative
partialPlot(x = rf_mod, x.var = "bagel", pred.data = testing) # positive
partialPlot(x = rf_mod, x.var = "cucumbers", pred.data = testing) # positive
partialPlot(x = rf_mod, x.var = "sauce", pred.data = testing) # negative
partialPlot(x = rf_mod, x.var = "provolone", pred.data = testing) # negative
partialPlot(x = rf_mod, x.var = "hummus", pred.data = testing) # positive

rf_importance$new_food <- paste(as.character(rf_importance$food), c("(+)", "(+)", "(+)", "(+)", "(-)",
                                                                    "(+)", "(+)", "(-)", "(-)", "(+)"))
rf_importance$new_food <- factor(rf_importance$new_food, levels = rev(rf_importance$new_food))

pdf("Figure/rf_imp.pdf", width = 5, height = 5)
ggplot(aes(x = new_food, y = Importance), data = rf_importance) + 
  geom_point(size = 3) + 
  scale_y_continuous(breaks = c(2.5, 3, 3.5, 4, 4.5, 5)) + 
  labs(x = "Food\n", y = "\nImportance") +
  coord_flip() + 
  theme_bw() + 
  ggtitle("Variable Importance\n") +
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 16),
        title = element_text(face = "bold", size = 16))
dev.off()

# Plot ROC curve

rf_roc <- predict(rf_mod, type = "prob", newdata = testing[, 1:1000])[, 2] %>%
  prediction(testing[, 1001]) %>%
  performance("tpr", "fpr")

pdf("Figure/auc_rf.pdf", width = 5, height = 5)
plot(rf_roc, main = "Receiver Operating Characteristic (ROC) Curve", col = 2, lwd = 2)
abline(a = 0, b = 1, lwd = 2, lty = 2, col = "gray")
text(x = 0.1, y = 0.9, labels = paste("AUC =", round(rf_auc, 2)))
dev.off()

restaurant_data$new_pred <- predict(rf_mod, type = "prob", newdata = menu_sub)[, 2]

select(restaurant_data, name, new_pred) %>%
  arrange(desc(new_pred)) %>%
  head(n = 50)

select(restaurant_data, name, new_pred) %>%
  arrange(new_pred) %>%
  head(n = 50)

summary(restaurant_data$new_pred)

restaurant_data$health_color = as.character(cut(restaurant_data$new_pred,
                                    breaks = quantile(restaurant_data$new_pred, probs = c(0, 0.25, 0.75, 1.00)),
                                    include.lowest = TRUE,
                                    labels = c("red", "yellow", "green")))

select(restaurant_data, name, address, latitude, longitude, link,
       price, health_color, special_diet) %>%
  write.csv("Data/restaurant_ratings.csv", row.names = FALSE)

#########################
# Validation using local
# blogs that include
# places that were on
# menupages

table(restaurant_data[c(97, 1578, 1139, 1705, 2016, 720, 703, 727, 1107, 1322, 267, 1478,
                  1842, 1843, 2053, 2022, 1099, 1745, 1269, 1845), "health_color"])

# Ariana Restaurant: 97 - YELLOW
# Root: 1578 - GREEN 
# Lucy Ethiopian Cafe: 1139 - YELLOW 
# Snappy Sushi: 1705 - YELLOW
# Trident: 2016 - GREEN
# Erbaluce: 720 - YELLOW
# Elephant Walk: 703 - YELLOW 
# EVOO: 727 - YELLOW
# Life Alive: 1107 - GREEN 
# Oleana: 1322 - YELLOW 
# Blu: 267 - YELLOW 
# Post 390: 1478 - YELLOW
# Ten Tables x 2: 1842, 1843 - GREENx2 
# Vee Vee: 2053 - GREEN
# True Bistro: 2022 - GREEN 
# Legal Harborside: 1099 - YELLOW
# Stephi's in Southie: 1745 - YELLOW 
# Myer's + Chang: 1269 - GREEN 
# Teranga: 1845 - YELLOW

# 8 green
# 12 yellow

table(restaurant_data[c(212, 157, 1107, 1258, 1578, 2022), "health_color"])

# Beat Hotel: 212 - YELLOW 
# b.good: 157 - GREEN 
# Life Alive: 1107 - GREEN
# Mother Juice: 1258 - GREEN
# Root: 1578 - GREEN 
# True Bistro: 2022 - GREEN 

# 5 green, 1 yellow

table(restaurant_data[c(118, 363, 573, 1358), "health_color"])

# Healthiest chains

# ABP: 118 - GREEN 
# Brueggers: 363 - GREEN 
# Cosi: 573 - GREEN 
# Panera: 1358 - GREEN 

# 4 green

# Total: 19 green, 11 yellow


