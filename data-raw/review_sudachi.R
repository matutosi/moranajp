  # usethis::use_data_raw("review_sudachi")
## code to prepare `review_sudachi_a`, `review_sudachi_b`, and `review_sudachi_c` dataset goes here
library(tidyverse)
devtools::load_all(".")
data(review)

bin_dir <- "d:/pf/sudachi/"
iconv <- "CP932_UTF-8"
review_sudachi_a <- 
  review %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = iconv, method = "sudachi_a") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(review_sudachi_a, overwrite = TRUE)

review_sudachi_b <- 
  review %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = iconv, method = "sudachi_b") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(review_sudachi_b, overwrite = TRUE)

review_sudachi_c <- 
  review %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  moranajp_all(bin_dir = bin_dir, iconv = iconv, method = "sudachi_c") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(review_sudachi_c, overwrite = TRUE)
