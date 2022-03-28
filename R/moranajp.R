#' Morphological analysis for a specific column in dataframe
#'
#' Using 'MeCab' for morphological analysis.
#' Keep other colnames in dataframe.
#'
#' @param tbl              A tibble or data.frame.
#' @param text_col         A text. Colnames for morphological analysis.
#' @param bin_dir,tmp_dir  A text. Directory of 'MeCab' and temporal use.
#' @param fileEncoding     A text. fileEncoding in 'MeCab'. 
#'                         "EUC", "CP932" (shift_jis) or "UTF-8".
#' @param input,output     A text. File path of input and output.
#' @return A tibble.   Output of 'MeCab' and added column "text_id".
#' @examples
#' \dontrun{
#'   library(tidyverse)
#'   bin_dir <- "d:/pf/mecab/bin/"  # input your environment
#'   tmp_dir <- "d:/"               # input your environment
#'   fileEncoding <- "CP932"        # input your environment
#'   data(neko)
#'   neko <- 
#'       neko %>%
#'       dplyr::mutate(text=stringi::stri_unescape_unicode(text)) %>%
#'       dplyr::mutate(cols=1:nrow(.))
#'   moranajp_all(neko, text_col = "text", 
#'          bin_dir = bin_dir, tmp_dir = tmp_dir, fileEncoding = fileEncoding) %>%
#'       print(n=100)
#' }
#' @export
moranajp_all <- function(tbl, text_col = "text", bin_dir = "", tmp_dir = bin_dir, fileEncoding = "CP932") {
    tbl <- dplyr::mutate(tbl, `:=`("text_id", 1:nrow(tbl)))
    others <- dplyr::select(tbl, !dplyr::all_of(text_col))
    if (stringr::str_detect(
            stringr::str_c(tbl[[text_col]], collapse = FALSE), "\\r\\n"))
        message("Removed line breaks !")
    if (stringr::str_detect(stringr::str_c(tbl[[text_col]], collapse = FALSE), "\\n"))
        message("Removed line breaks !")
      # remove line breaks
    tbl <- 
        tbl %>%
        dplyr::mutate(`:=`(!!text_col, 
            stringr::str_replace_all(.data[[text_col]], "\\r\\n", ""))) %>%
        dplyr::mutate(`:=`(!!text_col, 
            stringr::str_replace_all(.data[[text_col]], "\\n", "")))
    tbl <- 
        tbl %>%
        dplyr::select(dplyr::all_of(text_col)) %>%
        moranajp(bin_dir = bin_dir, tmp_dir = tmp_dir, fileEncoding = fileEncoding) %>%
        add_text_id() %>%
        dplyr::left_join(others, by = "text_id") %>%
        dplyr::relocate(.data[["text_id"]], colnames(others))
    return(dplyr::slice(tbl, -nrow(tbl)))
}

#' @rdname moranajp_all
#' @export
moranajp <- function(tbl, bin_dir, tmp_dir, fileEncoding) {
      # set file names and command
    input  <- stringr::str_c(tmp_dir, "input.txt")
    output <- stringr::str_c(tmp_dir, "output.txt")
      # write file for morphological analysis
      #     (maybe) can not set file encoding in write_tsv()
    utils::write.table(tbl, input, 
            quote = FALSE, col.names = FALSE, row.names = FALSE, 
            fileEncoding = fileEncoding)
      # run command in a terminal
    cmd <- make_cmd_mecab(bin_dir, input, output)
    system(cmd)
      # read a result file
    out_cols <- out_cols_mecab()
    tbl <- 
        readLines(con = file(output, encoding = fileEncoding)) %>%
        tibble::tibble() %>%
        tidyr::separate(1, sep = "\t|,", 
            into = letters[1:length(out_cols)], fill = "right", extra = "drop") %>%
        magrittr::set_colnames(out_cols)
    file.remove(c(input, output))  # delete temporary file
    return(tbl)
}

#' @rdname moranajp_all
make_cmd_mecab <- function(bin_dir, input, output) {
    mecab <- stringr::str_c(bin_dir, "mecab") 
        # NEEDS SPACE after 'mecab' as separater
    cmd <- stringr::str_c(mecab,  " ", input, " -o ", output)
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
add_series_no <- function(tbl, cond = "", end_sep = TRUE, new_col = "series_no") {
    cnames <- colnames(tbl)
    if (any(new_col %in% cnames))
        stop("colnames must NOT have a colname", new_col)
    tbl <- 
        tbl %>%
        dplyr::mutate(`:=`(!!new_col, 
            dplyr::case_when(eval(str2expression(cond)) ~ 1, TRUE ~ 0))) %>%
        dplyr::mutate(`:=`(!!new_col, 
            purrr::accumulate(.data[[new_col]], magrittr::add)))
    if(end_sep){  # when condition indicate the end of separation
        tbl <- 
            tbl %>%
            dplyr::mutate(`:=`(!!new_col, .data[[new_col]] + 1)) %>%
            dplyr::mutate(`:=`(!!new_col, 
                dplyr::lag(.data[[new_col]], default=1)))
    }
   return(tbl)
}

#' Add id column into result of morphological analysis
#'
#' Internal function for moranajp_all(). 
#' 'EOS' means breaks of the end of a result in morphological analysis. 
#' add_text_id() add 1 to `text_id` column when there is 'EOS' & NA. 
#' 
#' @param tbl     A tibble or data.frame.
#' @rdname   add_series_no
#' @return   A tibble.
add_text_id <- function(tbl) {
    text_id <- "text_id"
    cnames <- colnames(tbl)
    if (any(text_id %in% cnames))
        stop("colnames must NOT have a colname 'text_id'")
    tbl <- 
        add_series_no(tbl,
                      cond = "tbl[[1]] == 'EOS' & is.na(tbl[[2]])",
                      new_col = text_id
        )
    return(tbl)
}

#' @rdname moranajp_all
#' @export
mecab_all <- function(tbl, text_col = "text", bin_dir = "", tmp_dir = bin_dir, fileEncoding = "CP932") {
  message("'mecab_all()' will be removed in version 1.0.0.")
  .Deprecated("moranajp_all")
  moranajp_all(tbl=tbl, text_col = text_col, bin_dir = bin_dir, fileEncoding = fileEncoding)
}
#' @rdname moranajp_all
#' @export
mecab <- function(tbl, bin_dir, tmp_dir, fileEncoding) {
  message("'mecab()' will be removed in version 1.0.0.")
  .Deprecated("moranajp")
  moranajp(tbl = tbl, bin_dir = bin_dir, tmp_dir = tmp_dir, fileEncoding = fileEncoding)
}
