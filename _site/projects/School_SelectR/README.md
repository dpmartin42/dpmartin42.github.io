# school selectR

This application is a content-based recommendation engine designed to take user input and output a table listing 4-year private and public colleges that best match this input. The recommendations are based on the [Gower dissimilarity index](https://stat.ethz.ch/R-manual/R-patched/library/cluster/html/daisy.html), which can take data of multiple types and also allows unique variable weights. The final result is an index on a scale from 0 to 1, where 1 represents a perfect match.

Data were taken from the publicly available [IPEDS](http://nces.ed.gov/ipeds/datacenter/), from the National Center for Education Statistics. Only a small subset of variables were used in the matching process for simplicity, and are the following: 

 - geographic region
 - size
 - sector (i.e., public or private)
 - total price for out-of-state students living off campus (not with family)
 - percent admitted - total
 - graduation rate total cohort	after 6 years

This application was built using R and Shiny, and can be seen [here](https://dpmartin42.shinyapps.io/college-choice-app/).
