require(shiny)
require(devtools)
require(ggplot2)
require(dplyr)

source("plotNames.R")
source("createTable.R")
source("nameSplitter.R")

shinyServer(
  function(input, output) {
    
    output$plot <- renderPlot({
      
      p <- plotNames(input$name, input$sex, format(input$yearRange[1], "%Y"), format(input$yearRange[2], "%Y"))
      
      totalNames <- nameSplitter(inputNames); nameSummary <- filter(babynames, name %in% totalNames, sex %in% inputSex)
      
      validate(
        need(p != "empty", "I'm sorry, no names that you entered appear in this dataset. This means that all of them appear
             less than five times per year for whatever sex you indicated.")
        )
      
      p
      
    })
    
    output$tableBoys <- renderDataTable({
      
      boyTable <- as.data.frame(createTable(nameSplitter(input$name)[1], input$sex, format(input$yearRange[2], "%Y"))[[1]])
      
      validate(
        need(nrow(boyTable) != 0, "I'm sorry, the first name you entered does not have any similar boys names in the dataset.")
      )
      
      boyTable
      
    }, options = list(aLengthMenu = c(10, 25, 50), iDisplayLength = 10))
    
    output$tableGirls <- renderDataTable({
      
      girlTable <- as.data.frame(createTable(nameSplitter(input$name)[1], input$sex, format(input$yearRange[2], "%Y"))[[2]])
      
      validate(
        need(nrow(girlTable) != 0, "I'm sorry, the first name you entered does not have any similar girls names in the dataset.")
        )
      
      girlTable
      
    }, options = list(aLengthMenu = c(10, 25, 50), iDisplayLength = 10))
    
  }
)