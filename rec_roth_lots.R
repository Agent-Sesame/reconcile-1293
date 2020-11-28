rec_roth_lots <- function() {
  
  # load required package
  
  library(dplyr)
  
  # call roth lots import functions
  
  bkr_roth_lots()
  qpf_roth()
  
  # join quicken lot and broker lot data. 
  
  compare_lots <<- full_join(df_bkr_lots,
                             df_qpf_r_lots,
                             by = "keylots")
  
  # when i have NA values appearing from a mismatch, insert a chunk of code 
  
  # save reconciliation output
  
  setwd("~/Documents/finances/2020-R01/COSTBASIS/4 reconciliation/1293/lots")
  write.csv(compare_lots, "Reconciliation_Roth_Lots.csv")
  
  # return working directory to code source github repo
  
  setwd("/Users/airvanilla/Github/quicken-positon/")
  
}
