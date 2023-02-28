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
#' @param add_depend       A logical. Available for ginza
#' @param ...              Extra arguments to internal fuctions.
#' @return A dataframe.
#' @name clean_up
#' @examples
#' library(magrittr)
#' data(neko_mecab)
#' data(neko_ginza)
#' data(review_sudachi_c)
#' data(synonym)
#' synonym <- 
#'   synonym %>% unescape_utf()
#' 
#' neko_mecab <- 
#'   neko_mecab %>%
#'   unescape_utf() %>%
#'   print()
#' 
#' neko_mecab %>%
#'   clean_up(use_common_data = TRUE, synonym_df = synonym)
#' 
#' neko_ginza %>%
#'   unescape_utf() %>%
#'   add_sentence_no() %>%
#'   clean_up(add_depend = TRUE, use_common_data = TRUE, synonym_df = synonym)
#' 
#' review_sudachi_c %>%
#'   unescape_utf() %>%
#'   add_sentence_no() %>%
#'   clean_up(use_common_data = TRUE, synonym_df = synonym)
#' 
#' @export
clean_up <- function(df, add_depend = FALSE, ...){
  df <- 
    df %>%
    pos_filter() %>%
    delete_stop_words(...) %>%
    replace_words(...)
  if(add_depend){ df <- add_depend_ginza(df) }
  return(df)
}

#' @rdname clean_up
#' @export
pos_filter <- function(df){
  pos_0 <- term_pos_0(df)
  pos_1 <- term_pos_1(df)
  filter_pos_0 <- 
    c("\\u540d\\u8a5e",      "\\u52d5\\u8a5e",
      "\\u5f62\\u5bb9\\u8a5e", "\\u5f62\\u72b6\\u8a5e") %>%
    unescape_utf()
  filter_pos_1 <- 
    c("\\u666e\\u901a\\u540d\\u8a5e",
      "\\u56fa\\u6709\\u540d\\u8a5e",
      "\\u56fa\\u6709",
      "\\u4e00\\u822c",
      "\\u81ea\\u7acb",
      "\\u30b5\\u5909\\u63a5\\u7d9a",
      "\\u5f62\\u5bb9\\u52d5\\u8a5e\\u8a9e\\u5e79",
      "\\u30ca\\u30a4\\u5f62\\u5bb9\\u8a5e\\u8a9e\\u5e79",
      "\\u526f\\u8a5e\\u53ef\\u80fd") %>%
      unescape_utf()
  df %>%
    dplyr::filter(.data[[pos_0]] %in% filter_pos_0) %>%
    dplyr::filter(.data[[pos_1]] %in% filter_pos_1)
}

#' @rdname clean_up
#' @export
add_depend_ginza <- function(df){
  s_id <- "sentence"
  term <- term_lemma(df)
  head <- ifelse("head" %in% colnames(df), 
                 "head",  
                 unescape_utf("\\u4fc2\\u53d7\\u5143"))
  h_id <- paste0(head, "_id")
  t_dep <- paste0(term, "_dep")
  if(!s_id %in% colnames(df)) df <- add_sentence_no(df, {{s_id}})

  df <- 
    df %>%
    dplyr::mutate(
        "word_no" := .data[["id"]], 
        "id" := stringr::str_c(.data[[s_id]], "_", .data[["word_no"]]))
  depend <- 
    df %>%
    dplyr::select({{h_id}} := .data[["id"]], {{t_dep}} := .data[[term]])
  df <- 
    df %>%
    dplyr::mutate({{h_id}} := 
        stringr::str_c(.data[[s_id]], "_", .data[[head]])) %>%
    dplyr::left_join(depend)
  return(df)
}

#' @rdname clean_up
#' @export
delete_stop_words <- function(df,
                              use_common_data = TRUE,
                              add_stop_words = NULL,
                              ...){ # `...' will be omitted
  term <- term_lemma(df)
  stop_words <- 
    if(use_common_data){
        utils::data(stop_words, envir = environment())
        stop_words %>%
          purrr::map_dfr(unescape_utf) %>%
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
                          synonym_df = NULL,
                          synonym_from = NULL,
                          synonym_to = NULL,
                          ...){ # `...' will be omitted
  if(is.null(synonym_df) & is.null(synonym_from) & is.null(synonym_to))
      return(df)
  term <- term_lemma(df)
  rep_words        <- synonym_to
  names(rep_words) <- synonym_from
  if(!is.null(synonym_df)){
    rep_words        <- c(synonym_to,   synonym_df[[2]]) # 2: TO
    names(rep_words) <- c(synonym_from, synonym_df[[1]]) # 1: FROM
  }
  df <- 
    df %>%
    dplyr::mutate(`:=`({{term}}, stringr::str_replace_all(.data[[term]], rep_words)))
  return(df)
}

#' @rdname clean_up
#' @export
term_lemma <- function(df){
  term <- ifelse("lemma" %in% colnames(df), 
          "lemma",  
          unescape_utf("\\u539f\\u5f62"))
  return(term)
}

#' @rdname clean_up
#' @export
term_pos_0 <- function(df){
  pos_0 <- ifelse("pos"   %in% colnames(df), 
                  "pos",
                  unescape_utf("\\u54c1\\u8a5e"))
  return(pos_0)
}

#' @rdname clean_up
#' @export
term_pos_1 <- function(df){
  pos_1 <- ifelse("pos_1" %in% colnames(df), 
                  "pos_1", 
                  unescape_utf("\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1"))
  return(pos_1)
}
