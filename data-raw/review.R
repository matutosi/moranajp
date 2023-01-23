  # usethis::use_data_raw("review")
## code to prepare `review` dataset goes here

library(tidyverse)
review <-
  readr::read_tsv("tools/review.txt") %>%
  dplyr::mutate_if(is.character, stringi::stri_escape_unicode)
usethis::use_data(review, overwrite = TRUE)
