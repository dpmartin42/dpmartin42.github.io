#############################################################
# create_table:
# function to create a table of similar colleges
# @param region - geographic region
# @param total.outstate.price - total cost for out of state students
# @param percent.admit - percentage of students admitted
# @param size - size of school 
# @param sector - sector of school
# @param grad.rate - 6-year graduation rate
# @param region_weight - user weight for region
# @param price_weight - user weight for school cost
# @param admit_weight - user weight for admission rate
# @param size_weight - user weight for size
# @param sector_weight - user weight for sector
# @param grad_weight - user weight for graduation rate

library(cluster)
library(dplyr)

college_data <- read.csv("data/college_data.csv", stringsAsFactors = FALSE) %>%
  setNames(c("unitid", "name", "year", "city", "state.abb", "region",
             "website", "total.outstate.price", "percent.admit", "size",
             "state", "sector", "grad.rate")) %>%
  mutate(region = gsub(" [A-Z][A-Z]", "", region),
         size = factor(size),
         sector = factor(sector)) %>%
  mutate(region = factor(region))

create_table <- function(region, total.outstate.price, percent.admit, size, sector, grad.rate,
                         region_weight, price_weight, admit_weight, size_weight, sector_weight, grad_weight){
  
  college_sub <- select(college_data, name, region, total.outstate.price, percent.admit, size, sector, grad.rate)
  
  user_input <- data.frame(name = NA,
                           region,
                           total.outstate.price,
                           percent.admit,
                           size,
                           sector,
                           grad.rate)
  
  user_weights <- c(region_weight, price_weight, admit_weight, size_weight, sector_weight, grad_weight)
  
  new_data <- rbind(user_input, na.omit(college_sub)) %>%
    mutate(size = ordered(size, levels = c("Under 1,000", "1,000 - 4,999", "5,000 - 9,999",
                                           "10,000 - 19,999", "20,000 and above")))
  
  data_dist <- daisy(new_data[, -1], metric = "gower", weights = user_weights)
  new_data$index <- (1 - as.matrix(data_dist)[, 1]) * 100

  arrange(new_data[-1, ], desc(index)) %>%
    mutate(index = round(index)) %>%
    select(name, region, size, sector, total.outstate.price, percent.admit, grad.rate, index) %>%
    setNames(c("Institution", "Region", "Size", "Sector", "Total Cost", "Percentage Admitted", "Graduation Rate", "Percent Match"))
  
}
