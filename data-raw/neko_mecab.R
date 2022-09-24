  # usethis::use_data_raw("neko_mecab")
## code to prepare `neko_mecab` dataset goes here

library(tidyverse)
library(moranajp)
data(neko)

bin_dir <- "d:/pf/mecab/bin/"
neko_mecab <- 
  neko %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = "CP932_UTF-8") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(neko_mecab, overwrite = TRUE)
