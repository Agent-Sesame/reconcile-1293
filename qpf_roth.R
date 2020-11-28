qpf_roth <- function() {

  # import and clean quicken roth ira position and cost lot data.
  
  setwd("~/Documents/finances/2020-R01/COSTBASIS/1 quicken/inv/pf/R-1293")
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

  # create quicken reconciliation object with unique key
  
  df_qpf <- cbind.data.frame(df_qpf,
                              keylots = paste(df_qpf$qpf.date2,
                                              df_qpf$qpf.sym,
                                              df_qpf$qpf.share,
                                              df_qpf$qpf.cost),
                              keypos = paste(df_qpf$qpf.sym,
                                             df_qpf$qpf.share,
                                             df_qpf$qpf.cost),
                              stringsAsFactors = FALSE)

  # remove junk lines at end
  
  df_qpf <- df_qpf[1:(dim(df_qpf)[1]-2), ]

  ##### create cost lot and position dfs based on df_qpf
  
  df_qpf_r_lots <- df_qpf[is.na(df_qpf$qpf.quote), ]
  df_qpf_r_posi <- df_qpf[!is.na(df_qpf$qpf.quote), ]

  # remove first data frame and clean date vector
  
  remove(df_qpf)
  remove(qpf.date2)
  
  # drop unneeded columns from quicken roth position data frame
  
  df_qpf_r_posi <<- df_qpf_r_posi[, c(2, 4, 5, 8)]
  
  # drop uneeded columns from the quicken roth cost lot data frame
  
  df_qpf_r_lots <<- df_qpf_r_lots[, c(6, 2, 4, 5, 7)]

}
