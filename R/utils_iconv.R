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
