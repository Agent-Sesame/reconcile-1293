cb_roth_trans <- function() {
  
  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "3 transactions/R-1293", sep = ""))

  # list directories in cost basis transaction directory  
  
  keytrans <- list.files(recursive = FALSE)
  
  # create placeholder vector the lenth of keytrans
  
  columnv2 <- rep("mac data", length(keytrans))
  
  # convert columnv2 placeholder vector into a data frame
  
  columnv2 <- as.data.frame(columnv2, stringsAsFactors = FALSE)
  
  # convert keytrans vector into a data frame
  
  keytrans <- as.data.frame(keytrans, stringsAsFactors = FALSE)
  
  # bind columnv2 and keytrans into a single data frame
  
  keytrans <<- cbind.data.frame(keytrans, columnv2, stringsAsFactors = FALSE)

}
