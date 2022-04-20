#' Make groups by splitting string length
#'
#' @inherit morana_jp
make_groups <- function(tbl, text_col = "text", length = 8000) {


  #    make_groups_sub: no visible binding for global variable 'text'
  #    max_str_length: no visible binding for global variable 'gr'
  #    max_str_length: no visible binding for global variable 'str_length'

library(tidyverse)
set.seed(12)
len <- round(stats::runif(200, min=10, max=100), 0)
text <- 
  len %>%
  purrr::map(~rep("a", .)) %>%
  purrr::map(~stringr::str_c(., collapse = "")) %>%
  unlist()
tbl <- tibble::tibble(text=text)
length <- 800

  len_sum <- sum(stringr::str_length(tbl$text))
  ratio <- seq(from = 0.8, to = 0.3, by = -0.1)

  for(i in seq_along(ratio)){
    len_tmp <- round(length * ratio[i], 0)
    n_group <- ceiling(len_sum / len_tmp)
    res <- make_groups_sub(tbl, n_group)

    len_max <- max(res$str_length)
    if(len_max > length){
      stop(paste0("Max length of text is over the length: ", length, " < ", len_max))
    }

    len_sum_max <- max_sum_str_length(res)
  #     if(len_sum_max < length) return(dplyr::select(res, ! dplyr::all_of("str_length")))
    if(len_sum_max < length) break()
  }
  dplyr::select(res, ! dplyr::all_of("str_length"))


}

#' @rdname make_groups
#' @param n_group A numeric.
make_groups_sub <- function(tbl, n_group) {
  nr <- nrow(tbl)
  res <- 
    tbl %>%
    dplyr::mutate(
      gr = dplyr::ntile(1:nr, n_group), 
      str_length = stringr::str_length(text))
}

#' @rdname make_groups
max_sum_str_length <- function(tbl) {
  tbl %>%
    dplyr::group_by(gr) %>%
    dplyr::summarise(sum = sum(str_length)) %>%
    dplyr::summarise(max(sum))
}
