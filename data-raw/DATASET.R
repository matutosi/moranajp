## code to prepare `neko` dataset goes here

library(rvest)
library(tidyverse)
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
