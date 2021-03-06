#' The first part of 'I Am a Cat' by Soseki Natsume
#'
#' @format A data frame with 9 rows and 1 variable: 
#' \describe{
#'   \item{text}{Body text. Escaped by stringi::stri_escape_unicode().}
#' }
#' @examples
#' data(neko)
#' neko %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode)
"neko"

#' Analyzed data of neko by chamame
#'
#' chamame: https://chamame.ninjal.ac.jp/index.html
#'
#' @format A data frame with  2965 rows and 14 variable: 
#' (column names are escaped by stringi::stri_escape_unicode(), 
#' stringi::stri_unescape_unicode() will show Japanese)
#' \describe{
#'   \item{\\u8f9e\\u66f8}{result of chamame}
#'   \item{\\u6587\\u5883\\u754c}{result of chamame}
#'   \item{\\u66f8\\u5b57\\u5f62\\uff08\\uff1d\\u8868\\u5c64\\u5f62\\uff09}{result of chamame}
#'   \item{\\u8a9e\\u5f59\\u7d20}{result of chamame}
#'   \item{\\u8a9e\\u5f59\\u7d20\\u8aad\\u307f}{result of chamame}
#'   \item{\\u54c1\\u8a5e}{result of chamame}
#'   \item{\\u6d3b\\u7528\\u578b}{result of chamame}
#'   \item{\\u6d3b\\u7528\\u5f62}{result of chamame}
#'   \item{\\u767a\\u97f3\\u5f62\\u51fa\\u73fe\\u5f62}{result of chamame}
#'   \item{\\u4eee\\u540d\\u5f62\\u51fa\\u73fe\\u5f62}{result of chamame}
#'   \item{\\u8a9e\\u7a2e}{result of chamame}
#'   \item{\\u66f8\\u5b57\\u5f62(\\u57fa\\u672c\\u5f62)}{result of chamame}
#'   \item{\\u8a9e\\u5f62(\\u57fa\\u672c\\u5f62)}{result of chamame}
#'   \item{...14}{result of chamame}
#' }
#' @examples
#' data(neko_chamame)
#' neko_chamame %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.)))
"neko_chamame"

#' Analyzed data of neko by MeCab
#'
#' MeCab: https://taku910.github.io/mecab/
#'
#' @format A data frame with  2893 rows and 11 variable: 
#' (column names are escaped by stringi::stri_escape_unicode(), 
#' stringi::stri_unescape_unicode() will show Japanese)
#' \describe{
#'   \item{text_id}{result of Mecab}
#'   \item{\\u8868\\u5c64\\u5f62}{result of Mecab}
#'   \item{\\u54c1\\u8a5e}{result of Mecab}
#'   \item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1}{result of Mecab}
#'   \item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2}{result of Mecab}
#'   \item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3}{result of Mecab}
#'   \item{\\u6d3b\\u7528\\u578b}{result of Mecab}
#'   \item{\\u6d3b\\u7528\\u5f62}{result of Mecab}
#'   \item{\\u539f\\u5f62}{result of Mecab}
#'   \item{\\u8aad\\u307f}{result of Mecab}
#'   \item{\\u767a\\u97f3}{result of Mecab}
#' }
#' @examples
#' data(neko_mecab)
#' neko_mecab %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.)))
"neko_mecab"

#' Full text of review article
#'
#' @format A data frame with 457 rows and 2 variables: 
#' \describe{
#'   \item{text}{
#'     Body text. Escaped by stringi::stri_escape_unicode().
#'     Citation is as below. 
#'     Matsumura et al. 2014. 
#'       Conditions and conservation for biodiversity of the semi-natural 
#'       grassland vegetation on rice paddy levees.
#'       Vegetation Science, 31, 193-218.
#'       doi = 10.15031/vegsci.31.193
#'     https://www.jstage.jst.go.jp/article/vegsci/31/2/31_193/_article/-char/en
#'   }
#'   \item{chap}{
#'     Dammy number of chapter.
#'   }
#' }
#' data(neko)
#' review %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode)
"review"

#' Analyzed data of review by chamame
#'
#' chamame: https://chamame.ninjal.ac.jp/index.html
#'
#' @format A data frame with  21013 rows and 14 variable 
#' (column names are escaped by stringi::stri_escape_unicode(), 
#' stringi::stri_unescape_unicode() will show Japanese)
#' \describe{
#'   \item{\\u8f9e\\u66f8}{result of chamame}
#'   \item{\\u6587\\u5883\\u754c}{result of chamame}
#'   \item{\\u66f8\\u5b57\\u5f62\\uff08\\uff1d\\u8868\\u5c64\\u5f62\\uff09}{result of chamame}
#'   \item{\\u8a9e\\u5f59\\u7d20}{result of chamame}
#'   \item{\\u8a9e\\u5f59\\u7d20\\u8aad\\u307f}{result of chamame}
#'   \item{\\u54c1\\u8a5e}{result of chamame}
#'   \item{\\u6d3b\\u7528\\u578b}{result of chamame}
#'   \item{\\u6d3b\\u7528\\u5f62}{result of chamame}
#'   \item{\\u767a\\u97f3\\u5f62\\u51fa\\u73fe\\u5f62}{result of chamame}
#'   \item{\\u4eee\\u540d\\u5f62\\u51fa\\u73fe\\u5f62}{result of chamame}
#'   \item{\\u8a9e\\u7a2e}{result of chamame}
#'   \item{\\u66f8\\u5b57\\u5f62(\\u57fa\\u672c\\u5f62)}{result of chamame}
#'   \item{\\u8a9e\\u5f62(\\u57fa\\u672c\\u5f62)}{result of chamame}
#'   \item{...14}{result of chamame}
#' }
#' @examples
#' data(review_chamame)
#' review_chamame %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.)))
"review_chamame"

#' Analyzed data of neko by MeCab
#'
#' MeCab: https://taku910.github.io/mecab/
#'
#' @format A data frame with  20523 rows and 11 variable: 
#' (column names are escaped by stringi::stri_escape_unicode(), 
#' stringi::stri_unescape_unicode() will show Japanese)
#' \describe{
#'   \item{text_id}{result of Mecab}
#'   \item{\\u8868\\u5c64\\u5f62}{result of Mecab}
#'   \item{\\u54c1\\u8a5e}{result of Mecab}
#'   \item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1}{result of Mecab}
#'   \item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2}{result of Mecab}
#'   \item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3}{result of Mecab}
#'   \item{\\u6d3b\\u7528\\u578b}{result of Mecab}
#'   \item{\\u6d3b\\u7528\\u5f62}{result of Mecab}
#'   \item{\\u539f\\u5f62}{result of Mecab}
#'   \item{\\u8aad\\u307f}{result of Mecab}
#'   \item{\\u767a\\u97f3}{result of Mecab}
#' }
#' @examples
#' data(review_mecab)
#' review_mecab %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.)))
"review_mecab"

#' Stop words for morphological analysis
#'
#' @format A data frame with 310 rows and 1 variable: 
#' \describe{
#'   \item{stop_word}{
#'     Stop words can be used with delete_stop_words(). 
#'     Escaped by stringi::stri_escape_unicode().
#'     Downloaded from 
#'     http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt
#'   }
#' }
#' @examples
#' data(stop_words)
#' stop_words %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode)
"stop_words"

#' An example of synonym word pairs
#'
#' @format A data frame with 25 rows and 2 variables: 
#' \describe{
#'   \item{from}{
#'     Words to be replaced from.
#'     Escaped by stringi::stri_escape_unicode().
#'   }
#'   \item{to}{
#'     Words to be replaced to.
#'   }
#' }
#' @examples
#' data(synonym)
#' synonym %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode)
"synonym"
