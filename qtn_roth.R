qtn_roth <- function() {

  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "1 quicken/inv/tn/R-1293", sep = ""))
  
  # import quicken investment transaction ledger
  
  df_qtn <- read.csv(list.files(pattern = "\\.csv"),
                     header = FALSE,
                     skip = 7,
                     stringsAsFactors = FALSE)

  # drop unneeded columns
  
  df_qtn <- df_qtn[, c(4, 7, 11, 13)] #date, sym, shs, cb

  # rename columns
  
  colnames(df_qtn) <- c("date",
                        "symbol",
                        "shares",
                        "costbasis")
  
  # drop junk lines at end
  
  df_qtn <- df_qtn[1:(dim(df_qtn)[1]-3), ]
  
  # drop lines not related to cost basis change activity
  
  df_qtn <- df_qtn[which(df_qtn$symbol != ""), ]
  
  # reformatted date vector
  
  vectordate <- as.Date(df_qtn$date, "%m/%d/%Y")

  # remove white spaces, dollar signs signs, then commas
  
  df_qtn <- as.data.frame(apply(df_qtn, 2, function(x) gsub("\\s+", "", x)), 
                          stringsAsFactors = FALSE)
  df_qtn <- as.data.frame(apply(df_qtn, 2, function(x) gsub("\\$", "", x)), 
                          stringsAsFactors = FALSE)
  df_qtn <- as.data.frame(apply(df_qtn, 2, function(x) gsub("\\,", "", x)), 
                          stringsAsFactors = FALSE)
  
  # create vector of shares with 0.0000 format
  
  vector_td <- as.numeric(df_qtn$shares)
  vector_td <- format(vector_td, nsmall = 4)
  vector_td <- trimws(vector_td)
  
  # create expected file structure data key
  
  keytrans <- paste(vectordate, df_qtn$symbol, vector_td, df_qtn$costbasis)
  
  # trim trailing whitespace from keytrans
  
  keytrans <- trimws(keytrans, which = c("right"), whitespace = "[ \t\r\n]")
  
  df_qtn <<- cbind.data.frame(df_qtn, 
                              keytrans,
                              stringsAsFactors = FALSE)
  
}
