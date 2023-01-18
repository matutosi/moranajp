#' iconv x
#' 
#' @inheritParams moranajp_all
#' @param x        A string vector or a tibble.
#' @param reverse  A logical.
#' @return         A string vector.
#' 
#' @export
iconv_x <- function(x, iconv = "", reverse = FALSE){
    if(iconv == ""){
        return(x)
    }else{
        encodings <- stringr::str_split(iconv, "_", simplify = TRUE)
        if(reverse){
            x <- iconv(x, from = encodings[2], to = encodings[1])
        }else{
            x <- iconv(x, from = encodings[1], to = encodings[2])
        }
        return(x)
    }
}

#' Generate "stringi::stri_unescape_unicode" code
#' 
#' @param x        A string or vector of Japanese
#' @return         A string or vector 
#' @examples
#' stringi::stri_unescape_unicode("\u8868\u5c64\u5f62") %>%
#'   print() %>%
#'   escape_jpanese()
#' 
#' @export
escape_japanese <- function(x){
  escaped <- stringi::stri_escape_unicode(x)
  codes <- paste0('stringi::stri_unescape_unicode("', escaped, '")')
  for(code in codes){
    cat(code, "\n")
  }
}
