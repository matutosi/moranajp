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
  s1 <- letters[1:4]
  s2 <- letters[3:6]
  term <- c(s1, s2)
  df <- tibble::tibble(
          sentence_id = rep(1:2, c(length(s1), length(s2))), 
          word_id = c(seq_along(s1), seq_along(s2)), 
          term = term,
          x = seq_along(term))
  df_expect <- tibble::tibble(
          sentence_id = rep(1:2, c(length(s1), length(s2))), 
          word_id = c(seq_along(s1), seq_along(s2)), 
          term = term,
          x = c(1:4, 3:6))

  expect_equal(aling_sentence(df), df_expect)
})





