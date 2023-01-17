testthat::test_that("position_sentence() work", {
  x <- letters[1:10]
  y <- "a"
  expect_equal(position_sentence(x, y), 1)

  x <- letters[1:10]
  y <- "z"
  expect_equal(position_sentence(x, y), 0)

  x <- letters[10:1]
  y <- letters[c(19:10)]
  expect_equal(position_sentence(x, y), 0.1)

})

testthat::test_that("aling_sentence() work", {
s_id = "sentence_id"; term = "term"; x_pos = "x"
  s1 <- letters[1:4]
  s2 <- letters[3:6]
  s3 <- letters[3:6]
  s4 <- letters[7:10]
  term <- list(s1, s2, s3, s4)
  df <- tibble::tibble(
          sentence_id = rep(seq_along(term), purrr::map_int(term, length)),
          term = unlist(term),
          x = seq_along(term))
  df_expect <- df %>%
    dplyr::mutate(x = c(1:4, 3:6, 3:6, 7:10))

  expect_equal(align_sentence(df), df_expect)
})

