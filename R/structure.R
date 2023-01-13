#' Find relateve position of a common word in a sentence
#'
#' Helper function for mark()
#' @param   x,y  A string vector
#' @return  numeric from 1 to 0.
#'          1   : common word in y with x locate in a head of y.
#'          > 0 : (len - i + 1) / len;
#'                  where len is the length of y,
#'                  i is the position of common word.
#'          0   : no common word.
#' @examples
#' x <- sample(letters, 3, FALSE)
#' y <- sample(letters, 3, FALSE)
#' position_sentence(x, y)
#' 
#' 
#' 
#' 
#' @export
position_sentence <- function(x, y){
  len <- length(y)
  for(i in seq(len)){
    no_word <- sum(stringr::str_detect(x, y[i]))
    if( no_word ){ return( (len - i + 1) / len ) }
  }
  return(0)
}

position_paragraph <- function(tbl){
  #   len_x <-
  len_y <- max(tbl$s_id)
  for(i in 2:len_y){
    y <- dplyr::filter(tbl, s_id == i)$word
    for(j in 1:(i-1)){
      x <- dplyr::filter(tbl, s_id == j)$word
      pos <- position_sentence(x, y)
    }
  }
}


#' Delete parenthesis and its internals
#'
#' @param   df A dataframe analysed by MeCab
#' @return  A dataframe
#' @examples
#' library(tidyverse)
#' data(review_mecab)
#' cols <- c("text_id", "\\u8868\\u5c64\\u5f62", "\\u54c1\\u8a5e", 
#'           "\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1", "\\u539f\\u5f62") %>%
#'         stringi::stri_unescape_unicode()
#' review_mecab %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.))) %>%
#'   dplyr::mutate(`:=`(text_id, as.numeric(text_id))) %>%
#'   dplyr::filter(text_id < 5) %>%
#'   dplyr::select(tidyselect::all_of(cols)) %>%
#'   print(n=120) %>%
#'   delete_parenthesis() %>%
#'   print(n=120)
#' 
#' @export
delete_parenthesis <- function(df){
  pos <- stringi::stri_unescape_unicode("\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1")
  pare_begin <- stringi::stri_unescape_unicode("\\u62ec\\u5f27\\u958b")
  pare_end   <- stringi::stri_unescape_unicode("\\u62ec\\u5f27\\u9589")
  df %>%
    dplyr::mutate(`:=`(paren, 
      case_when(
        .data[[pos]] == pare_begin ~ -1,
        .data[[pos]] == pare_end   ~  1,
        TRUE ~ 0
      )
    )) %>%
    dplyr::mutate(`:=`(del, 
      purrr::accumulate(paren, `+`)
    )) %>%
    dplyr::filter(del == 0 & paren == 0) %>%
    dplyr::select(-all_of(c("paren", "del")))
}
