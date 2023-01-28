  # usethis::use_data_raw("review_sudachi")
## code to prepare `review` and related dataset go here
library(tidyverse)
library(rvest)
devtools::load_all(".")

review <-
  readr::read_tsv("data-raw/review.txt") %>%
  escape_utf() %>%
  add_group(col = "text", brk = "EOCHAP", grp = "chap") %>%
  add_group(col = "text", brk = "EOSECT", grp = "sect") %>%
  add_group(col = "text", brk = "EOPARA", grp = "para") %>%
  dplyr::filter(!(text %in% c("EOCHAP", "EOSECT", "EOPARA")))
usethis::use_data(review, overwrite = TRUE)

gen_morana_data <- function(df, bin_dir, iconv, method, head = FALSE){
  df <- unescape_utf(df)
  if(head){ df <- head(df) }
  df %>%
    moranajp_all(bin_dir = bin_dir, iconv = iconv, method = method) %>%
    escape_utf()
}

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

  # sudachi
bin_dir <- "d:/pf/sudachi/"
iconv   <- "CP932_UTF-8"
review_sudachi_a <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = "sudachi_a")
review_sudachi_b <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = "sudachi_b")
review_sudachi_c <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = "sudachi_c")
usethis::use_data(review_sudachi_a, overwrite = TRUE)
usethis::use_data(review_sudachi_b, overwrite = TRUE)
usethis::use_data(review_sudachi_c, overwrite = TRUE)

  # mecab
bin_dir <- ""
iconv   <- ""
method  <- "chamame"
review_chamame <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(review_chamame, overwrite = TRUE)

## for check
  # tail(review_mecab    ) %>% unescape_utf()
  # tail(review_sudachi_a) %>% unescape_utf()
  # tail(review_sudachi_b) %>% unescape_utf()
  # tail(review_sudachi_c) %>% unescape_utf()
  # tail(review_ginza    ) %>% unescape_utf()
  # tail(review_chamame  ) %>% unescape_utf()
  # 
  # review_mecab     %>% unescape_utf() %>% print(n=200)
  # review_sudachi_a %>% unescape_utf() %>% print(n=200)
  # review_ginza     %>% unescape_utf() %>% print(n=200)
  # review_chamame   %>% unescape_utf() %>% print(n=200)
