rec_roth_trans <- function() {
  
  # load required package
  
  library(dplyr) #required for full_join function
  
  # call investment transaction import functions
  
  cb_roth_trans()
  qtn_roth()
  
  # join quicken transaction and hard drive transaction directories
  
  compare_trans <<- full_join(df_qtn, 
                              keytrans, 
                              by = "keytrans")
  
  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "4 reconciliation/1293/trans", sep = ""))

  # save reconciliation output
  
  write.csv(compare_trans, "Reconciliation_Roth_Transactions.csv")
  
  # return working directory to code source github repo
  
  setwd("~/Github/reconcile-1293 roth")

}
