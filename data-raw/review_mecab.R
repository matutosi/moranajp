## code to prepare `review_mecab` dataset goes here

library(tidyverse)
devtools::load_all(".")
data(review)

bin_dir <- "d:/pf/mecab/bin/"
review_mecab <- 
  review %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = "CP932_UTF-8") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(review_mecab, overwrite = TRUE)
  # usethis::use_data_raw("review_mecab")
