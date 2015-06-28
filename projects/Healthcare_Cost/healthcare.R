###########
# Make healthcare map and turn it into a shiny app
# 6/2/14 UPDATE: Original FY2011 data file has been updated to include a new column,
# "Average Medicare Payment." The data provided here include hospital-specific charges
# for the more than 3,000 U.S. hospitals that receive Medicare Inpatient Prospective
# Payment System (IPPS) payments for the top 100 most frequently billed discharges,
# paid under Medicare based on a rate per discharge using the Medicare Severity
# Diagnosis Related Group (MS-DRG) for Fiscal Year (FY) 2011. These DRGs represent
# more than 7 million discharges or 60 percent of total Medicare IPPS discharges.

rm(list = ls())

setwd("~/Documents/college stuffs/grad school/website/projects/Healthcare_Cost/")

library(data.table)
library(maps)
library(scales)
library(zipcode)

my_data <- fread("data/Inpatient_Prospective_Payment_System_FY2011.csv") %>%
  tbl_df() %>%
  setNames(c("Definition", "ID", "Name", "Address", "City", "State", "Zipcode", "Total_Discharges",
           "Referral_Region", "Covered_Charges", "Total_Payment", "Medicare_Payment")) %>%
  mutate(Covered_Charges = as.numeric(gsub("\\$", "", Covered_Charges)),
         Total_Payment = as.numeric(gsub("\\$", "", Total_Payment)),
         Medicare_Payment = as.numeric(gsub("\\$", "", Medicare_Payment)))

str(my_data)

length(unique(my_data$Address)) # 3053 zipcodes, #3326 unique hospitals

unique(my_data$Definition)


plot(density(my_data$Covered_Charges))
plot(density(my_data$Total_Payment))
plot(density(my_data$Medicare_Payment))

cor(my_data[, c("Covered_Charges", "Total_Payment", "Medicare_Payment")])

# Plot cost by state first (doing it by zipcode would be poor. Maybe by county?)


glimpse(my_data)

foo <- filter(my_data, Definition == "885 - PSYCHOSES") %>%
  group_by(State) %>%
  dplyr::summarise(my_mean = mean(Total_Payment))

name_to_abb <- data.frame(State = state.abb, region = state.name)
name_to_abb$region <- tolower(name_to_abb$region)

states_map <- map_data("state") %>%
  left_join(name_to_abb) %>%
  left_join(foo)

gah <- filter(my_data, Definition == "885 - PSYCHOSES") %>%
  mutate(zip = clean.zipcodes(Zipcode)) %>%
  left_join(zipcode)

#########

foo <- group_by(my_data, State) %>%
  dplyr::summarise(my_mean = mean(Total_Payment))

name_to_abb <- data.frame(State = state.abb, region = state.name)
name_to_abb$region <- tolower(name_to_abb$region)

states_map <- map_data("state") %>%
  left_join(name_to_abb) %>%
  left_join(foo)

gah <- mutate(my_data, zip = clean.zipcodes(Zipcode)) %>%
  left_join(zipcode)

head(gah)

# plot aggregated mean by state, with points that have a size proportional to money (but circles are misleading??)

ggplot(aes(x = long, y = lat, group = group), data = states_map) +
  geom_polygon(aes(fill = my_mean), colour = alpha("white", 1/2), size = 0.2) +
  scale_fill_gradient(name = "Cost\n", high = "#de2d26", low = "#fee0d2") +
  geom_polygon(colour = "white", fill = NA) +
  geom_point(aes(x = longitude, y = latitude, group = NULL, size = Total_Payment),
             position = position_jitter(w = 0.2, h = 0.2),
             shape = 21, fill = "white",
             data = filter(gah, !(State %in% c("HI", "AK")))) + 
  theme_bw() +
  theme(legend.title = element_text(size = 16),
        legend.text = element_text(size = 10),
        axis.line = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        panel.background = element_blank(),
        panel.border = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.background = element_blank())

head(states_map)



sd(foo$Total_Payment)

glimpse(foo)









