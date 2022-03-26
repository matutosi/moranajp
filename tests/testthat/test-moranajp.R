test_that("add_series_no and add_text_id work", {
    times <- 2:4
    tbl <- 
      tibble::tibble(col=c(rep("a", times[1]), "EOS", rep("b", times[2]), "EOS", rep("c", times[3]), "EOS"), col_na=NA)
    res <- c(rep(1, times[1] + 1), rep(2, times[2] + 1), rep(3, times[3] + 1))  # "+ 1": because of EOS
    expect_equal(add_series_no(tbl, cond=".$col == 'EOS' & !is.na(.$col_na)")$series_no, rep(1, nrow(tbl)))
    expect_equal(add_series_no(tbl, cond=".$col == 'EOS' &  is.na(.$col_na)")$series_no, res)
    expect_equal(add_text_id(tbl)$text_id, res)
})

test_that("text_id of moranajp matches text number", {
    bin_dir <- c("d:/pf/mecab/bin/", "/opt/local/mecab/bin/")
    bin_dir <- bin_dir[file.exists(stringr::str_sub(bin_dir, end=-2))]
    fileEncoding <- if(Sys.info()[1] =="Windows") "CP932" else "UTF-8"
    if(length(bin_dir) == 1){
      res <- 
          neko %>%
          dplyr::mutate(text=stringi::stri_unescape_unicode(text)) %>%
          dplyr::mutate(cols=1:nrow(.)) %>%
          moranajp_all(text_col="text", bin_dir=bin_dir, fileEncoding=fileEncoding)
    }
    skip_if(length(bin_dir) != 1)
    expect_equal(res$cols, res$text_id)
})
