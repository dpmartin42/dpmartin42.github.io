library(shiny)

shinyUI(fluidPage(
  titlePanel("School SelectR"),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("This is an application to help recommend college institutions that best match a set of search criteria. Feel free
                to enter your college preferences regarding geographic region, size, sector, total annual cost for out of state
                students, selectivity, and graduation rate. You can also select how important each preference is for your decision
                to improve the matching process. Once you have finished selecting, click the Update View button at the bottom of
                the page to see the results!"),
      
      tags$hr(),

      selectInput("region", 
                  label = "Choose a region",
                  choices = list("New England", "Mid East", "Southeast", "Great Lakes", "Plains",
                                 "Rocky Mountains", "Far West", "Southwest", "US Service schools"),
                  selected = "New England"),
      
      radioButtons("region_weight",
                   label = "How important is region for your college choice?",
                   choices = list("Not important at all" = 0, "Somewhat important" = 0.5, "Very important" = 1), 
                   selected = 1,
                   inline = TRUE),

      tags$hr(),
      
      selectInput("size", 
                  label = "Choose a college size",
                  choices = list("Under 1,000", "1,000 - 4,999", "5,000 - 9,999",
                                 "10,000 - 19,999", "20,000 and above"),
                  selected = "10,000 - 19,999"),
      
      radioButtons("size_weight",
                   label = "How important is size for your college choice?",
                   choices = list("Not important at all" = 0, "Somewhat important" = 0.5, "Very important" = 1), 
                   selected = 1,
                   inline = TRUE),
      
      tags$hr(),
      
      selectInput("sector", 
                  label = "Choose a college sector",
                  choices = list("Public, 4-year or above", "Private not-for-profit, 4-year or above"),
                  selected = "Public, 4-year or above"),
      
      radioButtons("sector_weight",
                   label = "How important is sector for your college choice?",
                   choices = list("Not important at all" = 0, "Somewhat important" = 0.5, "Very important" = 1), 
                   selected = 1,
                   inline = TRUE),
      
      tags$hr(),
      
      selectInput("total.outstate.price", 
                  label = "Total cost per year (out of state)",
                  choices = list("< $19,999", "$20,000 - $29,999", "$30,000 - $39,999", "$40,000 - $49,999", "$50,000+"),
                  selected = "$30,000 - $39,999"),
      
      radioButtons("price_weight",
                   label = "How important is cost for your college choice?",
                   choices = list("Not important at all" = 0, "Somewhat important" = 0.5, "Very important" = 1), 
                   selected = 1,
                   inline = TRUE),
      
      tags$hr(),
      
      selectInput("percent.admit", 
                  label = "Percentage of students admitted",
                  choices = list("< 29", "30 - 49", "50 - 69", "70 - 89", "90+"),
                  selected = "50 - 69"),
      
      radioButtons("admit_weight",
                   label = "How important is selectivity for your college choice?",
                   choices = list("Not important at all" = 0, "Somewhat important" = 0.5, "Very important" = 1), 
                   selected = 1,
                   inline = TRUE),

      tags$hr(),
      
      selectInput("grad.rate", 
                  label = "Graduation percentage (in 6 years)",
                  choices = list("90+", "70 - 89", "50 - 69", "30 - 49", "< 29"),
                  selected = "90+"),
      
      radioButtons("grad_weight",
                   label = "How important is graduate rate for your college choice?",
                   choices = list("Not important at all" = 0, "Somewhat important" = 0.5, "Very important" = 1), 
                   selected = 1,
                   inline = TRUE),
      
      tags$hr(),
      
      submitButton("Update View")

    ),

    mainPanel(dataTableOutput("colleges"))
    
  )
))

