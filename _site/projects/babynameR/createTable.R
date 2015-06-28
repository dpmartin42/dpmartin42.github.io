#############################################################
# createTable:
# function to create a table of similar names (both genders)
# @param inputNames - the string of names
# @param inputSex - a vector of selected sex
# @param topYear - the upper bound of year

createTable <- function(inputNames, inputSex, topYear){
  
  totalNames <- unique(babynames$name)[agrep(inputNames[1], unique(babynames$name), max = list(all = 1))]
  
  commonBoyNames <- filter(babynames, name %in% totalNames, sex == 'M', year == topYear)
  commonGirlNames <- filter(babynames, name %in% totalNames, sex == 'F', year == topYear)
  
  names(commonBoyNames) <- c("Year", "Sex", "Name", "Count", "Proportion")
  names(commonGirlNames) <- c("Year", "Sex", "Name", "Count", "Proportion")
  
  return(list(commonBoyNames, commonGirlNames))
 
}

