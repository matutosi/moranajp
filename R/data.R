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

#' Analyzed data of neko by chasen
#'
#' chasen: https://chamame.ninjal.ac.jp/index.html
#'
#' @format A data frame with  2965 rows and 14 variable: 
#' \describe{
#'   \item{14 columns}{Result of chasen. See detail in the data.}
#' }
#' @examples
#' data(neko_chasen)
#' neko_chasen %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.)))
"neko_chasen"

#' Analyzed data of neko by MeCab
#'
#' MeCab: https://taku910.github.io/mecab/
#'
#' @format A data frame with  2893 rows and 11 variable: 
#' \describe{
#'   \item{11 columns}{Result of chasen. See detail in the data.}
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

#' Analyzed data of review by chasen
#'
#' chasen: https://chamame.ninjal.ac.jp/index.html
#'
#' @format A data frame with  21013 rows and 14 variable: 
#' \describe{
#'   \item{14 columns}{Result of chasen. See detail in the data.}
#' }
#' @examples
#' data(review_chasen)
#' review_chasen %>%
#'   dplyr::mutate_all(stringi::stri_unescape_unicode) %>%
#'   magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.)))
"review_chasen"

#' Analyzed data of neko by MeCab
#'
#' MeCab: https://taku910.github.io/mecab/
#'
#' @format A data frame with  20523 rows and 11 variable: 
#' \describe{
#'   \item{11 columns}{Result of chasen. See detail in the data.}
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
"synonym"
