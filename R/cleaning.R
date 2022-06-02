clean_mecab_local <- function(df, ...){
  df %>%
    pos_filter_mecab_local(...) %>%
    delete_stop_words(...) %>%
    replace_words(...)
}

clean_chamame <- function(df, ...){
  df %>%
    pos_filter_chamame(...) %>%
    delete_stop_words(...) %>%
    replace_words(...)
}

pos_filter_mecab_local <- function(df, ...){
  # pos filter setting
  filter_pos0 <- 
    c("\\u540d\\u8a5e", "\\u52d5\\u8a5e", "\\u5f62\\u5bb9\\u8a5e") %>%
    stringi::stri_unescape_unicode()
  filter_pos1 <- 
    c("\\u666e\\u901a\\u540d\\u8a5e", "\\u56fa\\u6709\\u540d\\u8a5e", 
      "\\u56fa\\u6709", "\\u4e00\\u822c", "\\u81ea\\u7acb", 
      "\\u30b5\\u5909\\u63a5\\u7d9a", 
      "\\u5f62\\u5bb9\\u52d5\\u8a5e\\u8a9e\\u5e79", 
      "\\u30ca\\u30a4\\u5f62\\u5bb9\\u8a5e\\u8a9e\\u5e79", 
      "\\u526f\\u8a5e\\u53ef\\u80fd") %>%
    stringi::stri_unescape_unicode()

  cols <- 
    c("\\u539f\\u5f62", "\\u54c1\\u8a5e", "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1") %>%
    stringi::stri_unescape_unicode()

  df <- df %>%
    dplyr::rename("term" := cols[1], "pos0" := cols[2], "pos1" := cols[3]) 

  if(! "text_id" %in% colnames(df)){
    df <- 
      df %>%
      add_text_id_df("pos1", stringi::stri_unescape_unicode("\\u53e5\\u70b9"))
  }

  df <- df %>%
    dplyr::filter(pos0 %in% filter_pos0) %>% # filter by pos (parts of speech)
    dplyr::filter(pos1 %in% filter_pos1) %>%
    dplyr::mutate(pos0 = tidyr::replace_na(pos0, "-")) %>%
    dplyr::mutate(pos1 = tidyr::replace_na(pos1, "-"))

  return(df)
}

pos_filter_chamame <- function(df, ...){
  df <-   # splite pos
    df %>%
    magrittr::set_colnames(c("term", "pos")) %>% # already selected, but not renamed yet in load_dataServer
    tidyr::separate(pos, into = c("pos0", "pos1"), sep="-", extra = "drop", fill = "right") %>%
    dplyr::mutate(pos0 = tidyr::replace_na(pos0, "-")) %>%
    dplyr::mutate(pos1 = tidyr::replace_na(pos1, "-"))

  if(! "text_id" %in% colnames(df)){
    df <- df %>%
      add_text_id_df("pos1", stringi::stri_unescape_unicode("\\u53e5\\u70b9"))
  }

  # pos filter setting
    # stringi::stri_escape_unicode()
    # stringi::stri_unescape_unicode()
  filter_pos0 <- 
    c("\\u540d\\u8a5e", "\\u52d5\\u8a5e", "\\u5f62\\u5bb9\\u8a5e", "\\u526f\\u8a5e") %>%
    stringi::stri_unescape_unicode()
  filter_pos1 <- 
    c("\\u666e\\u901a\\u540d\\u8a5e", "\\u975e\\u81ea\\u7acb\\u53ef\\u80fd", "\\u4e00\\u822c") %>%
    stringi::stri_unescape_unicode()

  df <- 
    df %>%
    dplyr::filter(pos0 %in% filter_pos0) %>% # filter by pos (parts of speech)
    dplyr::filter(pos1 %in% filter_pos1)

  return(df)
}

delete_stop_words <- function(df, 
                              use_stop_words_data = TRUE,
                              add_stop_words = NULL, ...){
  stop_words <- if(use_stop_words_data){
    data(stop_words)
    stop_words %>%
      dplyr::mutate(stop_word = stringi::stri_unescape_unicode(stop_word))
  }
  stop_words <- 
    stop_words %>%
      magrittr::set_colnames("term") %>%
      dplyr::add_row(term = add_stop_words)
  return(dplyr::anti_join(df, stop_words))
}

replace_words <- function(df, use_synonym_data = TRUE, 
                              add_synonym_from = NULL,
                              add_synonym_to = NULL, ...){
  replace_words <- if(use_synonym_data){
    data(synonym)
    synonym %>%
      dplyr::mutate_all(stringi::stri_unescape_unicode)
  }
  rep_words        <- c(synonym$to,   add_synonym_to)
  names(rep_words) <- c(synonym$from, add_synonym_from)
  return(dplyr::mutate(df, term = stringr::str_replace_all(term, rep_words)))
}
