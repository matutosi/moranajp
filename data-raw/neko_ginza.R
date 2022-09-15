## code to prepare `neko_mecab` dataset goes here

library(tidyverse)
library(moranajp)
data(neko)

neko_ginza <- 
  neko %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(method = "ginza") %>%
  clean_ginza_local() %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(neko_ginza, overwrite = TRUE)
  # usethis::use_data_raw("neko_ginza")
