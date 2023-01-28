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

## code to prepare `review_chamame` dataset goes here
prepare_chamame <- function(df){
  cols <- 
    c("\\u8f9e\\u66f8", "\\u6587\\u5883\\u754c", 
      "\\u66f8\\u5b57\\u5f62\\uff08\\uff1d\\u8868\\u5c64\\u5f62\\uff09", 
      "\\u8a9e\\u5f59\\u7d20", "\\u8a9e\\u5f59\\u7d20\\u8aad\\u307f", "\\u54c1\\u8a5e", 
      "\\u6d3b\\u7528\\u578b", "\\u6d3b\\u7528\\u5f62", 
      "\\u767a\\u97f3\\u5f62\\u51fa\\u73fe\\u5f62", "\\u4eee\\u540d\\u5f62\\u51fa\\u73fe\\u5f62", 
      "\\u8a9e\\u7a2e", "\\u66f8\\u5b57\\u5f62(\\u57fa\\u672c\\u5f62)", 
      "\\u8a9e\\u5f62(\\u57fa\\u672c\\u5f62)", "...14") %>% unescape_utf()
  cols_index <- c(3,12,6)
  new_cols <- 
    c("\\u8868\\u5c64\\u5f62", "\\u539f\\u5f62", "\\u54c1\\u8a5e", 
      stringr::str_c("\\u54c1\\u8a5e\\u518d\\u5206\\u985e", 1:3)) %>% unescape_utf()
  df %>%
    dplyr::select(all_of(cols[cols_index])) %>%
    magrittr::set_colnames(new_cols[1:3]) %>%
    tidyr::separate(new_cols[3], sep="-", into = new_cols[3:6], fill = "right", extra = "drop")
}

review %>%
  unescape_utf() %>%
  readr::write_tsv("data-raw/pre_chamame_review.txt", col_names = FALSE)

  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 
  # 
  # WORK with hands
  #   ANALYZE in https://chamame.ninjal.ac.jp/index.html
  #   RENAME downloaded data (csv with UTF-8 encoding) into "pre_chamame_review.csv"
  # 
  #  #   #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  # 

review_chamame <-
  readr::read_csv("data-raw/pre_chamame_review.csv") %>%
  prepare_chamame() %>%
  escape_utf()
usethis::use_data(review_chamame, overwrite = TRUE)
