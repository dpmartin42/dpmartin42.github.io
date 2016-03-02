library(shiny)
library(leaflet)

shinyUI(navbarPage("Food Findr", 
 tabPanel("Interactive Map",
          
    div(class = "outer",

        tags$head(
          
          includeCSS("styles.css"),
          includeCSS("bootstrap.min.css"),
          includeScript("google-analytics.js")
          
          ),
        
        leafletOutput("mymap", width = "80%", height = "100%"),
        
        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                      draggable = FALSE, top = 50, left = "auto", right = 0,
                      width = "20%", height = "100%",
                      
                      br(),
                      
                      textInput("address", label = "Enter your address", 
                                value = "e.g., 50 Milk Street"),
                            
                      tags$hr(),
                            
                      sliderInput("distance", label = "Max distance (in mi.)", min = 0.1, 
                                  max = 3.0, value = 0.5),
                            
                      tags$hr(),
                            
                      checkboxGroupInput("price", 
                                         label = "Price preference", 
                                         choices = list("$" = "$", 
                                                        "$$" = "$$",
                                                              "$$$" = "$$$",
                                                              "$$$$" = "$$$$",
                                                              "$$$$$" = "$$$$$"),
                                               selected = c("$", "$$", "$$$", "$$$$", "$$$$$")),
                      
                      tags$hr(),
                      
                      checkboxGroupInput("restrictions", 
                                         label = "Dietary restrictions", 
                                         choices = list("Vegetarian-friendly" = "vegetarian-friendly", 
                                                        "Vegan" = "vegan",
                                                        "Gluten-free" = "gluten-free"),
                                         selected = c()),
                            
                      tags$hr(),
                            
                      submitButton("Update View")
              )
          )
 ),
 tabPanel("Restaurant Explorer", dataTableOutput("restaurants")),
 tabPanel("Slides",
          tags$iframe(src = "https://docs.google.com/presentation/embed?id=1QemHAqv_vbBhpe09lYs_7l-f0FlS8u2g2YXWrdvxcio&amp;start=false&amp;loop=false&amp;",
                      frameborder = "0",
                      width = "960",
                      height = "569",
                      allowfullscreen = TRUE,
                      mozallowfullscreen = TRUE,
                      webkitallowfullscreen = TRUE)
          )
  
))

