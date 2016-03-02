'''
Author: Dan Martin
Date: 7/14/15
Title: Read in .csv created in R as a python DataFrame and create a 
       SQL database for the flask app
'''

import pandas as pd
import MySQLdb

def pandas_to_sql(df, database, table):

    # doesn't work, save for later
    # db = MySQLdb.connect(read_default_file = "~/.my.cnf")
    
    db = MySQLdb.connect(host = 'foodfindrdb.cjpar6fexhjn.us-east-1.rds.amazonaws.com',
                         user = 'danmartin',
                         passwd = 'password')     

    db.query('CREATE DATABASE IF NOT EXISTS ' + database + ';')
    db.query('USE ' + database + ';')                                                                                                                                                                                    
    the_data.to_sql(name = table,
                    con = db,
                    flavor = 'mysql',
                    if_exists = 'replace')                                                                                                                                                     
    db.close()
    
    return

if __name__ == "__main__":
    
    # Read in data
    the_data = pd.read_csv("../Data/restaurant_ratings.csv")

    the_data.columns = ['name', 'address', 'latitude',
    'longitude', 'link', 'price', 'health_color', 'special_diet']
    
    pandas_to_sql(the_data, 'food_db', 'food_tb')
                                

