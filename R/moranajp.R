#' Morphological analysis for a specific column in dataframe
#' 
#' Using 'MeCab' for morphological analysis.
#' Keep other colnames in dataframe.
#' 
#' @param tbl          A tibble or data.frame.
#' @param text_col     A text. Colnames for morphological analysis.
#' @param bin_dir      A text. Directory of mecab.
#' @param method       A text. Method to use: "mecab", "ginza", 
#'                     "sudachi_a", "sudachi_b", and "sudachi_c".
#'                     "a", "b" and "c" specify the mode of splitting.
#'                     "a" split shortest, "b" middle and "c" longest.
#'                     See https://github.com/WorksApplications/Sudachi for detail.
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
#' 
#'   # mecab
#'   bin_dir <- "d:/pf/mecab/bin"
#'   iconv <- "CP932_UTF-8"
#'   neko %>%
#'     moranajp_all(text_col = "text", bin_dir = bin_dir, iconv = iconv) %>%
#'         print(n=100)
#' 
#'   # ginza
#'   neko %>%
#'     moranajp_all(text_col = "text", method = "ginza") %>%
#'       print(n=100)
#' 
#'   # sudachi
#'   bin_dir <- "d:/pf/sudachi"
#'   iconv <- "CP932_UTF-8"
#'   neko %>%
#'     moranajp_all(text_col = "text", bin_dir = bin_dir, 
#'                  method = "sudachi_a", iconv = iconv) %>%
#'         print(n=100)
#' 
#' }
#' @export
moranajp_all <- function(tbl, bin_dir = "", method = "mecab", 
                         text_col = "text", option = "", iconv = ""){
  # text_col = "text"; option = ""; iconv = ""
  # text_col = "text"; option = ""; bin_dir <- "d:/pf/mecab/bin/"; iconv   <- "CP932_UTF-8"; method  <- "mecab"; tbl <- review %>% mu
    text_id <- "text_id"
    tbl <-    dplyr::mutate(tbl, `:=`({{text_id}}, dplyr::row_number()))
    others <- dplyr::select(tbl, !dplyr::all_of(text_col))
      # remove line breaks and '&||<>"'
    if (stringr::str_detect(
            stringr::str_c(tbl[[text_col]], collapse = FALSE), "\\r\\n"))
        message("Removed line breaks !")
    if (stringr::str_detect(stringr::str_c(tbl[[text_col]], collapse = FALSE), "\\n"))
        message("Removed line breaks !")
    if (stringr::str_detect(stringr::str_c(tbl[[text_col]], collapse = FALSE), '&|\\||<|>|"'))
        message('Removed &, |, <. > or " !')
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
        dplyr::bind_rows()
    tbl <-
        tbl %>%
        add_text_id(method = method) %>%
        dplyr::left_join(others, by = text_id) %>%
        dplyr::relocate(.data[[text_id]], colnames(others))
    return(dplyr::slice(tbl, -nrow(tbl)))
}

#' @rdname moranajp_all
#' @export
moranajp <- function(tbl, bin_dir, method, text_col, option = "", iconv = ""){
    if(bin_dir != ""){
        wd <- getwd()
        on.exit(setwd(wd))
        setwd(bin_dir)
    }
    input <- make_input(tbl, text_col, iconv)
    command <- make_cmd(method, option = "")
    output <- system(command, intern=TRUE, input = input)
    output <- iconv_x(output, iconv) # Convert Encoding
    out_cols <- switch(method, 
        "mecab"     = out_cols_mecab(),
        "ginza"     = out_cols_ginza(),
        "sudachi_a" = out_cols_sudachi(),
        "sudachi_b" = out_cols_sudachi(),
        "sudachi_c" = out_cols_sudachi()
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
  #     bp <- "EOS"  # End Of Sentence
    bp <- "BPOMORANAJP "  # Break Point Of MORANAJP: need space
    input <- 
        tbl %>%
        dplyr::select(.data[[text_col]]) %>%
        unlist() %>%
        stringr::str_c(collapse = bp) %>%
        stringr::str_c(bp) %>%  # NEED bp at the end of input
        iconv_x(iconv, reverse = TRUE)
    return(input)
}

#' @rdname moranajp_all
make_cmd <- function(method, option = ""){
    cmd <- switch(method, 
        "mecab"     = make_cmd_mecab(option = ""),
        "ginza"     = "ginza",
        "sudachi_a" = "java -jar sudachi.jar -m A",
        "sudachi_b" = "java -jar sudachi.jar -m B",
        "sudachi_c" = "java -jar sudachi.jar -m C",
    )
    return(cmd)
}

#' @rdname moranajp_all
make_cmd_mecab <- function(option = ""){
    cmd <- stringr::str_c("mecab -b 17000", option)
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

#' @rdname moranajp_all
out_cols_sudachi <- function(){
    c("\u8868\u5c64\u5f62", "\u54c1\u8a5e",
      paste0("\u54c1\u8a5e\u7d30\u5206\u985e", 1:5),
      "\u539f\u5f62")
}

#' Add id column into result of morphological analysis
#'
#' Internal function for moranajp_all().
#' Add `text_id` column when there is brk ("BPOMORANAJP").
#'    "BPOMORANAJP": Break Point Of MORANAJP
#'
#' @inheritParams moranajp_all
#' @export
add_text_id <- function(tbl, method){
    text_id <- "text_id"
    cnames  <- colnames(tbl)
    if (any(text_id %in% cnames)){
      stop("colnames must NOT have a colname 'text_id'")
    }
    if(method == "ginza"){
      tbl <- dplyr::filter(tbl, !is.na(.data[[cnames[3]]]))
    }
    brk <- "BPOMORANAJP"
    col_no <- ifelse(method == "ginza", 2, 1)
    col <- cnames[col_no]
    tbl <- add_group(tbl, col = col, brk = brk, grp = text_id)
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
