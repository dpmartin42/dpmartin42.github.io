##############################
# Author: Daniel P. Martin
# Date: Mar 13 2015
# Title: Clean IAT data
# for interactive choropleth
# using D3
##############################

rm(list = ls())

library(foreign)
library(dplyr)
library(httr)
library(maps)

# setwd here

# Download 2004 - 2013 Race IAT data sets from OSF
# Do so separately to avoid getting too large a data set

iat_links <- data.frame(Year = c("2004", "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013"),
                        Link = c("5rnzu", "vnimz", "hf9qt", "a7dkz", "fmbje", "gqw7d", "nzvy2", "taqhb", "rphks", "7phax"))

new_data <- list(NA)

for(the_year in 1:nrow(iat_links)){
  
  df <- iat_links[the_year, ]
  
  URL <- paste0("https://osf.io/", df$Link, "/?action=download")
  file_name <- paste0("Race_IAT.public.", df$Year, ".zip" )
  full_path <- paste0("Data/", file_name)
  
  httr::GET(URL, httr::write_disk(full_path, overwrite = TRUE))
  unzip(full_path, exdir = "Data/")
  
  my_data <- read.spss(paste0("Data/", list.files("Data/")[grep(".sav", list.files("Data/"))]), use.value.labels = FALSE)
  
  if(df$Year %in% c("2004", "2005")){
    
    new_data[[the_year]] <- data.frame(IAT = my_data$D_biep.White_Good_all,
                           STATE = my_data$STATE,
                           CountyNo = my_data$CountyNo,
                           year = my_data$year,
                           race = as.character(my_data$ethnic)) %>%
      filter(race == 5 & !is.na(IAT) & grepl("[A-Z]+", STATE))
    
  } else{
    
    new_data[[the_year]] <- data.frame(IAT = my_data$D_biep.White_Good_all,
                           STATE = my_data$STATE,
                           CountyNo = my_data$CountyNo,
                           year = my_data$year,
                           race = as.character(my_data$raceomb)) %>%
      filter(race == 6 & !is.na(IAT) & grepl("[A-Z]+", STATE))
    
  }
  
  for(the_file in list.files("Data/")){
    
    file.remove(paste0("Data/", the_file))
    
  }
  
  print(paste(the_year, "of 10 found"))
   
}

######################
# Clean and aggregate
# data by state

state_agg <- do.call(rbind, new_data) %>%
  group_by(STATE) %>%
  summarise(meanIAT = round(mean(IAT), 2),
            size = n()) %>%
  filter(!(STATE %in% c("AE", "AP", "PR")) & size > 100)

names(state_agg)[1] <- "abb"

# merge with fips code at the state level

data(state.fips)

state_fips <- select(state.fips, fips, abb) %>%
  distinct(fips, abb) %>%
  rbind(data.frame(fips = c(02, 15),
                   abb = c("AK", "HI")))

state_data <- merge(state_fips, state_agg)
names(state_data)[2] <- "id"
state_data$name <- data.frame(state.name, state.abb, stringsAsFactors = FALSE) %>%
  rbind(c("District of Columbia", "DC")) %>%
  arrange(state.abb) %>%
  .$state.name

# Save state data for plotting

write.csv(state_data, "state_data.csv", row.names = FALSE)

# Use filter to get yearly data for .gif
# filter(state_data, year == 2013)

# Calculate mean and SD of IAT D score for color palette 

plot(density(state_data$meanIAT, na.rm = TRUE))
sd_score <- sd(state_data$meanIAT, na.rm = TRUE)
round(c(-2 * sd_score, -1 * sd_score, 0, 1 * sd_score, 2 * sd_score) + mean(state_data$meanIAT, na.rm = TRUE), 2)

######################
# Clean and aggregate
# data by counties

county_agg <- do.call(rbind, new_data) %>%
  group_by(STATE, CountyNo) %>%
  summarise(meanIAT = round(mean(IAT), 2),
            size = n()) %>%
  filter(!(STATE %in% c("AE", "AP", "PR", "AA")) & size > 30)

# Merge state and county fips, then merge again with the data set with names

data(state.fips)

state_fips <- select(state.fips, fips, abb) %>%
  distinct(fips, abb) %>%
  rbind(data.frame(fips = c(02, 15),
                   abb = c("AK", "HI"))) %>%
  arrange(fips)

county_fips <- left_join(county_agg, state_fips, by = c("STATE" = "abb")) %>%
  mutate(id = paste0(as.character(fips), as.character(CountyNo)))

county_names <- read.csv("county_names.csv")

county_total <- merge(county_names, county_fips, all.x = TRUE) %>%
  select(id, name, meanIAT, size)

# Save data set

write.csv(county_total, "county_data.csv", row.names = FALSE)

# Calculate mean and SD for county-level D score for palette

plot(density(county_total$meanIAT, na.rm = TRUE))
sd_score <- sd(county_total$meanIAT, na.rm = TRUE)
round(c(-2 * sd_score, -1 * sd_score, 0, 1 * sd_score, 2 * sd_score) + mean(county_total$meanIAT, na.rm = TRUE), 2)








