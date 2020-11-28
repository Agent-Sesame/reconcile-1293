cb_roth_trans <- function() {

  setwd("~/Documents/finances/2020-R01/COSTBASIS/3 transactions/R-1293")  

  keytrans <- list.files(recursive = FALSE)
  
  columnv2 <- rep("mac data", length(keytrans))
  
  columnv2 <- as.data.frame(columnv2, stringsAsFactors = FALSE)
  
  keytrans <- as.data.frame(keytrans, stringsAsFactors = FALSE)

  keytrans <<- cbind.data.frame(keytrans, columnv2, stringsAsFactors = FALSE)
  
}


