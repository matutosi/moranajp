#' Clean up result of morphological analyzed data frame
#' 
#' @param df               A dataframe including result of morphological analysis.
#' @param term             A string to indicate the word term column.
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
#' library(tidyverse)
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
  df <- 
    df %>%
    pos_filter_mecab_local() %>%
    delete_stop_words(...) %>%
    replace_words(...)
  return(df)
}

#' @rdname clean_up
#' @examples
#' text <- tibble::tibble(text = "親は科学の本を小学生の子どもに与えた．")
#' ex_ginza <- moranajp_all(text, text_col = "text", method = "ginza")
#' ex_ginza %>%
#'    clean_ginza_local(
#'      add_stop_words = "科学", 
#'      synonym_from = "本",  synonym_to = "書籍")
#' @export
clean_ginza_local <- function(df, ...){
  term <- "lemma"
  df <- 
    df %>%
    add_depend_ginza() %>%
    pos_filter_ginza_local() %>%
    delete_stop_words(term = term, ...) %>%
    replace_words(term = term, ...)
  return(df)
}

#' @rdname clean_up
#' @export
add_depend_ginza <- function(df){
  cond <- "stringr::str_detect(id, '^#')"
  df <- 
    df %>%
    add_series_no(cond = cond, new_col = "sentence_no", starts_with = 0) %>%
    dplyr::mutate(
        "word_no" := .data[["id"]], 
        "id" := stringr::str_c(.data[["sentence_no"]], "_", .data[["word_no"]]))
  depend <- 
    df %>%
    dplyr::select("head_id" := .data[["id"]], "lemma_dep" := .data[["lemma"]])
  df <- 
    df %>%
    dplyr::mutate("head_id" := 
        stringr::str_c(.data[["sentence_no"]], "_", .data[["head"]])) %>%
    dplyr::left_join(depend)
  return(df)
}


#' @rdname clean_up
#' @export
#' @examples
#' library(tidyverse)
#' data(neko)
#' neko <-
#'    neko %>%
#'    dplyr::mutate(text=stringi::stri_unescape_unicode(text))
#' neko_ginza <- moranajp_all(neko, text_col = "text", method = "ginza")
#' neko_ginza %>%
#'    pos_filter_ginza_local()
#' 
#' 
pos_filter_ginza_local <- function(df){
    filter_pos_1 <- 
        c("\\u540d\\u8a5e", "\\u52d5\\u8a5e", 
          "\\u5f62\\u72b6\\u8a5e", "\\u5f62\\u5bb9\\u8a5e") %>%
        stringi::stri_unescape_unicode()
    filter_pos_2 <- 
        c("\\u666e\\u901a\\u540d\\u8a5e", 
          "\\u56fa\\u6709\\u540d\\u8a5e", "\\u4e00\\u822c") %>%
        stringi::stri_unescape_unicode()
    df <- 
        df %>%
        dplyr::filter(.data[["pos_1"]] %in% filter_pos_1) %>%
        dplyr::filter(.data[["pos_2"]] %in% filter_pos_2) 
    return(df)
}

#' @rdname clean_up
#' @export
clean_chamame <- function(df, ...){
  df <- 
    df %>%
    pos_filter_chamame() %>%
    delete_stop_words(...) %>%
    replace_words(...)
  return(df)
}

#' @rdname clean_up
#' @export
pos_filter_mecab_local <- function(df){
  # pos filter setting
  filter_pos_1 <- 
    c("\\u540d\\u8a5e", "\\u52d5\\u8a5e", "\\u5f62\\u5bb9\\u8a5e") %>%
    stringi::stri_unescape_unicode()
  filter_pos_2 <- 
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
    dplyr::rename("term" := cols[1], "pos_1" := cols[2], "pos_2" := cols[3]) 

  if(! "text_id" %in% colnames(df)){
    df <- 
      df %>%
      add_text_id_df("pos_2", stringi::stri_unescape_unicode("\\u53e5\\u70b9"))
  }

  df <- 
    df %>% # filter by pos (parts of speech)
    dplyr::filter(.data[["pos_1"]] %in% filter_pos_1) %>%
    dplyr::filter(.data[["pos_2"]] %in% filter_pos_2) %>%
    dplyr::mutate("pos_1" := tidyr::replace_na(.data[["pos_1"]], "-")) %>%
    dplyr::mutate("pos_2" := tidyr::replace_na(.data[["pos_2"]], "-")) %>%
    dplyr::relocate(dplyr::all_of(c("text_id", "term", "pos_1", "pos_2")))

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
    tidyr::separate(.data[["pos"]], into = c("pos_1", "pos_2"), sep="-", extra = "drop", fill = "right") %>%
    dplyr::mutate("pos_1" := tidyr::replace_na(.data[["pos_1"]], "-")) %>%
    dplyr::mutate("pos_2" := tidyr::replace_na(.data[["pos_2"]], "-"))

  if(! "text_id" %in% colnames(df)){
    df <- df %>%
      add_text_id_df("pos_2", stringi::stri_unescape_unicode("\\u53e5\\u70b9"))
  }

  # pos filter setting
  filter_pos_1 <- 
    c("\\u540d\\u8a5e", "\\u52d5\\u8a5e", 
      "\\u5f62\\u5bb9\\u8a5e", "\\u526f\\u8a5e") %>%
    stringi::stri_unescape_unicode()
  filter_pos_2 <- 
    c("\\u666e\\u901a\\u540d\\u8a5e", 
      "\\u975e\\u81ea\\u7acb\\u53ef\\u80fd", "\\u4e00\\u822c") %>%
    stringi::stri_unescape_unicode()
  df <- 
    df %>% # filter by pos (parts of speech)
    dplyr::filter(.data[["pos_1"]] %in% filter_pos_1) %>%
    dplyr::filter(.data[["pos_2"]] %in% filter_pos_2) %>%
    dplyr::relocate(dplyr::all_of(c("text_id", "term", "pos_1", "pos_2")))

  return(df)
}

#' @rdname clean_up
#' @export
delete_stop_words <- function(df,
                              term = "term",
                              use_common_data = TRUE,
                              add_stop_words = NULL,
                              ...){ # `...' will be omitted
  stop_words <- 
    if(use_common_data){
        utils::data(stop_words, envir = environment())
        stop_words %>%
          purrr::map_dfr(stringi::stri_unescape_unicode) %>%
          magrittr::set_colnames(term)
    } else {
        tibble::tibble()
    }
  stop_words <- 
      tibble::tibble(add_stop_words) %>%
          magrittr::set_colnames(term) %>%
          dplyr::bind_rows(stop_words)
  df <- dplyr::anti_join(df, stop_words)
  return(df)
}

#' @rdname clean_up
#' @export
replace_words <- function(df, 
                          term = "term",
                          synonym_df = NULL,
                          synonym_from = NULL,
                          synonym_to = NULL,
                          ...){ # `...' will be omitted
  if(is.null(synonym_df) & is.null(synonym_from) & is.null(synonym_to))
      return(df)
  rep_words        <- synonym_to
  names(rep_words) <- synonym_from
  if(!is.null(synonym_df)){
    rep_words        <- c(synonym_to,   synonym_df[[2]]) # 2: TO
    names(rep_words) <- c(synonym_from, synonym_df[[1]]) # 1: FROM
  }
  # rep_words        <- "書籍"
  # names(rep_words) <- "本"
  df <- 
    df %>%
    dplyr::mutate(`:=`({{term}}, stringr::str_replace_all(.data[[term]], rep_words)))
  return(df)
}
