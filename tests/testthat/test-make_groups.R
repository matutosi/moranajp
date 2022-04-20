test_that("can make groups correctly", {
  set.seed(12)
  len <- round(stats::runif(200, min=10, max=100), 0)
  text <- 
    len %>%
    purrr::map(~rep("a", .)) %>%
    purrr::map(~stringr::str_c(., collapse = "")) %>%
    unlist()
  tbl <- tibble::tibble(text=text)
  length <- 800

    expect_equal(, res)
})
