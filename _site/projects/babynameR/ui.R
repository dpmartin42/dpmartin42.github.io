shinyUI(fluidPage(
  titlePanel("babynameR"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("This is an application to visualize and explore the popularity of babynames provided by the Social Security Administration. Names 
               must be used at least five times in one year in order to be reported. Up to eight (8) names can be plotted at once, and must be
               separated by commas (i.e., George, Michael, Anne). Sex can either be male, female, or both (resulting in two separate graphs),
               and the date can range from 1875 to 2013."),
      
      br(),
      
      helpText("Additionally, both male and female names that are similar to the first name in the search sequence will be output below the
               graph in a table, sorted by popularity at the upper bound indicated in year range. When you change your search criteria, 
               click the \"Update\" button. Please be patient, as it takes a few seconds to load."),
      
      br(),
      
      textInput("name", value = "Mary", label = h4("Name(s)")), 
      
      br(),
      
      checkboxGroupInput("sex", 
                         label = h4("Sex"), 
                         choices = list("Male" = "M", 
                                        "Female" = "F"),
                         selected = "F"),
      
      br(),
      
      dateRangeInput("yearRange", label = h4("Year range"), start = "1875-01-01", end = "2013-01-01",
                     min = "1875-01-01", max = "2013-01-01", format = "yyyy",
                     startview = "decade",
                     separator = " to "),
      
      submitButton("Update"),
      
      br(),
      
      helpText(a("View the code on GitHub", href = "https://github.com/dpmartin42/babynameR", target = "_blank"))
      
      ),
    
    mainPanel(plotOutput("plot", width = "900px", height = "500px"),
              
              tabsetPanel(
                tabPanel('Boys',
                         dataTableOutput("tableBoys")),
                tabPanel('Girls',
                         dataTableOutput("tableGirls"))
              )
              
    )
    
    )
  ))