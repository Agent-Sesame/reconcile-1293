bkr_roth_lots <- function() {
 
  # load required data manipulation packages
  
  library(dplyr)  # required for the mutate and group functions
  library(taRifx) # required by remove.factors function
  
  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "2 schwab/lots/1293", sep = ""))
  
  # import and clean schwab inv lot data, position data not in this file. note
  # column widths may be variable and need subsequent tweaks.... greeeeat.
  
  df_bkr <- read.csv(list.files(pattern = "\\.csv"))
  
  # drop unneeded columns
  
  df_bkr <- df_bkr[c(1:3, 5)]
  
  # rename columns
  
  colnames(df_bkr) <- c("bkr.sym", "bkr.date", "bkr.lots", "bkr.cost")
  
  # remove white spaces, dollar signs signs, then commas
  
  df_bkr <- as.data.frame(apply(df_bkr, 2, function(x) gsub("\\s+", "", x)), 
                          stringsAsFactors = FALSE)
  df_bkr <- as.data.frame(apply(df_bkr, 2, function(x) gsub("\\$", "", x)), 
                          stringsAsFactors = FALSE)
  df_bkr <- as.data.frame(apply(df_bkr, 2, function(x) gsub("\\,", "", x)), 
                          stringsAsFactors = FALSE)

  # drop last junk row
  
  df_bkr <- df_bkr[1:dim(df_bkr)[1] - 1, ]
  
  # create charater vector of bad format brk.sym for later mutate use
  
  columnV1 <- df_bkr$bkr.sym
  
  # create data frame of isolated bad formatted data to mutate
  
  df_fix <- cbind.data.frame(columnV1)
  
  # mutate df_fix with columnV1 character vector as input
  
  df_fix <- (df_fix
                %>% mutate(grp = cumsum( "" != columnV1 ) )
                %>% group_by(grp)
                %>% mutate(columnV1 = columnV1[1])
                %>% ungroup()
                %>% select(-grp))

  # remove slashes from df_fix to change brk/b to brkb, quicken can not match
  # schwab's symbol format
  
  df_fix <- as.data.frame(apply(df_fix, 2, function(x) gsub("/", "", x)), 
                          stringsAsFactors = FALSE)

  # cbind the fixed symbol column with original data frame
  
  df_bkr <- cbind.data.frame(df_fix, df_bkr)
  
  # fix column names with new symbol column
  
  colnames(df_bkr) <- c("bkr.sym2", 
                        "bkr.sym", 
                        "bkr.date", 
                        "bkr.lots", 
                        "bkr.cost")
  
  # subset by only those rows with empty value
  
  df_bkr <- df_bkr[which(df_bkr$bkr.sym == ""), ]
  
  # subset by only those row without value OpenDate
  
  df_bkr <- df_bkr[which(df_bkr$bkr.date != "OpenDate"), ]
  
  # drop old symbol column now that new symbol column created and appended
  
  df_bkr <- df_bkr[c(1, 3:5)]
  
  # create correctly formatted date column

  df_bkr_date <- as.Date(df_bkr$bkr.date, "%m/%d/%Y")
  
  # create vector of 0.00000 formatted shares, roth ira only needed 0.000 format
  # but because of google position, the inv account requires 4 decimal places 
  
  vector_td <- as.numeric(df_bkr$bkr.lots)
  vector_td <- format(vector_td, nsmall = 4)
  vector_td <- trimws(vector_td)

  # create new data frame with reconciliation key
  
  df_bkr_lots <<- cbind.data.frame(bkr.date = df_bkr_date,
                                   bkr.sym = df_bkr$bkr.sym2,
                                   bkr.share = vector_td,
                                   bkr.cost = df_bkr$bkr.cost,
                                   keylots = paste(df_bkr_date,
                                             df_bkr$bkr.sym2,
                                             vector_td,
                                             df_bkr$bkr.cost),
                                   stringsAsFactors = FALSE)

}
