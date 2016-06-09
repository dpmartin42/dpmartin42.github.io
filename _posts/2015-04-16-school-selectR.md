---
layout: post
title: School SelectR
---

To get more experience with recommendation engines, I decided to try and create one using publicly available data from the National Center of Education statistics on college institutional characteristics. The end product is a [content-based recommendation engine](http://en.wikipedia.org/wiki/Recommender_system#Content-based_filtering) designed to take user input and output a table listing 4-year private and public colleges that best match this input. The recommendations are based on the [Gower dissimilarity index](https://stat.ethz.ch/R-manual/R-patched/library/cluster/html/daisy.html), which can take variables of multiple types and also allows unique variable weights. The final result is an index on a scale from 0 to 1, where 1 represents a perfect match.

Data were taken from the publicly available [IPEDS](http://nces.ed.gov/ipeds/datacenter/), from the National Center for Education Statistics. Only a small subset of variables were used in the matching process for simplicity, and are the following: 

 - geographic region
 - size
 - sector (i.e., public or private)
 - total price for out-of-state students living off campus (not with family)
 - percent admitted - total
 - Graduation rate total cohort	after 6 years

This application was built using R and Shiny, and can be seen [here](https://dpmartin42.shinyapps.io/college-choice-app/). The defaults were set according to my preferences back in the day when I was thinking about what colleges to apply to. All the schools I applied to are actually shown in the top 10 with my alma mater coming in at number 8, which is a nice little validation check with respect to the matching algorithm. As always, the relevant code and data for this application can be seen on [GitHub](https://github.com/dpmartin42/school-selectR).