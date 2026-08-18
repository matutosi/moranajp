test_that("add_text_id() work", {
    times <- 2:4
    tbl <-
      tibble::tibble(col=c(rep("a", times[1]), "EOS", rep("b", times[2]), "EOS", rep("c", times[3]), "EOS"))
    res <- c(rep(1, times[1]), rep(2, times[2] + 1), rep(3, times[3] + 1), 4)       # "+ 1": because of EOS
    expect_equal(add_text_id(tbl, method = "mecab", brk = "EOS")$text_id, res)
})

test_that("text_id of moranajp matches text number", {
    bin_dir <- c("d:/pf/mecab/bin", "/opt/local/mecab/bin")
    bin_dir <- bin_dir[file.exists(bin_dir)]
    if(length(bin_dir) == 1){
      res <-
          neko |>
          dplyr::mutate(text = stringi::stri_unescape_unicode(text)) |>
          dplyr::mutate(cols = dplyr::row_number()) |>
          moranajp_all(text_col = "text", bin_dir = bin_dir, iconv = "CP932_UTF-8")
    }
    skip_if(length(bin_dir) != 1)
        expect_equal(res$cols, res$text_id)
})

test_that("web_chamame() fails gracefully when not available", {
    # Not a web server: connection fails without using an internet resource
    url <- "http://127.0.0.1:1/"
    expect_message(html <- read_html_safely(url))
    expect_null(html)
    expect_message(res <- web_chamame(unescape_utf("\\u3059\\u3082\\u3082"), url = url))
    expect_null(res)
})

test_that("cols_chamame() differs between UniDic and IPAdic", {
    unidic <- cols_chamame("unidic-spoken")
    ipadic <- cols_chamame("ipadic")
    expect_true(is_ipadic("ipadic"))
    expect_false(is_ipadic("gendai"))
    # Both are renamed into out_cols_chamame(), so the length must be the same
    expect_length(unidic, length(out_cols_chamame()))
    expect_length(ipadic, length(out_cols_chamame()))
    # gendai is a UniDic dictionary
    expect_equal(unidic, cols_chamame("gendai"))
    # Only the key (= surface form) is shared between the dictionaries
    expect_equal(unidic[1], ipadic[1])
    expect_false(any(ipadic[-1] %in% unidic[-1]))
})

test_that("extract_chamame_cols() selects the columns of the dictionary", {
    for(dic in c("unidic-spoken", "ipadic")){
      tbl <- as.data.frame(matrix("a", nrow = 1, ncol = length(cols_chamame(dic))))
      colnames(tbl) <- cols_chamame(dic)
      res <- extract_chamame_cols(tbl, dic = dic)
      expect_equal(colnames(res), out_cols_chamame())
      expect_equal(colnames(extract_chamame_cols(tbl, col_lang = "en", dic = dic)),
                   out_cols_chamame(col_lang = "en"))
    }
})

test_that("check_chamame_table() stops when a column is missing", {
    dic <- "ipadic"
    tbl <- as.data.frame(matrix("a", nrow = 1, ncol = length(cols_chamame(dic))))
    colnames(tbl) <- cols_chamame(dic)
    expect_equal(check_chamame_table(tbl, dic = dic), tbl)
    # The columns of IPAdic are not those of UniDic
    expect_error(check_chamame_table(tbl, dic = "unidic-spoken"))
})
