  #' データフレームの特定の列に対する形態素解析
  #' 
  #' データフレームの特定の列に対して，形態素解析を実行します．
  #' 形態素解析にはMeCabを使用します．
  #' 形態素解析の対象外の列も出力されます．
  #' 
  #' @param tbl          Tibble or data.frame. 
  #' @param text_col     Text. Colnames for morphological analysis. 
  #' @param bin_dir      Text，Directory of mecab.exe. 
  #' @param fileEncoding Text, Fileencoding in mecab. "EUC", "CP932" (shift_jis) or "UTF-8". 
  #' 
  #' @return Tibble. 
  #' 
  #' @seealso mecab()
  #' 
  #' @examples
  #' # not run
  #' # data(neko)
  #' # bin_dir <- "c:/mecab/bin"  # input your environment
  #' # fileEncoding <- "CP932"    # input your environment
  #' # neko %>%
  #' #   tibble::tibble(text=., cols=rep(1:2, each=2))
  #' # mecab_all(neko, text_col="text", bin_dir=bin_dir, fileEncoding=fileEncoding) %>%
  #' #   print(n=nrow(.))
  #' 
  #' @export
mecab_all <- function(
    tbl, 
    text_col="text", 
    bin_dir, 
    fileEncoding="CP932"
  ){
  tbl <- tbl %>% dplyr::mutate(text_id=1:nrow(.))
  others <- dplyr::select(tbl, !dplyr::all_of(text_col))
  tbl %>%
    dplyr::select(dplyr::all_of(text_col)) %>%
    mecab(bin_dir, fileEncoding) %>%
    add_text_id() %>%
    dplyr::left_join(others) %>%
    dplyr::slice(-nrow(.))
}

  #' テキストに対する形態素解析を一括で実行
  #' 
  #' テキストに対する形態素解析を一括で実行します．
  #' 形態素解析にはMeCabを使用します．
  #' 
  #' @param tbl          Tibble or data.frame. 
  #' @param bin_dir      Text，Directory of mecab.exe. 
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
    bin_dir,      # bin file of mecab
    fileEncoding  # 
  ){
  # records current working directory
  o_wd <- getwd()
  on.exit(setwd(o_wd))
  setwd(bin_dir)
  #   data(out_cols)
  #   out_cols <- c("表層形", "品詞", "品詞細分類1", "品詞細分類2", "品詞細分類3", "活用型", "活用形", "原形", "読み", "発音")
  # write file for morphological analysis # (maybe) can not set file encoding in write_tsv()
  utils::write.table(tbl, "input.txt", quote=FALSE, col.names=FALSE, row.names=FALSE, fileEncoding=fileEncoding)
  # run command
  cmd <- stringr::str_c("mecab input.txt -o output.txt")
  shell(cmd)
  # read result file
  tbl <- 
    readLines("output.txt", encoding="CP932") %>%
    tibble::tibble() %>%
  #     magrittr::set_colnames("tmp") %>%
    tidyr::separate(1, sep="\t|,", into=letters[1:10], fill="right", extra="drop") %>%
  #     tidyr::separate(tmp, sep="\t|,", into=letters[1:10], fill="right", extra="drop") %>%
    magrittr::set_colnames(out_cols)
  #     unlink(c("input.txt", "output.txt"))  # delete temporary file
  tbl
}

  #' 形態素解析の結果にid列を追加
  #' 
  #' 形態素解析の結果のデータフレームにid列を追加します．
  #' mecab_all()の内部関数として使用．
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
  #   tbl %>%
  #     dplyr::mutate(tmp = 
  #       dplyr::case_when((dplyr::select(., 1)=="EOS" & is.na(dplyr::select(., 2))) ~ 1, TRUE ~ 0)
  #     ) %>%
  #     dplyr::mutate(tmp = purrr::accumulate(tmp, magrittr::add)) %>%
  #     dplyr::mutate(tmp = tmp + 1) %>%
  #     magrittr::set_colnames(c(cnames, text_id))
}
