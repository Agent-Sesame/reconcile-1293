rec_roth_trans <- function() {
  
  # load required package
  
  library(dplyr) #required for full_join function
  
  # call roth transaction import functions
  
  cb_roth_trans()
  qtn_roth()
  
  # join quicken transaction and hard drive transaction directories
  
  compare_trans <<- full_join(df_qtn, 
                              keytrans, 
                              by = "keytrans")
  
  # save reconciliation output
  
  setwd("~/Documents/finances/2020-R01/COSTBASIS/4 reconciliation/1293/trans")
  write.csv(compare_trans, "Reconciliation_Roth_Transactions.csv")
  
  # return working directory to code source github repo
  
  setwd("/Users/airvanilla/Github/quicken-positon/")

}
