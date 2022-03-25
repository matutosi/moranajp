test_that("add_text_id works", {
  times <- 2:4
  tbl <- 
    tibble::tibble(col=c(rep("a", times[1]), "EOS", rep("b", times[2]), "EOS", rep("c", times[3]), "EOS"), col_na=NA)
  res <- c(rep(1, times[1]), rep(2, times[2]), rep(3, times[3]))
  expect_equal(add_text_id(tbl)$text_id, res)
})

