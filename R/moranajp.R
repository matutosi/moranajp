#' Morphological analysis for a specific column in dataframe
#'
#' Using 'MeCab' for morphological analysis.
#' Keep other colnames in dataframe.
#'
#' @param tbl          A tibble or data.frame.
#' @param text_col     A text. Colnames for morphological analysis.
#' @param bin_dir      A text. Directory of mecab.
#' @param option       A text. Options for mecab.
#'                     "-b" option is already set by moranajp.
#'                     See by "mecab -h".
#' @param iconv        A text. Convert encoding of MeCab output. 
#'                     Default (""): don't convert. 
#'                     "CP932_UTF-8": iconv(output, from = "Shift-JIS" to = "UTF-8")
#'                     "EUC_UTF-8"  : iconv(output, from = "eucjp", to = "UTF-8")
#' @return A tibble.   Output of 'MeCab' and added column "text_id".
#' @examples
#' \dontrun{
#'   library(tidyverse)
#'   data(neko)
#'   neko <-
#'       neko %>%
#'       dplyr::mutate(text=stringi::stri_unescape_unicode(text)) %>%
#'       dplyr::mutate(cols=1:nrow(.))
#'   moranajp_all(neko, text_col = "text") %>%
#'       print(n=100)
#' }
#' @export
moranajp_all <- function(tbl, bin_dir, text_col = "text", option = "", iconv = "") {
    text_id <- "text_id"
    tbl <- dplyr::mutate(tbl, `:=`(text_id, 1:nrow(tbl)))
    others <- dplyr::select(tbl, !dplyr::all_of(text_col))
    if (stringr::str_detect(
            stringr::str_c(tbl[[text_col]], collapse = FALSE), "\\r\\n"))
        message("Removed line breaks !")
    if (stringr::str_detect(stringr::str_c(tbl[[text_col]], collapse = FALSE), "\\n"))
        message("Removed line breaks !")
    if (stringr::str_detect(stringr::str_c(tbl[[text_col]], collapse = FALSE), '&|\\||<|>|"'))
        message('Removed &, |, <. > or " !')
      # remove line breaks and '&||<>"'
    tbl <-
        tbl %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], "\\r\\n", ""))) %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], "\\n", ""))) %>%
        dplyr::mutate(`:=`({{text_col}},
            stringr::str_replace_all(.data[[text_col]], '&|\\||<|>|"', "")))
    group <- "tmp_group"
    tbl <-
        tbl %>%
        make_groups(text_col = text_col, length = 8000, group = group) %>%
        dplyr::group_split(.data[[group]]) %>%
        purrr::map(dplyr::select, dplyr::all_of(text_col)) %>%
        purrr::map(moranajp, bin_dir = bin_dir, option = option, iconv = iconv) %>%
        dplyr::bind_rows() %>%
        add_text_id() %>%
        dplyr::left_join(others, by = text_id) %>%
        dplyr::relocate(.data[[text_id]], colnames(others))
    return(dplyr::slice(tbl, -nrow(tbl)))
}

#' @rdname moranajp_all
#' @export
moranajp <- function(tbl, bin_dir, option = "", iconv = "") {
      # Make command
    cmd <- make_cmd_mecab(tbl, bin_dir, option = "")
      # Run
    if(stringr::str_detect(Sys.getenv(c("OS")), "Windows")){
        output <- shell(cmd, intern=TRUE)
    } else {
        output <- system(cmd, intern=TRUE)
    }
      # Convert Encoding
    if(iconv == "CP932_UTF-8")
        output <- iconv(output, from = "Shift-JIS", to = "UTF-8")
    if(iconv == "EUC_UTF-8")
        output <- iconv(output, from = "eucjp", to = "UTF-8")
      # To tidy data
    out_cols <- out_cols_mecab()
    tbl <-
        output %>%
        tibble::tibble() %>%
        tidyr::separate(1, sep = "\t|,",
            into = letters[1:length(out_cols)], fill = "right", extra = "drop") %>%
        magrittr::set_colnames(out_cols)
    return(tbl)
}

#' @rdname moranajp_all
make_cmd_mecab <- function(tbl, bin_dir, option = "") {
      # check and modify directory name
    if(stringr::str_detect(Sys.getenv(c("OS")), "Windows")){
        bin_dir <- stringr::str_replace_all(bin_dir, "/", "\\\\")
        if(stringr::str_sub(bin_dir, start=-1) != "\\") bin_dir <- stringr::str_c(bin_dir, "\\")
    } else {
        if(stringr::str_sub(bin_dir, start=-1) != "/") bin_dir <- stringr::str_c(bin_dir, "/")
    }
      # make text string
    text <-
        tbl %>%
        unlist() %>%
  #         stringi::stri_unescape_unicode() %>%
        stringr::str_c(collapse="EOS")
     # input-buffer size for mecab option
    times_jp2en <- 2      # Most Japanese are 2byte.
    times_reserve <- 2    # Reserve room
    len <- ceiling(stringr::str_length(text) * times_jp2en  * times_reserve)
      # NEEDS SPACES as separater
    if(stringr::str_detect(Sys.getenv(c("OS")), "Windows")){
        cmd <- stringr::str_c("echo ", text, " \\|", bin_dir, "mecab -b ", len, " ", option)
    } else {
        cmd <- stringr::str_c("echo ", text, " |", bin_dir, "mecab -b ", len, " ", option)
    }
    return(cmd)
}

#' @rdname moranajp_all
out_cols_mecab <- function(){
    # ref: stringi::stri_escape_unicode(), stringi::stri_unescape_unicode()
    c("\u8868\u5c64\u5f62", "\u54c1\u8a5e", "\u54c1\u8a5e\u7d30\u5206\u985e1",
      "\u54c1\u8a5e\u7d30\u5206\u985e2", "\u54c1\u8a5e\u7d30\u5206\u985e3",
      "\u6d3b\u7528\u578b", "\u6d3b\u7528\u5f62",
      "\u539f\u5f62", "\u8aad\u307f", "\u767a\u97f3")
}

#' Add series no col according to match condition.
#'
#' @param tbl     A tibble or data.frame.
#' @param cond    Condition to split series no.
#' @param new_col A string name of new column.
#' @param end_sep A logical. TRUE: condition indicate the end of separation.
#' @examples
#' \dontrun{
#'   tbl <- tibble::tibble(col=c(rep("a", 2), "sep", rep("b", 3), "sep", rep("c", 4), "sep"))
#'   cond <- ".$col == 'sep'"   # Use ".$'colname'" to identify column
#'     # when separator indicate the end
#'   add_series_no(tbl, cond = cond, end_sep = TRUE,  new_col = "series_no")
#'     # when separator indicate the begining
#'   add_series_no(tbl, cond = cond, end_sep = FALSE, new_col = "series_no")
#' }
#'
#' @return        A tibble, which include new_col as series no.
#' @export
add_series_no <- function(tbl, cond = "", end_sep = TRUE, new_col = "series_no") {
    cnames <- colnames(tbl)
    if (any(new_col %in% cnames))
        stop("colnames must NOT have a colname", new_col)
    tbl <-
        tbl %>%
        dplyr::mutate(`:=`({{new_col}},
            dplyr::case_when(eval(str2expression(cond)) ~ 1, TRUE ~ 0))) %>%
        dplyr::mutate(`:=`({{new_col}},
            purrr::accumulate(.data[[new_col]], magrittr::add)))
    if(end_sep){  # when condition indicate the end of separation
        tbl <-
            tbl %>%
            dplyr::mutate(`:=`({{new_col}}, .data[[new_col]] + 1)) %>%
            dplyr::mutate(`:=`({{new_col}},
                dplyr::lag(.data[[new_col]], default=1)))
    }
   return(tbl)
}

#' Add id column into result of morphological analysis
#'
#' Internal function for moranajp_all().
#' 'EOS' means breaks of text in this package (and most of morphological analysis).
#' add_text_id() add `text_id` column when there is 'EOS'.
#'
#' @rdname   add_series_no
#' @return   A tibble.
#' @export
add_text_id <- function(tbl) {
    text_id <- "text_id"
    cnames <- colnames(tbl)
    if (any(text_id %in% cnames))
        stop("colnames must NOT have a colname 'text_id'")
    tbl <- add_series_no(tbl, cond = "tbl[[1]] == 'EOS'", new_col = text_id)
    return(tbl)
}

#' @rdname moranajp_all
#' @export
mecab_all <- function(tbl, text_col = "text", bin_dir = "") {
  message("'mecab_all()' will be removed in version 1.0.0.")
  .Deprecated("moranajp_all")
  moranajp_all(tbl=tbl, text_col = text_col)
}
#' @rdname moranajp_all
#' @export
mecab <- function(tbl, bin_dir) {
  message("'mecab()' will be removed in version 1.0.0.")
  .Deprecated("moranajp")
  moranajp(tbl = tbl, bin_dir = bin_dir)
}
