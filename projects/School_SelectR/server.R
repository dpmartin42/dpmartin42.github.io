library(shiny)
library(car)

source("create_table.R")

shinyServer(function(input, output) {
  
  output$colleges <- renderDataTable({
    
    price <- Recode(input$total.outstate.price,
                    "'< $19,999' = 15000;
                  '$20,000 - $29,999' = 25000;
                  '$30,000 - $39,999' = 35000;
                  '$40,000 - $49,999' = 45000;
                  '$50,000+' = 55000",
                    as.factor.result = FALSE)
    
    admit <- Recode(input$percent.admit,
                    "'< 29' = 20;
                  '30 - 49' = 40;
                  '50 - 69' = 60;
                  '70 - 89' = 80;
                  '90+' = 95",
                    as.factor.result = FALSE)
    
    grad <- Recode(input$grad.rate,
                    "'< 29' = 20;
                  '30 - 49' = 40;
                  '50 - 69' = 60;
                  '70 - 89' = 80;
                  '90+' = 95",
                    as.factor.result = FALSE)
    
    create_table(input$region,
                 price,
                 admit,
                 input$size,
                 input$sector,
                 grad,
                 input$region_weight,
                 input$price_weight,
                 input$admit_weight,
                 input$size_weight,
                 input$sector_weight,
                 input$grad_weight)

  },
  
  options = list(pageLength = 10))
  
})
