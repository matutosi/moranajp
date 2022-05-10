test_that("add_series_no and add_text_id work", {
    times <- 2:4
    tbl <- 
      tibble::tibble(col=c(rep("a", times[1]), "EOS", rep("b", times[2]), "EOS", rep("c", times[3]), "EOS"), col_na=NA)
    res <- c(rep(1, times[1] + 1), rep(2, times[2] + 1), rep(3, times[3] + 1))       # "+ 1": because of EOS
    res_false <- c(rep(0, times[1]), rep(1, times[2] + 1), rep(2, times[3] + 1), 3)  # when separator indicate start
      # add_series_no()
    expect_equal(add_series_no(tbl, cond=".$col == 'EOS' & !is.na(.$col_na)")$series_no, rep(1, nrow(tbl)))
    expect_equal(add_series_no(tbl, cond=".$col == 'EOS' &  is.na(.$col_na)")$series_no, res)
    expect_equal(add_series_no(tbl, cond=".$col == 'EOS'", end_sep=FALSE)$series_no, res_false) # when separator indicate start
      # add_text_id()
    expect_equal(add_text_id(tbl)$text_id, res)
})

test_that("text_id of moranajp matches text number", {
    bin_dir <- c("d:/pf/mecab/bin", "/opt/local/mecab/bin")
    bin_dir <- bin_dir[file.exists(bin_dir)]
    if(length(bin_dir) == 1){
      res <- 
          neko %>%
          dplyr::mutate(text=stringi::stri_unescape_unicode(text)) %>%
          dplyr::mutate(cols=1:nrow(.)) %>%
          moranajp_all(text_col="text", bin_dir=bin_dir, iconv = "CP932_UTF-8")
    }
    skip_if(length(bin_dir) != 1)
        expect_equal(res$cols, res$text_id)
})

test_that("cmd makes (this command is only for test)", {
    tbl <- "This is sample, so not tibble."
    bin_dir <- "d:/pf/mecab"
    option <- "some options"
    if(stringr::str_detect(Sys.getenv(c("OS")), "Windows")){
        exp <- "echo This is sample, so not tibble. \\|d:\\pf\\mecab\\mecab -b 120 some options"
    } else {
        exp <- "echo This is sample, so not tibble. |d:/pf/mecab/mecab -b 120 some options"
    }
    expect_equal(make_cmd_mecab(tbl, bin_dir, option), exp)

    bin_dir <- "d:/pf/mecab/"
    option <- NULL
    if(stringr::str_detect(Sys.getenv(c("OS")), "Windows")){
        exp <- "echo This is sample, so not tibble. \\|d:\\pf\\mecab\\mecab -b 120 "
    } else {
        exp <- "echo This is sample, so not tibble. |d:/pf/mecab/mecab -b 120 "
    }
    expect_equal(make_cmd_mecab(tbl, bin_dir, option), exp)

})
