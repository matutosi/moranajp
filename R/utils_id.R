#' Add ids.
#' 
#' @param x              A string vector.
#' @param brk            A string to specify the break between ids.
#' @param col            A string to specify the column.
#' @param df             A dataframe.
#' @param end_with_brk   A logical.
#'                       TRUE: brk means the end of groups.
#'                       FALSE: brk means the begining of groups.
#' 
#' @return  id_with_break() returns id vector, add_id_df() returns dataframe.
#' @examples
#' tmp <- c("a", "brk", "b", "brk", "c")
#' brk <- "brk"
#' text_id_with_break(tmp, brk)
#' add_text_id_df(tibble::tibble(tmp), col = "tmp", "brk")
#' 
#' @export
text_id_with_break <- function(x, brk, end_with_brk = TRUE){
  text_id <- purrr::accumulate(x == brk, sum) + 1
  if(end_with_brk) text_id <- c(1, text_id)[-length(text_id)]
  return(text_id)
}

#' @rdname text_id_with_break
#' @export
add_text_id_df <- function(df, col, brk, end_with_brk = TRUE){
  x <- df[[col]]
  text_id <- text_id_with_break(x, brk, end_with_brk)
  dplyr::bind_cols(df, text_id = text_id)
}

#' Add group id column into result of morphological analysis
#' 
#' @param tbl           A dataframe
#' @param col           A string to specify the column including breaks
#' @param brk           A string to specify breaks
#' @param end_with_brk  A logical
#' @return   A dataframe
#' @examples
#' brk <- "EOS"
#' tbl <- tibble::tibble(col=c(rep("a", 2), brk, rep("b", 3), brk, rep("c", 4), brk))
#' add_group(tbl, col = "col")
#' add_group(tbl, col = "col", end_with_brk = FALSE)
#' 
#' @export
add_group <- function(tbl, col, brk = "EOS", grp = "group", 
                      cond = NULL, end_with_brk = TRUE){
  adj <- "adjust"
  if(is.null(cond)){
    cond <- paste0(".$", col, " == '", brk, "'")  # cond: .$col == 'brk'
  }
  tbl <- 
    tbl %>%
    dplyr::mutate(`:=`({{grp}}, 
      (eval(str2expression(cond))) + 0 )) %>%  # "+ 0": boolean to numeric
    dplyr::mutate(`:=`({{grp}}, purrr::accumulate(.data[[grp]], `+`))) %>%
    dplyr::mutate(`:=`({{grp}}, .data[[grp]] + 1))

  if(end_with_brk){
    tbl <- 
      tbl %>%
      dplyr::mutate(`:=`({{adj}}, -(.data[[col]] == brk) + 0 )) %>%
      dplyr::mutate(`:=`({{grp}}, .data[[grp]] + .data[[adj]])) %>%
      dplyr::select(-dplyr::all_of(adj))
  }
  return(tbl)
}

#' Add sentence id
#' 
#' @param   df    A dataframe
#' @param   snt   A string for sentence colame
#' @return  A dataframe
#' @examples
#' review_mecab %>%
#'   unescape_utf() %>%
#'   add_sentence_no()
#' 
#' @export
add_sentence_no <- function(df, snt = "sentence"){
  cnames <- colnames(df)
  if(sum(cnames %in% "lemma") + sum(cnames %in% "pos_1") == 2){
    cond_1 <- ".$lemma %in% c(\\'\\u3002\\', \\'\\uff0e\\')"
    cond_2 <- ".$pos_1 == \\'\\u53e5\\u70b9\\'"
  }else{
    cond_1 <- ".$\\u8868\\u5c64\\u5f62 %in% c(\\'\\u3002\\', \\'\\uff0e\\')"
    cond_2 <- ".$\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1 == \\'\\u53e5\\u70b9\\'"
  }
  cond <- paste0(cond_1, " & ", cond_2) %>% unescape_utf()
  df <- add_group(df, cond = cond)
  return(df)
}

#' Add id in each group
#' 
#' @param tbl           A dataframe
#' @param grp,id        A string to specify the column of group and id
#' @return   A dataframe
#' @examples
#' brk <- "EOS"
#' tbl <- tibble::tibble(col=c(rep("a", 2), brk, rep("b", 3), brk, rep("c", 4), brk))
#' add_group(tbl, col = "col") %>%
#'   add_id(id = "id_in_group")
#' 
#' @export
add_id <- function(tbl, grp = "group", id = "id"){
  tbl %>%
    dplyr::group_by(.data[[grp]]) %>%
    dplyr::mutate(`:=`({{id}}, dplyr::row_number())) %>%
    dplyr::ungroup()
}
