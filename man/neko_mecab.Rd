% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{neko_mecab}
\alias{neko_mecab}
\title{Analyzed data of neko by MeCab}
\format{
A data frame with  2893 rows and 11 variable:
(column names are escaped by stringi::stri_escape_unicode(),
stringi::stri_unescape_unicode() will show Japanese)
\describe{
\item{text_id}{result of Mecab}
\item{\\u8868\\u5c64\\u5f62}{result of Mecab}
\item{\\u54c1\\u8a5e}{result of Mecab}
\item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1}{result of Mecab}
\item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2}{result of Mecab}
\item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3}{result of Mecab}
\item{\\u6d3b\\u7528\\u578b}{result of Mecab}
\item{\\u6d3b\\u7528\\u5f62}{result of Mecab}
\item{\\u539f\\u5f62}{result of Mecab}
\item{\\u8aad\\u307f}{result of Mecab}
\item{\\u767a\\u97f3}{result of Mecab}
}
}
\usage{
neko_mecab
}
\description{
MeCab: https://taku910.github.io/mecab/
}
\examples{
data(neko_mecab)
neko_mecab \%>\%
  dplyr::mutate_all(stringi::stri_unescape_unicode) \%>\%
  magrittr::set_colnames(stringi::stri_unescape_unicode(colnames(.)))
}
\keyword{datasets}
