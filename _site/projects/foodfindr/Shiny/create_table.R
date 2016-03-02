#############################################################
# create_table:
# function to create a table of restaurants

library(DBI)
library(dplyr)
library(RCurl)
library(SDMTools)
library(jsonlite)

# Drop first column of row numbers after pulling from database

con <- dbConnect(RMySQL::MySQL(), db = "food_db")
restaurant_data <- dbGetQuery(con, "SELECT * FROM food_tb") %>%
  .[, -1]
dbDisconnect(con)

create_table <- function(input_address, input_distance, input_price, input_restrictions){
  
  address_call <- paste0("https://maps.googleapis.com/maps/api/geocode/json?address=",
                         input_address,
                         ",+Boston,+MA")
  
  address_data <- URLencode(address_call) %>%
    getURL() %>%
    fromJSON()
  
  address_lat <- address_data$results$geometry$location$lat[1]
  address_long <- address_data$results$geometry$location$lng[1]
  
  METERS_TO_MILES <- 0.000621371192
  
  distances <- distance(lat1 = rep(address_lat, time = nrow(restaurant_data)),
                        lon1 = rep(address_long, time = nrow(restaurant_data)),
                        lat2 = restaurant_data$latitude,
                        lon2 = restaurant_data$longitude)
  
  restaurant_data$distance <- round(distances$distance * METERS_TO_MILES, 2)
  
  restaurant_data$health_color <- factor(restaurant_data$health_color, levels = c("green", "yellow", "red"))
  
  restaurant_sub <- select(restaurant_data, name, address, price, distance,
                           longitude, latitude, link, health_color, special_diet) %>%
    filter(price %in% input_price,
           distance < input_distance, 
           grepl(paste(input_restrictions, collapse = "|"), special_diet)) %>%
    arrange(health_color, distance)
  
  names(restaurant_sub)[1:4] <- c("Name", "Address", "Price", "Distance")
  
  return(list(c(address_long, address_lat), restaurant_sub))
  
}
