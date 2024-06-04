## code to prepare `stop_words` dataset goes here

  # http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt
library(tidyverse)
stop_words <- 
  readr::read_tsv("tools/stop_words.txt", col_names = "stop_word") |>
  dplyr::mutate(stop_word = stringi::stri_escape_unicode(stop_word))
usethis::use_data(stop_words, overwrite = TRUE)
