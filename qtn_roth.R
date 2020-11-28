qtn_roth <- function() {
  
  # import quicken roth transaction ledger
  
  setwd("~/Documents/finances/2020-R01/COSTBASIS/1 quicken/inv/tn/R-1293")
  df_qtn <- read.csv(list.files(pattern = "\\.csv"),
                     header = FALSE,
                     skip = 8,
                     stringsAsFactors = FALSE)
  
  # rename columns
  
  colnames(df_qtn) <- c("V1",
                        "V2",
                        "V3",
                        "date",
                        "type",
                        "security",
                        "symbol",
                        "description",
                        "shares out",
                        "shares in",
                        "shares",
                        "clr",
                        "costbasis",
                        "amount",
                        "balance",
                        "memo") 
  
  # drop unneeded columns
  
  df_qtn <- df_qtn[, c(4, 7, 11, 13)]
  
  # drop junk lines at end
  
  df_qtn <- df_qtn[1:(dim(df_qtn)[1]-5), ]
  
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
  
  # create expected file structure data key
  
  keytrans <- paste(vectordate, df_qtn$symbol, df_qtn$shares, df_qtn$costbasis)
  
  # trim trailing whitespace from keytrans
  
  keytrans <- trimws(keytrans, which = c("right"), whitespace = "[ \t\r\n]")
  
  
  df_qtn <<- cbind.data.frame(df_qtn, 
                              keytrans,
                              stringsAsFactors = FALSE)
  
}
