test_that("add_text_id works", {
    times <- 2:4
    tbl <- 
      tibble::tibble(col=c(rep("a", times[1]), "EOS", rep("b", times[2]), "EOS", rep("c", times[3]), "EOS"), col_na=NA)
    res <- c(rep(1, times[1]), rep(2, times[2]), rep(3, times[3]))
    expect_equal(add_text_id(tbl)$text_id, res)
})

test_that("text_id of moranajp matches text number", {
    bin_dir <- "d:/pf/mecab/bin/"
    fileEncoding <- "CP932"
    n_match <- 
        list.files(bin_dir) %>%
        stringr::str_count("mecab.exe") %>%
        sum()
        skip_if(n_match == 0)
    res <- 
        neko %>%
        dplyr::mutate(text=stringi::stri_unescape_unicode(text)) %>%
        dplyr::mutate(cols=1:nrow(.)) %>%
        moranajp_all(text_col="text", bin_dir=bin_dir, fileEncoding=fileEncoding)
  expect_equal(res$cols, res$text_id)
})
