#############################################################
# plotNames:
# function to plot multiple names by trajectory over years
# @param inputNames - the string of names
# @param inputSex - a vector of selected sex
# @param bottomYear - the lower bound of year
# @param topYear - the upper bound of year

load("data/babynames.rdata")

plotNames <- function(inputNames, inputSex, bottomYear, topYear){
  
  bottomYear <- as.numeric(bottomYear)
  topYear <- as.numeric(topYear)
  
  totalNames <- nameSplitter(inputNames)
  
  nameSummary <- filter(babynames, name %in% totalNames, sex %in% inputSex)
  
  if(nrow(nameSummary) == 0) {
    
    "empty"
    
  } else {
    
    cbbPalette <- c("#009E73", "#56B4E9", "#F0E442", "#E69F00", "#000000", "#0072B2", "#D55E00", "#CC79A7")
    
    if(length(inputSex) == 1){
      
      ggplot(data = nameSummary, aes(x = year, y = prop)) + geom_line(aes(colour = name), size = 2) + scale_colour_manual(values = cbbPalette) + 
        scale_x_continuous(limits = c(bottomYear, topYear), breaks = seq(from = bottomYear, to = topYear, by = 10)) +
        labs(x = 'Year', y = 'Proportion', colour = 'Name') + theme_bw()
      
    } else if(length(inputSex) == 2){
      
      nameSummary$sex <- Recode(nameSummary$sex, "'M' = 'Male'; 'F' = 'Female'", as.factor.result = FALSE)
      
      ggplot(data = nameSummary, aes(x = year, y = prop)) + geom_line(aes(colour = name), size = 2) + scale_colour_manual(values = cbbPalette) + 
        scale_x_continuous(limits = c(bottomYear, topYear), breaks = seq(from = bottomYear, to = topYear, by = 10)) + facet_grid(. ~ sex) + 
        labs(x = 'Year', y = 'Proportion', colour = 'Name') + theme_bw()
      
    }
    
  }

}


