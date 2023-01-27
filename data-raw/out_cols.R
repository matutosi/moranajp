library(tidyverse)
cols_jp <- 
  c("\\u8868\\u5c64\\u5f62"               , "\\u54c1\\u8a5e"                      , "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1", # mecab
    "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2", "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3", "\\u6d3b\\u7528\\u578b"               ,
    "\\u6d3b\\u7528\\u5f62"               , "\\u539f\\u5f62"                      , "\\u8aad\\u307f"                      ,
    "\\u767a\\u97f3"                      , 
    "\\u8868\\u5c64\\u5f62"               , "\\u54c1\\u8a5e"                      , "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1", # sudachi
    "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2", "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3", "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e4", 
    "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e5", "\\u539f\\u5f62"                      ,
    "id"                                  , "\\u8868\\u5c64\\u5f62"               , "\\u539f\\u5f62"                      , # ginza
     "UD\\u54c1\\u8a5e\\u30bf\\u30b0"     , "\\u54c1\\u8a5e\\u30bf\\u30b0"        , "\\u5c5e\\u6027"                      ,
     "\\u4fc2\\u53d7\\u5143"              , "\\u4fc2\\u53d7\\u30bf\\u30b0"        , "\\u4fc2\\u53d7\\u30da\\u30a2"        ,
     "\\u305d\\u306e\\u4ed6") %>%
  unescape_utf()
cols_en <- 
  c("form", "pos", "pos_1", "pos_2", "pos_3", "conjugation_type", "conjugation_form", "lemma", "reading", "soud", # mecab
    "form", "pos", "pos_1", "pos_2", "pos_3", "pos_4", "pos_5", "lemma",                                          # sudachi
    "id", "form", "lemma", "upos", "xpos", "feats", "head", "deprel", "deps", "misc")                             # ginza
order <- c(10, 99, 99, 99, 99, 12, 13, 11, 2, 99, 99, 99, 1, 3, 9, 4, 5, 6, 7, 8)
out_cols <- 
  tibble::tibble(cols_jp, cols_en) %>%
  dplyr::distinct() %>%
  dplyr::arrange(cols_jp) %>%
  dplyr::bind_cols(order = order) %>%
  dplyr::arrange(order, cols_jp)

  #    cols_jp     cols_en          order
  #  1 表層形      form                 1
  #  2 原形        lemma                2
  #  3 品詞        pos                  3
  #  4 品詞細分類1 pos_1                4
  #  5 品詞細分類2 pos_2                5
  #  6 品詞細分類3 pos_3                6
  #  7 品詞細分類4 pos_4                7
  #  8 品詞細分類5 pos_5                8
  #  9 品詞タグ    xpos                 9
  # 10 id          id                  10
  # 11 係受元      head                11
  # 12 係受タグ    deprel              12
  # 13 係受ペア    deps                13
  # 14 UD品詞タグ  upos                99
  # 15 その他      misc                99
  # 16 活用型      conjugation_type    99
  # 17 活用形      conjugation_form    99
  # 18 属性        feats               99
  # 19 読み        reading             99
