#' Add group id column into result of morphological analysis
#'
#' @param tbl           A dataframe
#' @param col           A string to specify the column including breaks
#' @param brk           A string to specify breaks
#' @param grp           A string to specify group
#' @param cond          A string to specify condition
#' @param end_with_brk  A logical
#' @return   A dataframe
#' @examples
#' brk <- "EOS"
#' tbl <- tibble::tibble(col_a = c(rep("a", 2), brk, rep("b", 3), brk, rep("c", 4), brk))
#' add_group(tbl, col = "col_a", grp = "text_id")
#' add_group(tbl, col = "col_a", end_with_brk = FALSE)
#'
#' @export
add_group <- function(tbl, col, brk = "EOS", grp = "group",
                      cond = NULL, end_with_brk = TRUE){
  if(is.null(cond)){ # cond: tbl$col == 'brk'
    cond <- paste0("tbl$", col, " == '", brk, "'")
  }
  tbl <-
    dplyr::mutate(tbl, `:=`({{ grp }},
                            cond |>
                              eval_str() |>
                              cumsum()   |>
                              `+`(e1 = _, e2 = 1) ))
  if(end_with_brk){
    tbl <-
      dplyr::mutate(tbl, `:=`({{ grp }},
                              dplyr::lag(tbl[[grp]], n = 1, default = 1)))
  }
  return(tbl)
}

#' Helper function for add_group()
eval_str <- function(str){
  str |> str2expression() |> eval()
}

#' Wrapper function for add_group() to add sentence id
#'
#' @param   df    A dataframe
#' @return  A dataframe
#' @examples
#' review_mecab |>
#'   unescape_utf() |>
#'   add_sentence_no() |>
#'   print(n=200)
#'
#' @export
add_sentence_no <- function(df){
  cnames <- colnames(df)
  # Use "form" Not "lemma"
  #   ginza returns half size "." (period) not full size for lemma.
  #   so cond_1 does not work when using "lennma".
  #   form is usually full size period, thus it works.
  if(sum(cnames %in% "form") + sum(cnames %in% "pos_1") == 2){
    cond_1 <- "stringr::str_detect(df$form, '\u3002|\uff0e')"
    cond_2 <- ".$pos_1 == '\u53e5\u70b9\\'"
  }else{
    cond_1 <- "stringr::str_detect(df$\u8868\u5c64\u5f62, '\u3002|\uff0e')"
    cond_2 <- "stringr::str_detect(df$\u54c1\u8a5e\u7d30\u5206\u985e1, '\u53e5\u70b9')"
  }
  cond <- paste0(cond_1, " & ", cond_2)
  df <- add_group(df, grp = "sentence", cond = cond)

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
#' add_group(tbl, col = "col") |>
#'   add_id(id = "id_in_group")
#'
#' @export
add_id <- function(tbl, grp = "group", id = "id"){
  tbl |>
    dplyr::group_by(.data[[grp]]) |>
    dplyr::mutate(`:=`({{id}}, dplyr::row_number())) |>
    dplyr::ungroup()
}
