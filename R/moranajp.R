#' Morphological analysis for a specific column in dataframe
#' 
#' Using 'MeCab' for morphological analysis.
#' Keep other colnames in dataframe.
#' 
#' @param tbl          A tibble or data.frame.
#' @param text_col     A text. Colnames for morphological analysis.
#' @param bin_dir      A text. Directory of mecab.
#' @param method       A text. Method to use: "mecab" or "ginza".
#' @param option       A text. Options for mecab.
#'                     "-b" option is already set by moranajp.
#'                     To see option, use "mecab -h" in command (win) or terminal (Mac).
#' @param iconv        A text. Convert encoding of MeCab output. 
#'                     Default (""): don't convert. 
#'                     "CP932_UTF-8": iconv(output, from = "Shift-JIS" to = "UTF-8")
#'                     "EUC_UTF-8"  : iconv(output, from = "eucjp", to = "UTF-8")
#'                     iconv is also used to convert input text before running MeCab.
#'                     "CP932_UTF-8": iconv(input, from =  "UTF-8", to = "Shift-JIS")
#' @return A tibble.   Output of 'MeCab' and added column "text_id".
#' @examples
#' \dontrun{
#'   library(tidyverse)
#'   data(neko)
#'   neko <-
#'       neko %>%
#'       dplyr::mutate(text=stringi::stri_unescape_unicode(text))
#'   bin_dir <- "d:/pf/mecab/bin"
#'     # mecab
#'   iconv <- "CP932_UTF-8"
#'   moranajp_all(neko, text_col = "text", bin_dir = bin_dir, iconv = iconv) %>%
#'       print(n=100)
#'     # ginza
#'   moranajp_all(neko, text_col = "text", method = "ginza") %>%
#'       print(n=100)
#' }
#' @export
moranajp_all <- function(tbl, bin_dir = "", method = "mecab", 
                         text_col = "text", option = "", iconv = ""){
    text_id <- "text_id"
    tbl <- dplyr::mutate(tbl, `:=`({{text_id}}, 1:nrow(tbl)))
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
    tmp_group  <- "tmp_group"  # Use temporary
    str_length <- "str_length" # Use temporary
    tbl <-
        tbl %>%
        make_groups(text_col = text_col, length = 8000,   # if error decrease length
            tmp_group = tmp_group, str_length = str_length) %>%
        dplyr::group_split(.data[[tmp_group]]) %>%
        purrr::map(dplyr::select, dplyr::all_of(text_col)) %>%
        purrr::map(moranajp, 
            bin_dir = bin_dir, method = method, 
            text_col = text_col, option = option, iconv = iconv) %>%
        dplyr::bind_rows() %>%
        add_text_id() %>%
        dplyr::left_join(others, by = text_id) %>%
        dplyr::relocate(.data[[text_id]], colnames(others))
    return(dplyr::slice(tbl, -nrow(tbl)))
}

#' @rdname moranajp_all
#' @export
moranajp <- function(tbl, bin_dir, method, text_col, option = "", iconv = ""){
    input <- make_input(tbl, text_col, iconv)
    command <- make_cmd(bin_dir, method, option = "")
    output <- system(command, intern=TRUE, input = input)
    output <- iconv_x(output, iconv) # Convert Encoding
    out_cols <- switch(method, 
        "mecab" = out_cols_mecab(),
        "ginza" = out_cols_ginza()
    )
    tbl <-
        output %>%
        tibble::tibble() %>%
        tidyr::separate(1, into = out_cols, sep = "\t|,",
            fill = "right", extra = "drop")
    if(method == "ginza"){
        tbl <- 
          tbl %>%
          tidyr::separate(.data[["xpos"]], into = stringr::str_c("pos_", 1:3), sep = "-",
            fill = "right", extra = "drop", remove = FALSE)
    }
    return(tbl)
}

#' @rdname moranajp_all
#' @export
make_input <- function(tbl, text_col, iconv){
    input <- 
        tbl %>%
        dplyr::select(.data[[text_col]]) %>%
        unlist() %>%
        stringr::str_c(collapse="EOS") %>%
        iconv_x(iconv, reverse = TRUE)
    return(input)
}

#' @rdname moranajp_all
make_cmd <- function(bin_dir, method, option = ""){
    cmd <- switch(method, 
        "mecab" = make_cmd_mecab(bin_dir, option = ""),
        "ginza" = "ginza",
    )
    return(cmd)
}

#' @rdname moranajp_all
make_cmd_mecab <- function(bin_dir, option = ""){
      # check and modify directory name
    if(stringr::str_detect(Sys.getenv(c("OS")), "Windows")){
        bin_dir <- stringr::str_replace_all(bin_dir, "/", "\\\\")
        if(stringr::str_sub(bin_dir, start=-1) != "\\") bin_dir <- stringr::str_c(bin_dir, "\\")
    } else {
        if(stringr::str_sub(bin_dir, start=-1) != "/") bin_dir <- stringr::str_c(bin_dir, "/")
    }
    cmd <- stringr::str_c(bin_dir, "mecab -b 17000", option)
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

#' @rdname moranajp_all
out_cols_ginza <- function(){
  # ID: 
  # FORM: Word form or punctuation symbol.
  # LEMMA: Lemma or stem of word form.
  # UPOS: Universal part-of-speech tag.
  # XPOS: Language-specific part-of-speech tag; underscore if not available.
  # FEATS: List of morphological features from the universal feature inventory or from a defined language-specific extension; underscore if not available.
  # HEAD: Head of the current word, which is either a value of ID or zero (0).
  # DEPREL: Universal dependency relation to the HEAD (root iff HEAD = 0) or a defined language-specific subtype of one.
  # DEPS: Enhanced dependency graph in the form of a list of head-deprel pairs.
  # MISC: Any other annotation.
    c("id", "form", "lemma", "upos", "xpos", "feats", "head", "deprel", "deps", "misc")
}

#' Add series no col according to match condition.
#'
#' @param tbl     A tibble or data.frame.
#' @param cond    Condition to split series no.
#' @param new_col A string name of new column.
#' @param starts_with   A integer.
#' @examples
#' \dontrun{
#'   tbl <- tibble::tibble(col=c(rep("a", 2), "sep", rep("b", 3), "sep", rep("c", 4), "sep"))
#'   cond <- ".$col == 'sep'"   # Use ".$'colname'" to identify column
#'   add_series_no(tbl, cond = cond, new_col = "series_no")
#' }
#'
#' @return        A tibble, which include new_col as series no.
#' @export
add_series_no <- function(tbl, cond = "", new_col = "series_no", starts_with = 1){
  tbl %>%
    dplyr::mutate(`:=`({{new_col}}, 
      purrr::accumulate(eval(str2expression(cond)), 
      `+`, .init = starts_with) %>% utils::head(-1) )) # head(-1): remove last one
}

#' Add id column into result of morphological analysis
#'
#' Internal function for moranajp_all().
#' In mecab: add_text_id() add `text_id` column when there is 'EOS'.
#'    'EOS' means breaks of text in this package (and most of morphological analysis).
#' In ginza: add_text_id() add `text_id` column when starts with '#'
#'
#' @inheritParams moranajp_all
#' @export
add_text_id <- function(tbl){
    text_id <- "text_id"
    cnames <- colnames(tbl)
    if (any(text_id %in% cnames))
        stop("colnames must NOT have a colname 'text_id'")
    cond <- "stringr::str_detect(tbl[[1]], 'EOS')"
    tbl <- add_series_no(tbl, cond = cond, new_col = text_id)
    return(tbl)
}

#' @rdname moranajp_all
#' @export
mecab_all <- function(tbl, text_col = "text", bin_dir = ""){
  message("'mecab_all()' will be removed in version 1.0.0.")
  .Deprecated("moranajp_all")
  moranajp_all(tbl=tbl, text_col = text_col)
}
#' @rdname moranajp_all
#' @export
mecab <- function(tbl, bin_dir){
  message("'mecab()' will be removed in version 1.0.0.")
  .Deprecated("moranajp")
  moranajp(tbl = tbl, bin_dir = bin_dir)
}
