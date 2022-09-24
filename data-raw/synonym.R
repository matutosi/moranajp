## code to prepare `synonym` dataset goes here

library(tidyverse)
synonym <-
  readr::read_tsv("tools/synonym.txt", col_names = TRUE) %>%
  dplyr::mutate_all(stringi::stri_escape_unicode)
usethis::use_data(synonym, overwrite = TRUE)
  # usethis::use_data_raw("synonym")
