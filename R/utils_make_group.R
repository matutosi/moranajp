#' Make groups by splitting string length
#'
#' @param tbl          A tibble or data.frame.
#' @param text_col     A text. Colnames for morphological analysis.
#' @return A tibble.   Output of 'MeCab' and added column "text_id".
#' @examples
#'
#'
#'
#' @export
moranajp_all <- function(tbl, text_col = "text", length=8000) {

set.seed(12)
len <- round(runif(200, min=10, max=100), 0)
text <- 
  len %>%
  purrr::map(~rep("a", .)) %>%
  purrr::map(~stringr::str_c(., collapse = "")) %>%
  unlist()
tbl <- tibble::tibble(text=text)
length <- 800

  nr <- nrow(tbl)
  ratio <- seq(from = 0.8, to = 0.3, by = -0.1)
  len_tmp <- round(length * ratio[1], 0)
  len_sum <- sum(stringr::str_length(tbl$text))
  n_group <- ceiling(len_sum / len_tmp)
  
  res <- 
    tbl %>%
    dplyr::mutate(
      gr = dplyr::ntile(1:nr, n_group), 
      str_length = stringr::str_length(text))

  len_max <- 
    res %>%
    dplyr::group_by(gr) %>%
    dplyr::summarise(sum = sum(str_length)) %>%
    dplyr::summarise(max(sum))
  if(len_max < length){
    return(select(res, -str_length))
  } else {
    
  }

}
