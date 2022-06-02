## code to prepare `replace_words` dataset goes here

library(tidyverse)
replace_words <-
  readr::read_tsv("tools/replace_words.txt", col_names = TRUE) %>%
  dplyr::mutate_all(stringi::stri_escape_unicode)
usethis::use_data(replace_words, overwrite = TRUE)
usethis::use_data_raw("replace_words")

