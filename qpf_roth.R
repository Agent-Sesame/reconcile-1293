qpf_roth <- function() {

  # set working directory for data import
  
  source('~/Github/reconcile-condo/year_path.R')
  setwd(paste(year_path(), "1 quicken/inv/pf/R-1293", sep = ""))
  
  # import and clean quicken investment position and cost lot data.
  
  df_qpf <- read.csv(list.files(pattern = "\\.csv"),
                     header = FALSE,
                     sep = ",",
                     skip = 7,
                     strip.white = TRUE,
                     stringsAsFactors = FALSE)
  
  # drop unneeded columns
  
  df_qpf <- df_qpf[, c(1, 2, 3, 6, 7)]

  # rename df column names
  
  colnames(df_qpf) <- c("qpf.date", "qpf.sym", "qpf.quote", 
                        "qpf.share", "qpf.cost")

  # first column qpf.date has a zero width invisible character at the head that 
  # interferes with the as.Date function. this next chunk of code creates a
  # clean date vector.
  
  qpf.date2 <- as.Date(gsub("^\\s+|\\s+$",
                            "",
                            substr(df_qpf$qpf.date, 2, nchar(df_qpf$qpf.date))),
                            "%m/%d/%Y")
  
  # bind clean date vector to df_qpf

  df_qpf <- cbind.data.frame(df_qpf, qpf.date2 = qpf.date2,
                             stringsAsFactors = FALSE)

  # remove white spaces, dollar signs signs, then commas
  
  df_qpf <- as.data.frame(apply(df_qpf, 2, function(x) gsub("\\s+", "", x)), 
                          stringsAsFactors = FALSE)
  df_qpf <- as.data.frame(apply(df_qpf, 2, function(x) gsub("\\$", "", x)), 
                          stringsAsFactors = FALSE)
  df_qpf <- as.data.frame(apply(df_qpf, 2, function(x) gsub("\\,", "", x)), 
                          stringsAsFactors = FALSE)

  # create vector of 0.0000 formatted shares, roth ira only needed 0.000 format
  # but because of google position, the inv account requires 4 decimal places 
  
  vector_td <- as.numeric(df_qpf$qpf.share)
  vector_td <- format(vector_td, nsmall = 4)
  vector_td <- trimws(vector_td)
  
  # create quicken reconciliation object with unique key
  
  df_qpf <- cbind.data.frame(df_qpf,
                              keylots = paste(df_qpf$qpf.date2,
                                              df_qpf$qpf.sym,
                                              vector_td,
                                              df_qpf$qpf.cost),
                              keypos = paste(df_qpf$qpf.sym,
                                             vector_td,
                                             df_qpf$qpf.cost),
                              stringsAsFactors = FALSE)

  # remove junk lines at end - this next line caused an error temp commented out
  
  df_qpf <- df_qpf[1:(dim(df_qpf)[1]-1), ]

  # create cost lot and position dfs based on df_qpf
  
  df_qpf_i_pos <- df_qpf[is.na(df_qpf$qpf.date2), ]
  df_qpf_i_lots <- df_qpf[!is.na(df_qpf$qpf.date2), ]

  # remove df_qpf data frame and qpf.date2 clean date vector
  
  remove(df_qpf)
  remove(qpf.date2)
  
  # drop unneeded columns from quicken investment position data frame
  
  df_qpf_i_pos <<- df_qpf_i_pos[, c(2, 4, 5, 8)]
  
  # drop uneeded columns from the quicken investment cost lot data frame
  
  df_qpf_i_lots <<- df_qpf_i_lots[ , c(2, 4, 5, 6, 7)]

}
