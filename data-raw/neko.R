## code to prepare `neko` and related dataset go here
library(rvest)
library(tidyverse)
devtools::load_all(".")

neko <-
  rvest::read_html("https://www.konekono-heya.com/books/wagahai1.html") |>
  rvest::html_element("body") |>
  rvest::html_text2() |>
  stringr::str_split("\\r\\n") |>
  `[[`(_, 1) |>
  `[`(_, 5:13) |>
  tibble::tibble(text=.) |>
  dplyr::filter(text!="") |>
  dplyr::mutate(text=stringr::str_replace_all(text, "　| |\\r", "")) |>
  dplyr::mutate(text=stringr::str_replace_all(text, "（[^（）]*）", "")) |>
  escape_utf()

usethis::use_data(neko, overwrite = TRUE)

gen_morana_data <- function(df, bin_dir, iconv, method){
  df |>
    unescape_utf() |>
    moranajp_all(bin_dir = bin_dir, iconv = iconv, method = method) |>
    escape_utf()
}

  # mecab
bin_dir <- "d:/pf/mecab/bin/"
iconv   <- "CP932_UTF-8"
method  <- "mecab"
neko_mecab <- gen_morana_data(neko, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(neko_mecab, overwrite = TRUE)

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
bin_dir <- ""
iconv   <- ""
method  <- "chamame"
neko_chamame <- gen_morana_data(neko, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(neko_chamame, overwrite = TRUE)

## for check
  # tail(neko_mecab    ) |> unescape_utf()
  # tail(neko_sudachi_a) |> unescape_utf()
  # tail(neko_sudachi_b) |> unescape_utf()
  # tail(neko_sudachi_c) |> unescape_utf()
  # tail(neko_ginza    ) |> unescape_utf()
  # tail(neko_chamame  ) |> unescape_utf()
  # 
  # neko_mecab     |> unescape_utf() |> print(n=200)
  # neko_sudachi_a |> unescape_utf() |> print(n=200)
  # neko_ginza     |> unescape_utf() |> print(n=200)
  # neko_chamame   |> unescape_utf() |> print(n=200)
