## code to prepare `review_chamame` dataset goes here

library(tidyverse)
library(moranajp)
data(review)

review_ginza_tmp <- 
  review  %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(method = "ginza") %>%
  print()

review_ginza <- 
  review_ginza_tmp %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  print()

usethis::use_data(review_ginza, overwrite = TRUE)
