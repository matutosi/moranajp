  # usethis::use_data_raw("review_sudachi")
## code to prepare `review` and related dataset go here
library(tidyverse)
devtools::load_all(".")

review <-
  readr::read_tsv("data-raw/review.txt") %>%
  dplyr::mutate_if(is.character, stringi::stri_escape_unicode) %>%
  add_group(col = "text", brk = "EOCHAP", grp = "chap") %>%
  add_group(col = "text", brk = "EOSECT", grp = "sect") %>%
  add_group(col = "text", brk = "EOPARA", grp = "para") %>%
  dplyr::filter(!(text %in% c("EOCHAP", "EOSECT", "EOPARA")))
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

  # tail(review_sudachi_a) %>%  mutate_if(is.character, stringi::stri_unescape_unicode)
  # tail(review_sudachi_b) %>%  mutate_if(is.character, stringi::stri_unescape_unicode)
  # tail(review_sudachi_c) %>%  mutate_if(is.character, stringi::stri_unescape_unicode)
  # tbl <- 
  #     neko %>%
  #     dplyr::mutate(text = stringi::stri_unescape_unicode(text))
  # tbl <-    dplyr::mutate(tbl, `:=`({{text_id}}, dplyr::row_number()))
  # others <- dplyr::select(tbl, !dplyr::all_of(text_col))
  # ht <- function(x){ dplyr::bind_rows(head(x, 20), tail(x,20)) }
  # tbl <- 
  #   tbl %>%
  #         make_groups(text_col = text_col, length = 1100,
  #             tmp_group = tmp_group, str_length = str_length) %>%
  #         dplyr::group_split(.data[[tmp_group]]) %T>%
  #         { a <<- print(.) } %>%
  #         purrr::map(dplyr::select, dplyr::all_of(text_col)) %>%
  #         purrr::map(moranajp, 
  #             bin_dir = bin_dir, method = method, 
  #             text_col = text_col, option = option, iconv = iconv) %>%
  #         dplyr::bind_rows()
  # print(tbl, n=200)
  # tbl %>% na.omit() %>% filter(表層形 == "EOS")
  # tbl %>% filter(表層形 == "EOS")
  # tbl %>% filter(is.na(品詞))
  # 
  # 
  #   tbl %>% dplyr::mutate(text_id = dplyr::row_number()) %>%
  #   filter(表層形 == "EOS") %>% print(n=200)
  #         filter(text_id %in% c(77,78,153,154,229,230))
  # slice(c(77,78,153,154,229,230))
  # 
  # dplyr::filter(tbl, 表層形 == "EOS")

  # ginza
bin_dir <- ""
iconv   <- ""
method  <- "ginza"
review_ginza <- gen_morana_data(review, bin_dir = bin_dir, iconv = iconv, method = method)
usethis::use_data(review_ginza, overwrite = TRUE)

  # review_ginza
  # tail(review_ginza) %>%  mutate_if(is.character, stringi::stri_unescape_unicode)

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



## 
## 
## 
## 
## 
## 
## 
## 
rm(list=ls(all=TRUE));gc();gc();
library(tidyverse)
devtools::load_all(".")

bin_dir <- "d:/pf/mecab/bin/"
iconv   <- "CP932_UTF-8"
method  <- "mecab"

data(review)
review <- dplyr::mutate(review, text = stringi::stri_unescape_unicode(text))

system.time(
a <-  moranajp_all(review, bin_dir = bin_dir, iconv = iconv, method = method)
)
  #    user  system elapsed x250
  #    3.00    4.24    8.73 
  #    user  system elapsed hp
  #    1.68    2.52    5.58 

bin_dir <- "d:/pf/mecab/bin/"
iconv   <- "CP932_UTF-8"
method  <- "mecab"
t_id <- "id"
text_col <- "text"
data(review)
review <- dplyr::mutate(review, text = stringi::stri_unescape_unicode(text))

system.time(
b <- 
  review %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], "\\r\\n", ""))) %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], "\\n", ""))) %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], '&|\\||<|>|"', ""))) %>%
    mutate(`:=`({{t_id}}, row_number())) %>%
    split(.[[t_id]]) %>%
    map(moranajp, bin_dir = bin_dir, method = method, text_col = text_col, iconv = iconv)
)
  #    user  system elapsed x250
  #   12.19   12.71  134.06 
  #    user  system elapsed hp
  #    5.66    5.03  113.55 
a
bind_rows(b)
a_1 <- a$表層形
b_1 <- bind_rows(b)$表層形
b_1[a_1 != b_1]
a            %>% slice(140:160) %>% print(n=200)
bind_rows(b) %>% slice(140:160) %>% print(n=200)

  # t_id <- "text_id"
  # review %>%
  #   mutate(`:=`({{t_id}}, row_number())) %>%
  #   group_by(.data[[t_id]]) %>%
  #   nest() 

  # d:
  # cd d:/pf/mecab/bin
  # mecab
  # d:
  # cd d:/pf/sudachi
  # java -jar sudachi.jar
  # 草刈り時間 997）．BPOMORANAJPさらに，農 005）．BPOMORANAJP一方，畦畔 94a）．BPOMORANAJP整備地にお 94b）．BPOMORANAJP




  # ginza

  # これはペンだ．指摘した．BPOMORANAJP重要である．BPOMORANAJP
  # 指摘されている．しかし，農村景観は重要である．

## 
rm(list=ls(all=TRUE));gc();gc();
library(tidyverse)
devtools::load_all(".")

data(review)
review <- dplyr::mutate(review, text = stringi::stri_unescape_unicode(text))

bin_dir <- "d:/pf/sudachi/"
iconv   <- "CP932_UTF-8"
method <- "sudachi_a"
t_id <- "id"
text_col <- "text"


system.time(
  a <-  moranajp_all(review, bin_dir = bin_dir, iconv = iconv, method = method)
)
  #    user  system elapsed 
  #    2.40    4.70   17.68 

filter(a, stringr::str_detect(表層形, "JP"))
filter(a, stringr::str_detect(表層形, "BP"))


system.time(
b <- 
  review %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], "\\r\\n", ""))) %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], "\\n", ""))) %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], '&|\\||<|>|"', ""))) %>%
    mutate(`:=`({{t_id}}, row_number())) %>%
    split(.[[t_id]]) %>%
    map(moranajp, bin_dir = bin_dir, method = method, text_col = text_col, iconv = iconv)
)
  #    user  system elapsed 
  #    8.46   13.30  313.61 

a
bind_rows(b)

a_1 <- a$表層形
b_1 <- bind_rows(b)$表層形
b_1[a_1 != b_1]

a            %>% slice(140:160) %>% print(n=200)
bind_rows(b) %>% slice(140:160) %>% print(n=200)

## 
rm(list=ls(all=TRUE));gc();gc();
library(tidyverse)
devtools::load_all(".")

data(review)
review <- dplyr::mutate(review, text = stringi::stri_unescape_unicode(text))

bin_dir <- "d:/pf/sudachi/"
iconv   <- "CP932_UTF-8"
method <- "sudachi_a"
t_id <- "id"
text_col <- "text"
  # ht <- function(x, n){ paste0(str_sub(x, 1, n), " ", str_sub(x, -n, -1)) }

system.time(
  a <-
    review %>%
  #     mutate(text = ht(text, 5)) %>%
    moranajp_all(bin_dir = bin_dir, iconv = iconv, method = method)
)
  #    user  system elapsed 
  #    2.40    4.70   17.68 

  # a$表層形 %>% unlist() %>% str_c(collapse ="")
  # review %>% mutate(text = ht(text, 5)) %>% .$text %>% str_c(collapse = "BPOMORANAJP")
  # tmp <- review %>% mutate(text = ht(text, 5)) %>% .$text %>% .[1:229] %>% str_c(collapse = "BPOMORANAJP")
  # setwd(bin_dir)
  # input <- tmp
  # command <- "java -jar sudachi.jar -m A"
  # output <- system(command, intern=TRUE, input = input)

  # system.time(
  # b <- 
  #   review %>%
  #         dplyr::mutate(`:=`({{text_col}},
  #             stringr::str_replace_all(.data[[text_col]], "\\r\\n", ""))) %>%
  #         dplyr::mutate(`:=`({{text_col}},
  #             stringr::str_replace_all(.data[[text_col]], "\\n", ""))) %>%
  #         dplyr::mutate(`:=`({{text_col}},
  #             stringr::str_replace_all(.data[[text_col]], '&|\\||<|>|"', ""))) %>%
  #     mutate(`:=`({{t_id}}, row_number())) %>%
  #     split(.[[t_id]]) %>%
  #     map(moranajp, bin_dir = bin_dir, method = method, text_col = text_col, iconv = iconv)
  # )
  #    user  system elapsed 
  #    8.46   13.30  313.61 
  # 
  # a
  # bind_rows(b)

## 
rm(list=ls(all=TRUE));gc();gc();
library(tidyverse)
devtools::load_all(".")
data(review)
review <- dplyr::mutate(review, text = stringi::stri_unescape_unicode(text))

bin_dir <- ""
iconv   <- ""
method <- "ginza"
system.time(
  ginza <-
    review %>%
    moranajp_all(bin_dir = bin_dir, iconv = iconv, method = method)
)
ginza
tail(ginza)


bin_dir <- "d:/pf/sudachi/"
iconv   <- "CP932_UTF-8"
method <- "sudachi_a"
system.time(
  sudachi <-
    review %>%
    moranajp_all(bin_dir = bin_dir, iconv = iconv, method = method)
)
sudachi
tail(sudachi)


bin_dir <- "d:/pf/mecab/bin/"
iconv   <- "CP932_UTF-8"
method  <- "mecab"
review <- dplyr::mutate(review, text = stringi::stri_unescape_unicode(text))
system.time(
  mecab <-
    review %>%
    moranajp_all(bin_dir = bin_dir, iconv = iconv, method = method)
)
mecab
tail(mecab)

m <- 90
n <- c(m, m+1)
ginza   %>% filter(text_id %in% n) %>% print(n=100)
sudachi %>% filter(text_id %in% n) %>% print(n=100)
mecab   %>% filter(text_id %in% n) %>% print(n=100)
review %>% slice(n)
