  #' Morphological analysis for a speciefic column in dataframe
  #'
  #' Using MeCab in morphological analysis
  #' Keep other colnames in dataframe
  #'
  #' @param tbl          Tibble or data.frame.
  #' @param text_col     Text. Colnames for morphological analysis.
  #' @param bin_dir      Text，Directory of mecab.
  #' @param tmp_dir      Text，Temporary directory for text.
  #' @param fileEncoding Text, Fileencoding in mecab. "EUC", "CP932" (shift_jis) or "UTF-8".
  #'
  #' @return Tibble.
  #'
  #' @seealso mecab()
  #'
  #' @examples
  #' # not run
  #' # data(neko)
  #' # bin_dir <- "c:/mecab/bin/" # input your environment
  #' # fileEncoding <- "CP932"    # input your environment
  #' # neko %>%
  #' #   tibble::tibble(text=., cols=rep(1:2, each=2))
  #' # mecab_all(neko, text_col="text", bin_dir=bin_dir, fileEncoding=fileEncoding) %>%
  #' #   print(n=nrow(.))
  #'
  #' @export
mecab_all <- function(
    tbl,
    text_col = "text",
    bin_dir = ".",
    tmp_dir = NULL,
    fileEncoding = "CP932"
  ){
  tbl <- tbl %>% dplyr::mutate(text_id=1:nrow(tbl))
  others <- dplyr::select(tbl, !dplyr::all_of(text_col))
  tbl %>%
    dplyr::select(dplyr::all_of(text_col)) %>%
    mecab(bin_dir, tmp_dir, fileEncoding) %>%
    add_text_id() %>%
    dplyr::left_join(others) %>%
    dplyr::slice(-nrow(.))
}

  #' Morphological analysis for text
  #'
  #' Using MeCab in morphological analysis
  #'
  #' @param tbl          Tibble or data.frame.
  #' @param bin_dir      Text，Directory of mecab.
  #' @param tmp_dir      Text，Temporary directory for text.
  #' @param fileEncoding Text, Fileencoding in mecab. "EUC", "CP932" (shift_jis) or "UTF-8".
  #'
  #' @return Tibble.       Output of MeCab.
  #'
  #' @seealso mecab_all()
  #'
  #' @examples
  #' # not run
  #' # data(neko)
  #' # bin_dir <- "c:/mecab/bin"  # input your environment
  #' # fileEncoding <- "CP932"    # input your environment
  #' # mecab(neko, bin_dir=bin_dir, fileEncoding=fileEncoding)
  #'
  #' @export
mecab <- function(
    tbl,          # tbl of input text
    bin_dir,      # bin directory of mecab
    tmp_dir,      # temporary directory for text
    fileEncoding  #
  ){
  # set file names
  if(is.null(tmp_dir)){tmp_dir <- bin_dir}
  mecab <- stringr::str_c(bin_dir, "mecab ")     # needs space after "mecab" for separater
  input <- stringr::str_c(tmp_dir, "input.txt")
  output <- stringr::str_c(tmp_dir, "output.txt")
  # write file for morphological analysis
    # (maybe) can not set file encoding in write_tsv()
  utils::write.table(tbl, input, quote=FALSE, col.names=FALSE, row.names=FALSE, fileEncoding=fileEncoding)
  # run command
  cmd <- stringr::str_c(mecab, input,  " -o ", output)
  system(cmd)
  # read result file
  out_cols <- c("\u8868\u5c64\u5f62", "\u54c1\u8a5e", "\u54c1\u8a5e\u7d30\u5206\u985e1",
    "\u54c1\u8a5e\u7d30\u5206\u985e2", "\u54c1\u8a5e\u7d30\u5206\u985e3", "\u6d3b\u7528\u578b",
    "\u6d3b\u7528\u5f62", "\u539f\u5f62", "\u8aad\u307f", "\u767a\u97f3")
  tbl <-
    readLines(output, encoding=fileEncoding) %>%
    tibble::tibble() %>%
    tidyr::separate(1, sep="\t|,", into=letters[1:10], fill="right", extra="drop") %>%
    magrittr::set_colnames(out_cols)
  unlink(c(input, output))   # delete temporary file
  tbl
}

  #' Add id column into result of morphological analysis
  #'
  #' internal function for mecab_all()
  #'
  #' @param tbl          Tibble or data.frame.
  #  @param text_id      Text. Colnames for id of text.
  #'
  #' @return Tibble.
  #'
  #' @export
add_text_id <- function(
    tbl,
    text_id="text_id"
  ){
  cnames <- colnames(tbl)
  tbl %>%
    dplyr::mutate(tmp =
      dplyr::case_when((dplyr::select(tbl, 1)=="EOS" & is.na(dplyr::select(tbl, 2))) ~ 1, TRUE ~ 0)
    ) %>%
    dplyr::mutate(tmp = purrr::accumulate(tmp, magrittr::add)) %>%
    dplyr::mutate(tmp = tmp + 1) %>%
    magrittr::set_colnames(c(cnames, text_id))
}
