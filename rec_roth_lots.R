rec_roth_lots <- function() {
  
  # load required package
  
  library(dplyr)
  
  # call investment lots import functions
  
  bkr_roth_lots()
  qpf_roth()
  
  # join quicken lot and broker lot data. 
  
  compare_lots <- full_join(df_bkr_lots,
                             df_qpf_i_lots,
                             by = "keylots")
  
  # create a logical test for na in compare_lots
  
  vector_na <- compare_lots$bkr.date == compare_lots$qpf.date2
  
  # create data frame with vector_na
  
  df_na <- data.frame(vector_na)
  
  # add column to compare_lots with the logical test of df_na
  
  compare_lots <<- cbind.data.frame(compare_lots, 
                                    df_na, 
                                    stringsAsFactors = FALSE)
  
  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "4 reconciliation/1293/lots", sep = ""))
  
  # save reconciliation output
  
  write.csv(compare_lots, "Reconciliation_Roth_Lots.csv")
  
  # return working directory to code source github repo
  
  setwd("~/Github/reconcile-1293 roth")
  
}
