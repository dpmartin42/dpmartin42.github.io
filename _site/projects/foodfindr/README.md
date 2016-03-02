# Food Findr
This is the repo for my project for the July 2015 Insight Health Data Science session in 
Boston, MA. The goal of this project was to use machine learning on the contents of over 
2,000 menus in Boston and provide some metric of relative health for each to encourage 
the selection of restaurants that have more healthy options when dining out. 

The Model/Scripts folder houses the three scripts used to collect these data and build the 
statistical model: 
* get_data.py used Python, BeautifulSoup, and regex to collect the menu information 
from all 2158 menus on [boston.menupages.com](boston.menupages.com) along with geographical 
information and saves two csv files locally: one with basic restaurant information and the 
other with a bag of words created from the scraped data
* model_building.R used R for exploratory data analysis, initial parameter tuning and 
model testing on the training data, and final model validation using the hold-out test set 
with predictions appended and saved locally
* sql_to_aws.py uploaded the dataset created in model_building.R to an amazon RDS instance

The Shiny folder houses the application, which is an interactive map designed to take user 
input (such as current address, maximum distance, cost preference, and dietary restrictions) 
and plots the corresponding restaurants on the map. This app was created using shiny along 
with the leaflet package in R and deployed to a Shiny Server using amazon web services. 
The application and slides for my presentation can be seen on my [project website](www.food-findr.com).