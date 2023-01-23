  # usethis::use_data_raw("review_sudachi")
## code to prepare `review` and related dataset go here
library(tidyverse)
devtools::load_all(".")

review <-
  readr::read_tsv("tools/review.txt") %>%
  dplyr::mutate_if(is.character, stringi::stri_escape_unicode)
usethis::use_data(review, overwrite = TRUE)

gen_morana_data <- function(df, bin_dir, iconv, method){
  df %>%
    dplyr::mutate(text = stringi::stri_unescape_unicode(text)) %>%
    moranajp_all(bin_dir = bin_dir, iconv = iconv, method = method) %>%
    dplyr::mutate_if(is.character, stringi::stri_escape_unicode) %>%
    magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
}

  # sudachi
bin_dir <- "d:/pf/sudachi/"
iconv   <- "CP932_UTF-8"
review_sudachi_a <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = "sudachi_a")
review_sudachi_b <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = "sudachi_b")
review_sudachi_c <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = "sudachi_c")
usethis::use_data(review_sudachi_a, overwrite = TRUE)
usethis::use_data(review_sudachi_b, overwrite = TRUE)
usethis::use_data(review_sudachi_c, overwrite = TRUE)

  # ginza
bin_dir <- ""
iconv   <- ""
method  <- "ginza"
review_ginza <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(review_ginza, overwrite = TRUE)

  # mecab
bin_dir <- "d:/pf/mecab/bin/"
iconv   <- "CP932_UTF-8"
method  <- "mecab"
review_mecab <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(review_mecab, overwrite = TRUE)

## code to prepare `review_chamame` dataset goes here
review %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  readr::write_tsv("tools/pre_chamame_review.txt", col_names = FALSE)

  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # WORK with hands
  #   ANALYZE in https://chamame.ninjal.ac.jp/index.html
  #   RENAME downloaded data (csv with UTF-8 encoding) into "pre_chamame_review.csv"
  # 
  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 

review_chamame <-
  readr::read_csv("tools/pre_chamame_review.csv") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(review_chamame, overwrite = TRUE)
