  # usethis::use_data_raw("neko_sudachi")
## code to prepare `neko_sudachi_a`, `neko_sudachi_b`, and `neko_sudachi_c` dataset goes here
library(tidyverse)
devtools::load_all(".")
data(neko)

bin_dir <- "d:/pf/sudachi/"
iconv <- "CP932_UTF-8"
neko_sudachi_a <- 
  neko %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = iconv, method = "sudachi_a") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(neko_sudachi_a, overwrite = TRUE)

neko_sudachi_b <- 
  neko %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = iconv, method = "sudachi_b") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(neko_sudachi_b, overwrite = TRUE)

neko_sudachi_c <- 
  neko %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = iconv, method = "sudachi_c") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(neko_sudachi_c, overwrite = TRUE)
