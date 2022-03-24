#' Morphological analysis for a speciefic column in dataframe
#'
#' Using MeCab in morphological analysis
#' Keep other colnames in dataframe
#'
#' @param tbl          A tibble or data.frame.
#' @param text_col     A text. Colnames for morphological analysis.
#' @param bin_dir      A text，Directory of mecab.
#' @param tmp_dir      A text，Temporary directory for text.
#' @param fileEncoding A text, Fileencoding in mecab. 
#'                     "EUC", "CP932" (shift_jis) or "UTF-8".
#' @return Tibble. Output of MeCab.
#' @seealso mecab()
#' @examples
#' # not run
#' # library(tidyverse)
#' # bin_dir <- "d:/pf/mecab/bin/" # input your environment
#' # fileEncoding <- "CP932"    # input your environment
#' # data(neko)
#' # neko <- 
#' #   neko %>%
#' #   dplyr::mutate(text=stringi::stri_unescape_unicode(text)) %>%
#' #   dplyr::mutate(cols=1:nrow(.))
#' # mecab_all(neko, 
#' #           text_col="text", 
#' #           bin_dir=bin_dir, 
#' #           fileEncoding=fileEncoding) %>%
#' #   print(n=100)
#' @export
mecab_all <- function(
    tbl,
    text_col = "text",
    bin_dir = ".",
    tmp_dir = NULL,
    fileEncoding = "CP932"
  ){
  tbl <- dplyr::mutate(tbl, text_id=1:nrow(tbl))
  others <- dplyr::select(tbl, !dplyr::all_of(text_col))
  if(stringr::str_detect(stringr::str_c(tbl[[text_col]], collapse=FALSE), "\\r\\n")) message("Removed line breaks !")
  if(stringr::str_detect(stringr::str_c(tbl[[text_col]], collapse=FALSE), "\\n"))    message("Removed line breaks !")
  tbl <-  # remove line breaks
    tbl %>%
    dplyr::mutate(!!text_col := stringr::str_replace_all(.data[[text_col]], "\\r\\n", "")) %>%
    dplyr::mutate(!!text_col := stringr::str_replace_all(.data[[text_col]], "\\n", ""))
  tbl <- 
    tbl %>%
    dplyr::select(dplyr::all_of(text_col)) %>%
    mecab(bin_dir, tmp_dir, fileEncoding) %>%
    add_text_id() %>%
    dplyr::left_join(others, by="text_id") %>%
    dplyr::relocate(.data[["text_id"]])
  return(dplyr::slice(tbl, -nrow(tbl)))
}

#' @rdname mecab_all
#' @export
mecab <- function(
    tbl,          # tbl of input text
    bin_dir,      # bin directory of mecab
    tmp_dir,      # temporary directory for text
    fileEncoding  #
  ){
    # set file names and command
  if(is.null(tmp_dir)){tmp_dir <- bin_dir}
  mecab <- stringr::str_c(bin_dir, "mecab", " ")     # NEEDS SPACE after "mecab" for separater
  input <- stringr::str_c(tmp_dir, "input.txt")
  output <- stringr::str_c(tmp_dir, "output.txt")
  cmd <- stringr::str_c(mecab, input,  " -o ", output)
    # write file for morphological analysis
    #   (maybe) can not set file encoding in write_tsv()
  utils::write.table(tbl, input, quote=FALSE, col.names=FALSE, row.names=FALSE, fileEncoding=fileEncoding)
    # run command in a terminal
  system(cmd)
    # read result file
    # # ref: stringi::stri_escape_unicode(), stringi::stri_unescape_unicode()
  out_cols <- c("\u8868\u5c64\u5f62", "\u54c1\u8a5e", "\u54c1\u8a5e\u7d30\u5206\u985e1",
    "\u54c1\u8a5e\u7d30\u5206\u985e2", "\u54c1\u8a5e\u7d30\u5206\u985e3", "\u6d3b\u7528\u578b",
    "\u6d3b\u7528\u5f62", "\u539f\u5f62", "\u8aad\u307f", "\u767a\u97f3")
  tbl <-
    readLines(con=file(output, encoding=fileEncoding)) %>%
    tibble::tibble() %>%
    tidyr::separate(1, sep="\t|,", into=letters[1:10], fill="right", extra="drop") %>%
    magrittr::set_colnames(out_cols)
  unlink(c(input, output))   # delete temporary file
  return(tbl)
}

#' Add id column into result of morphological analysis
#'
#' Internal function for mecab_all(). 
#' "EOF" means breaks of the end of a result in morphological analysis. 
#' add_text_id() add 1 to text_id column when there is "EOS" & NA. 
#' 
#' @param tbl     A tibble or data.frame.
#' @param text_id A text. Colnames for id of text.
#' @return        A tibble.
add_text_id <- function(tbl, text_id="text_id"){
  # tbl <- a
  cnames <- colnames(tbl)
  if (any("text_id" %in% cnames)) stop("colnames must NOT have a colname 'text_id'")
  tbl <- 
    tbl %>%
    dplyr::mutate(!!"tmp" := 
      dplyr::case_when((dplyr::select(tbl, 1)=="EOS" & is.na(dplyr::select(tbl, 2))) ~ 1, TRUE ~ 0)
    ) %>%
    dplyr::mutate(!!"tmp" := purrr::accumulate(.data[["tmp"]], magrittr::add)) %>%
    dplyr::mutate(!!"tmp" := .data[["tmp"]] + 1) %>%
    magrittr::set_colnames(c(cnames, text_id))
  return(tbl)
}
