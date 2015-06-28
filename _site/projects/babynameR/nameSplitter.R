#############################################################
# nameSplitter:
# function to split the input name string into a vector of names
# @param inputNames - the string of names

nameSplitter <- function(inputNames){
  
  splitNames <- gsub("( )?,( )?", ",", inputNames)
  totalNames <- strsplit(splitNames, split = ",")[[1]]
  
  return(totalNames)
 
}

