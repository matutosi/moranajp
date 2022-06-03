## code to prepare `neko_chamame` dataset goes here

library(tidyverse)
library(moranajp)
data(neko)
neko %>%
  dplyr::mutate(text = stringi::stri_unescape_unicode(text)) %>%
  readr::write_tsv("tools/neko.txt", col_names = FALSE)

  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # WORK with hands
  # 
  # ANALYZE in https://chamame.ninjal.ac.jp/index.html
  # 
  # RENAME downloaded data (csv with UTF-8 encoding)into "neko.csv"
  # 
  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 

neko_chamame <-
  readr::read_csv("tools/neko.csv") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(neko_chamame, overwrite = TRUE)
  # usethis::use_data_raw("neko_chamame")

