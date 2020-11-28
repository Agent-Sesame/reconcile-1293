rec_roth_pos <- function() {
  
  # load required package
  
  library(dplyr)
  
  # call roth position import functions
  
  bkr_roth_pos()
  qpf_roth()

  # join quicken position and broker position data
  
  compare_positions <<- full_join(df_qpf_r_posi, 
                                  df_bkr_r_pos, 
                                  by = "keypos")
  
  # when i have NA values appearing from a mismatch, insert a chunk of code 
  # this piece TBD
  
  # save reconciliation output
  
  setwd("~/Documents/finances/2020-R01/COSTBASIS/4 reconciliation/1293/pos")
  write.csv(compare_positions, "Reconciliation_Roth_Positions.csv")
  
  # return working directory to code source github repo
  
  setwd("/Users/airvanilla/Github/quicken-positon/")
  
}
