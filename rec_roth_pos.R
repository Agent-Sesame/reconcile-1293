rec_roth_pos <- function() {
  
  # load required package
  
  library(dplyr)
  
  # call investment position import functions
  
  bkr_roth_pos()
  qpf_roth()

  # join quicken position and broker position data
  
  compare_positions <<- full_join(df_qpf_i_pos, 
                                  df_bkr_i_pos, 
                                  by = "keypos")
  
  # create a logical test for na in compare_position
  
  vector_na <- compare_positions$qpf.sym == compare_positions$bkr.sym
  
  # create data frame with vector_na
  
  df_na <- data.frame(vector_na)
  
  # add column to compare_lots with the logical test of df_na
  
  compare_positions <- cbind.data.frame(compare_positions, 
                                   df_na, 
                                   stringsAsFactors = FALSE)  
  
  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "4 reconciliation/1293/pos", sep = ""))

  # save reconciliation output
  
  write.csv(compare_positions, "Reconciliation_Roth_Positions.csv")
  
  # return working directory to code source github repo
  
  setwd("~/Github/reconcile-1293 roth/")
  
}
