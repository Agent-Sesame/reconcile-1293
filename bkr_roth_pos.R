bkr_roth_pos <- function() {

  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "2 schwab/pos/1293", sep = ""))
  
  # import and clean schwab investment position data. lot data not in this file
  
  df_bkr <- read.csv(list.files(pattern = "\\.CSV"),
                     header = FALSE,
                     skip = 3,
                     stringsAsFactors = FALSE)
  
  # drop unneeded columns
  
  df_bkr <- df_bkr[, c(1, 3, 10)]
  
  # rename df column names
  
  colnames(df_bkr) <- c("bkr.sym", "bkr.share", "bkr.cost")
  
  # remove white spaces, dollar signs signs, commas, then front slash
  
  df_bkr <- as.data.frame(apply(df_bkr, 2, function(x) gsub("\\s+", "", x)), 
                          stringsAsFactors = FALSE)
  df_bkr <- as.data.frame(apply(df_bkr, 2, function(x) gsub("\\$", "", x)), 
                          stringsAsFactors = FALSE)
  df_bkr <- as.data.frame(apply(df_bkr, 2, function(x) gsub("\\,", "", x)), 
                          stringsAsFactors = FALSE)
  df_bkr <- as.data.frame(apply(df_bkr, 2, function(x) gsub("\\/", "", x)), 
                          stringsAsFactors = FALSE)
  
  # create vector of 0.00000 formatted shares
  
  vector_td <- as.numeric(df_bkr$bkr.share)
  vector_td <- format(vector_td, nsmall = 4)
  vector_td <- trimws(vector_td)
  
  # create quicken reconciliation object with unique key
  
  df_bkr <- cbind.data.frame(bkr.sym = df_bkr$bkr.sym,
                             bkr.share = vector_td,
                             bkr.cost = df_bkr$bkr.cost,
                             keypos = paste(df_bkr$bkr.sym,
                                               vector_td,
                                               df_bkr$bkr.cost),
                             stringsAsFactors = FALSE)
  
  # remove junk lines at end
  
  df_bkr_i_pos <<- df_bkr[1:(dim(df_bkr)[1]-2), ]

}
