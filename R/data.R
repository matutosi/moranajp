#' The first part of 'I Am a Cat' by Soseki Natsume
#'
#' @format A data frame with 9 rows and 1 variable: 
#' \describe{
#'   \item{text}{Body text. Escaped by stringi::stri_escape_unicode().}
#' }
"neko"

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
"review"

