---
layout: post
title: R, Shiny, and Naming Babies
---

As an excuse to play around with the new version of shiny, I decided to try and make an interactive web application to visualize baby naming trends over time. A major consideration when creating an interactive application is creating useful error messages to inform the user when something is not going according to plan.

In the case of visualizing baby naming trends, a major component of interactivity is the ability of the user to search specific names and genders. Because the babynames data is not entirely exhaustive (only names with greater than 5 instances in a given year are included), I had an empty graph pop up for my trend plot and an error message render for my table of frequency counts.

Luckily, with the newer versions of shiny (later than 0.9.1.9008), custom messages to the user can be created with the validation function if a givent conditional is satisfied. In my example, I had a plotting function that returned the string "empty" if the name did not exist in the dataset and a plot if it did. Then, all I needed to do was add a validate function in the server.R file uses the need function with two arguments: the conditional, and the message to be displayed when the conditional is false (NOT true).

You can see the snippet of code that performs this action below:


{% highlight r %}
output$plot <- renderPlot({
  
  p <- plotNames(input$name,
                 input$sex,
                 format(input$yearRange[1], "%Y"),
                 format(input$yearRange[2], "%Y"))
  
  validate(
    need(p != "empty",
         "I'm sorry, no names that you entered appear in this dataset.
         This means that all of them appear less than five times per
         year for whatever sex you indicated."))
      
      p
      
    })
{% endhighlight %}

When I get some more time, I'm hoping to customize the .css in the name entry add even more interactivity in the plot using rCharts. For now, you can see the app deployed to the shinyapps server [here](http://dpmartin42.shinyapps.io/babynameR/), and as always, the code is up on my [GitHub](https://github.com/dpmartin42/babynameR).

For more information regarding the validation function, refer to [this](http://shiny.rstudio.com/articles/validation.html) great tutorial created by the RStudio team. 

