## code to prepare `review` dataset goes here

library(tidyverse)
review <-
  readr::read_tsv("tools/review.txt", col_names = "text") %>%
  dplyr::mutate(text = stringi::stri_escape_unicode(text))
usethis::use_data(review, overwrite = TRUE)
usethis::use_data_raw("review")
