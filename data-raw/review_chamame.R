## code to prepare `review_chamame` dataset goes here

library(tidyverse)
library(moranajp)
data(review)
review %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  readr::write_tsv("tools/review_2.txt", col_names = FALSE)

  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # WORK with hands
  # 
  # ANALYZE in https://chamame.ninjal.ac.jp/index.html
  # 
  # RENAME downloaded data (csv with UTF-8 encoding)into "review.csv"
  # 
  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 

review_chamame <-
  readr::read_csv("tools/review.csv") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(review_chamame, overwrite = TRUE)
  # usethis::use_data_raw("review_chamame")
