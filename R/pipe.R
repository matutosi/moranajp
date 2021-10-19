#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

dots <- function(...) {
  rlang::eval_bare(substitute(alist(...)))
}
