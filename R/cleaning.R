#' Clean up result of morphological analyzed data frame
#' 
#' @param df               A dataframe including result of morphological analysis.
#' @param use_common_data  A logical. TRUE: use data(stop_words).
#' @param stop_words       A string vector.
#' @param synonym_df       A datarame including synonym word pairs. 
#'                         The first column: replace from, the second: replace to.
#' @param synonym_from,synonym_to
#'                         A string vector. Length of synonym_from and synonym_to 
#'                         should be the same.
#' @param ...              Extra arguments to internal fuctions.
#' @return A dataframe.
#' @name clean_up
#' 
#' @export
clean_mecab_local <- function(df, ...){
  df %>%
    pos_filter_mecab_local() %>%
    delete_stop_words(...) %>%
    replace_words(...)
}

#' @rdname clean_up
#' @export
clean_chamame <- function(df, ...){
  df %>%
    pos_filter_chamame() %>%
    delete_stop_words(...) %>%
    replace_words(...)
}

#' @rdname clean_up
#' @export
pos_filter_mecab_local <- function(df){
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
    c("\\u539f\\u5f62", "\\u54c1\\u8a5e", 
      "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1") %>%
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

#' @rdname clean_up
#' @export
pos_filter_chamame <- function(df){
  df <-
    df %>%
    # already selected, but not renamed yet
    magrittr::set_colnames(c("term", "pos")) %>%
    tidyr::separate(pos, into = c("pos0", "pos1"), sep="-", extra = "drop", fill = "right") %>%
    dplyr::mutate(pos0 = tidyr::replace_na(pos0, "-")) %>%
    dplyr::mutate(pos1 = tidyr::replace_na(pos1, "-"))

  if(! "text_id" %in% colnames(df)){
    df <- df %>%
      add_text_id_df("pos1", stringi::stri_unescape_unicode("\\u53e5\\u70b9"))
  }

  # pos filter setting
  #   stringi::stri_escape_unicode()
  #   stringi::stri_unescape_unicode()
  filter_pos0 <- 
    c("\\u540d\\u8a5e", "\\u52d5\\u8a5e", 
      "\\u5f62\\u5bb9\\u8a5e", "\\u526f\\u8a5e") %>%
    stringi::stri_unescape_unicode()
  filter_pos1 <- 
    c("\\u666e\\u901a\\u540d\\u8a5e", 
      "\\u975e\\u81ea\\u7acb\\u53ef\\u80fd", "\\u4e00\\u822c") %>%
    stringi::stri_unescape_unicode()

  df <- 
    df %>%
    dplyr::filter(pos0 %in% filter_pos0) %>% # filter by pos (parts of speech)
    dplyr::filter(pos1 %in% filter_pos1)

  return(df)
}

#' @rdname clean_up
#' @export
delete_stop_words <- function(df, 
                              use_common_data = TRUE,
                              stop_words = NULL){
  stop_words <- if(use_common_data){
    data(stop_words)
    stop_words %>%
      dplyr::mutate(stop_word = stringi::stri_unescape_unicode(stop_word))
  }
  stop_words <- 
    stop_words %>%
      magrittr::set_colnames("term") %>%
      dplyr::add_row(term = stop_words)
  return(dplyr::anti_join(df, stop_words))
}

#' @rdname clean_up
#' @export
replace_words <- function(df, synonym_df = NULL,
                              synonym_from = NULL,
                              synonym_to = NULL){
  rep_words        <- synonym_to
  names(rep_words) <- synonym_from
  replace_words <- if(!is.null(synonym_df)){
    rep_words        <- c(synonym_to,   synonym_df[[2]]) # 2: TO
    names(rep_words) <- c(synonym_from, synonym_df[[1]]) # 1: FROM
  }
  return(dplyr::mutate(df, term = stringr::str_replace_all(term, rep_words)))
}
