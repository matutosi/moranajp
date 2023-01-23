## code to prepare `neko` and related dataset go here
library(rvest)
library(tidyverse)
devtools::load_all(".")

neko <-
  rvest::read_html("https://www.konekono-heya.com/books/wagahai1.html") %>%
  rvest::html_element("body") %>%
  rvest::html_text2() %>%
  stringr::str_split("\\r\\n") %>%
  .[[1]] %>%
  .[5:13] %>%
  tibble::tibble(text=.) %>%
  dplyr::filter(text!="") %>%
  dplyr::mutate(text=stringr::str_replace_all(text, "　| |\\r", "")) %>%
  dplyr::mutate(text=stringr::str_replace_all(text, "（[^（）]*）", "")) %>%
  dplyr::mutate(text=stringi::stri_escape_unicode(text))

usethis::use_data(neko, overwrite = TRUE)


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
neko_sudachi_a <- gen_morana_data(neko, bin_dir = bin_dir, iconv = iconv, method = "sudachi_a")
neko_sudachi_b <- gen_morana_data(neko, bin_dir = bin_dir, iconv = iconv, method = "sudachi_b")
neko_sudachi_c <- gen_morana_data(neko, bin_dir = bin_dir, iconv = iconv, method = "sudachi_c")
usethis::use_data(neko_sudachi_a, overwrite = TRUE)
usethis::use_data(neko_sudachi_b, overwrite = TRUE)
usethis::use_data(neko_sudachi_c, overwrite = TRUE)

  # ginza
bin_dir <- ""
iconv   <- ""
method  <- "ginza"
neko_ginza <- gen_morana_data(neko, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(neko_ginza, overwrite = TRUE)

  # mecab
bin_dir <- "d:/pf/mecab/bin/"
iconv   <- "CP932_UTF-8"
method  <- "mecab"
neko_mecab <- gen_morana_data(neko, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(neko_mecab, overwrite = TRUE)

## code to prepare `neko_chamame` dataset goes here
neko %>%
  dplyr::transmute(text = stringi::stri_unescape_unicode(text)) %>%
  readr::write_tsv("tools/pre_chamame_neko.txt", col_names = FALSE)

  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # WORK with hands
  #   ANALYZE in https://chamame.ninjal.ac.jp/index.html
  #   RENAME downloaded data (csv with UTF-8 encoding) into "pre_chamame_neko.csv"
  # 
  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 

neko_chamame <-
  readr::read_csv("tools/pre_chamame_neko.csv") %>%
  dplyr::mutate_all(stringi::stri_escape_unicode) %>%
  magrittr::set_colnames(stringi::stri_escape_unicode(colnames(.)))
usethis::use_data(neko_chamame, overwrite = TRUE)
