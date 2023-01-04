#' Find relateve position of a common word in a sentence
#' 
#' Helper function for mark()
#' @param   x,y  A string vector
#' @return  numeric from 1 to 0. 
#'          1   : common word in y with x locate in a head of y. 
#'          > 0 : (len - i + 1) / len;
#'                  where len is the length of y, 
#'                  i is the position of common word.
#'          0   : no common word.
#' @examples
#' 
#' 
#' 
#' 
#' 
#' @export
position_sentence <- function(x, y){
  len <- length(y)
  for(i in seq(len)){
    no_word <- sum(str_detect(x, y[i]))
    if( no_word ){ return( (len - i + 1) / len ) }
  }
  return(0)
}

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
