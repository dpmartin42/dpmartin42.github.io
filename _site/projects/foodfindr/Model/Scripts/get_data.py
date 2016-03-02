"""
Created on Sun Jul 19 13:43:41 2015

Author: Daniel Martin
Title: Scrape menupages to get both restaurant information and to
       create a bag of words for the restaurants for model building
"""

from bs4 import BeautifulSoup
import urllib2
import re
import math
import pandas as pd
import numpy as np
import MySQLdb
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import CountVectorizer

def get_restaurant_info(html_page, base_url):

    # Function to extract restaurant information, such as the name, address, longitude, latitude, and price
    # The input is a single string that represents the first page to be scraped off of menupages
    # The output is a pandas dataframe that contains the data

    request = urllib2.Request(html_page + str(1))
    request.add_header('User-agent', 'Mozilla/5.0 (Linux i686)')

    response = urllib2.urlopen(request)

    soup = BeautifulSoup(response.read())

    num_restaurants = int(soup.find('strong').text)
    num_pages = int(math.ceil(num_restaurants/100.0))

    base_url = base_url

    total_names = []
    total_links = []
    total_prices = []
    total_addresses = []
    total_longitude = []
    total_latitude = []

    for num_page in range(num_pages):
    
        page_request = urllib2.Request(html_page + str(num_page + 1))
        page_request.add_header('User-agent', 'Mozilla/5.0 (Linux i686)')

        page_response = urllib2.urlopen(page_request).read()

        page_soup = BeautifulSoup(page_response)

        places = page_soup.find_all(class_ = 'link')

        for the_place in places:
            total_names.append(re.sub('.*</span>|</a>', '', str(the_place)))
            total_links.append(the_place.get('href'))
    
        raw_prices = page_soup.findAll(True, {'class':['price1', 'price2', 'price3', 'price4', 'price5']})

        for the_price in raw_prices:
            total_prices.append(the_price.text)
    
        longitude = re.findall("data\[[0-9]+\]\[\'longitude\'\] = \"(.*)\";", str(page_soup))
        longitude = [float(i) for i in longitude]

        latitude = re.findall("data\[[0-9]+\]\[\'latitude\'\] = \"(.*)\";", str(page_soup))
        latitude = [float(i) for i in latitude]

        address = re.findall("data\[[0-9]+\]\[\'address1\'\] = \"(.*)\";", str(page_soup))

        for index in range(len(places)):
            total_longitude.append(longitude[index])
            total_latitude.append(latitude[index])
            total_addresses.append(address[index])
        
        print num_page
        
    df = pd.DataFrame({ 'name' : total_names,
                        'link' : total_links,
                        'price': total_prices,
                        'address' : total_addresses,
                        'longitude' : total_longitude,
                        'latitude' : total_latitude})
        
    return(df)
        
def menu_to_words(html_menu, base_url):

    # loop through list (keep only first 2, then move on to make sure it works
    
    # Function to convert a menupages link to a list of food words
    # The input is a single string (html menu pages)
    # The output is a single string (preprocessed menu)
    
    # 1. Scrape menupages page
    
    menu_request = urllib2.Request(base_url + html_menu + 'menu')
    menu_request.add_header('User-agent', 'Mozilla/5.0 (Linux i686)')
    menu_response = urllib2.urlopen(menu_request).read()
    menu_soup = BeautifulSoup(menu_response)
    all_food = menu_soup.find_all('th')

    # 0 to 6 is always dollar amounts, so I can skip them

    the_food = []
    for the_line in range(7, len(all_food)):
        the_food.append(all_food[the_line].text)
    
    the_menu = ' '.join(the_food)
    
    # 2. Remove non-letters
    
    the_menu_letters = re.sub("[^a-zA-Z\'\"]", " ", the_menu)
    
    # 3. Convert to lower case, split into individual words
    
    lower_case = the_menu_letters.lower()
    words = lower_case.split()
    
    # 4. Remove stopwords (add later as an optional argument)
    
    words = [w for w in words if not w in stopwords.words("english")]
    
    # 5. Join the words
    
    return(' '.join(words))
    
def get_menu_tags(html_menu, base_url):

    # Function to convert extract tag information from a menupages link
    # The input is a single string (html menu pages)
    # The output is a single string of tags (to be cleaned in R)
    # Tag function added after, incorporate with menu_to_words to make it quicker
    
    menu_request = urllib2.Request(base_url + html_menu + 'menu')
    menu_request.add_header('User-agent', 'Mozilla/5.0 (Linux i686)')
    menu_response = urllib2.urlopen(menu_request).read()
    menu_soup = BeautifulSoup(menu_response)
    tags = re.findall("setTargeting\('cuisine'.*", str(menu_soup))
    features = re.findall("Gluten Free Items", str(menu_soup))
    
    return([tags, features])

 
if __name__ == "__main__":

    base_url = 'http://boston.menupages.com'

    # Scrape restaurant information and save in the database
    
    restaurant_data = get_restaurant_info("http://boston.menupages.com/restaurants/all-areas/all-neighborhoods/all-cuisines/", base_url)
    
    tags_and_features = []

    for i in range(len(restaurant_data['link'])):
        tags_and_features.append(get_menu_tags(restaurant_data['link'][i], base_url)) 
        print i
        
        
    restaurant_tags = [item[0] for item in tags_and_features]
    restaurant_features = [item[1] for item in tags_and_features]
    clean_features = [1 if 'Gluten Free Items' in x else 0 for x in restaurant_features]
    
    restaurant_data.loc[:,('tags')] = restaurant_tags
    restaurant_data.loc[:,('isGluten')] = clean_features
    
    restaurant_data.to_csv("../Data/restaurant_info.csv")
    
    # Scrape menu info to create a bag of words and save in the database
    
    clean_menus = []

    # If this freezes, run in ipython to make it through the whole loop
    
    for i in range(len(restaurant_data['link'])):
        clean_menus.append(menu_to_words(restaurant_data['link'][i], base_url))
        print i
        sleep(5)
        
    # Initialize the "CountVectorizer" object, which is scikit-learn's bag of words tool.  
    vectorizer = CountVectorizer(analyzer = "word",   \
                                 tokenizer = None,    \
                                 preprocessor = None, \
                                 stop_words = None,   \
                                 max_features = 5000) 

    train_data_features = vectorizer.fit_transform(clean_menus)
    train_data_features = train_data_features.toarray()
    
    food_df = pd.DataFrame(train_data_features, columns = CountVectorizer.get_feature_names(vectorizer), index = restaurant_data['link'])
    food_df.to_csv("../Data/menu_words.csv")

    
    
    