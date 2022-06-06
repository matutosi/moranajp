#' Clean up result of morphological analyzed data frame
#' 
#' @param df               A dataframe including result of morphological analysis.
#' @param use_common_data  A logical. TRUE: use data(stop_words).
#' @param add_stop_words   A string vector adding into stop words. 
#'                         When use_common_data is TRUE and add_stop_words are given, 
#'                         both of them will be used as stop_words.
#' @param synonym_df       A datarame including synonym word pairs. 
#'                         The first column: replace from, the second: replace to.
#' @param synonym_from,synonym_to
#'                         A string vector. Length of synonym_from and synonym_to 
#'                         should be the same.
#'                         When synonym_df and synonym pairs (synonym_from and synonym_to)
#'                         are given, both of them will be used as synonym.
#' @param ...              Extra arguments to internal fuctions.
#' @return A dataframe.
#' @name clean_up
#' @examples
#' data(neko_mecab)
#' data(synonym)
#' synonym <- 
#'   synonym %>% dplyr::mutate_all(stringi::stri_unescape_unicode)
#' 
#' neko_mecab %>%
#'   dplyr::select(-text_id) %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.))) %>%
#'   clean_mecab_local(
#'     use_common_data = TRUE, 
#'     synonym_df = synonym)
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

  df <- 
    df %>% # filter by pos (parts of speech)
    dplyr::filter(.data[["pos0"]] %in% filter_pos0) %>%
    dplyr::filter(.data[["pos1"]] %in% filter_pos1) %>%
    dplyr::mutate("pos0" := tidyr::replace_na(.data[["pos0"]], "-")) %>%
    dplyr::mutate("pos1" := tidyr::replace_na(.data[["pos1"]], "-")) %>%
    dplyr::relocate(dplyr::all_of(c("text_id", "term", "pos0", "pos1")))

  return(df)
}

#' @rdname clean_up
#' @export
pos_filter_chamame <- function(df){
  cols <- 
    c("\\u66f8\\u5b57\\u5f62(\\u57fa\\u672c\\u5f62)", "\\u54c1\\u8a5e") %>%
    stringi::stri_unescape_unicode()

  df <- df %>%
    dplyr::rename("term" := cols[1], "pos" := cols[2]) 

  df <-
    df %>%
    tidyr::separate(.data[["pos"]], into = c("pos0", "pos1"), sep="-", extra = "drop", fill = "right") %>%
    dplyr::mutate("pos0" := tidyr::replace_na(.data[["pos0"]], "-")) %>%
    dplyr::mutate("pos1" := tidyr::replace_na(.data[["pos1"]], "-"))

  if(! "text_id" %in% colnames(df)){
    df <- df %>%
      add_text_id_df("pos1", stringi::stri_unescape_unicode("\\u53e5\\u70b9"))
  }

  # pos filter setting
  filter_pos0 <- 
    c("\\u540d\\u8a5e", "\\u52d5\\u8a5e", 
      "\\u5f62\\u5bb9\\u8a5e", "\\u526f\\u8a5e") %>%
    stringi::stri_unescape_unicode()
  filter_pos1 <- 
    c("\\u666e\\u901a\\u540d\\u8a5e", 
      "\\u975e\\u81ea\\u7acb\\u53ef\\u80fd", "\\u4e00\\u822c") %>%
    stringi::stri_unescape_unicode()
  df <- 
    df %>% # filter by pos (parts of speech)
    dplyr::filter(.data[["pos0"]] %in% filter_pos0) %>%
    dplyr::filter(.data[["pos1"]] %in% filter_pos1) %>%
    dplyr::relocate(dplyr::all_of(c("text_id", "term", "pos0", "pos1")))

  return(df)
}

#' @rdname clean_up
#' @export
delete_stop_words <- function(df,
                              use_common_data = TRUE,
                              add_stop_words = NULL,
                              ...){ # `...' will be omitted
  stop_words <- 
  if(use_common_data){
    utils::data(stop_words, envir = environment())
    stop_words %>%
      dplyr::transmute("term" := stringi::stri_unescape_unicode(.data[["stop_word"]]))
  } else {
    tibble::tibble()
  }
  stop_words <- 
    stop_words %>%
      dplyr::add_row(term = add_stop_words)
  return(dplyr::anti_join(df, stop_words))
}

#' @rdname clean_up
#' @export
replace_words <- function(df, 
                          synonym_df = NULL,
                          synonym_from = NULL,
                          synonym_to = NULL,
                          ...){ # `...' will be omitted
  if(is.null(synonym_df) & is.null(synonym_from) & is.null(synonym_to))
      return(df)
  rep_words        <- synonym_to
  names(rep_words) <- synonym_from
  replace_words <- if(!is.null(synonym_df)){
    rep_words        <- c(synonym_to,   synonym_df[[2]]) # 2: TO
    names(rep_words) <- c(synonym_from, synonym_df[[1]]) # 1: FROM
  }
  return(dplyr::mutate(df, "term" := stringr::str_replace_all(.data[["term"]], rep_words)))
}
