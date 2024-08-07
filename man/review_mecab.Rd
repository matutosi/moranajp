% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{review_mecab}
\alias{review_mecab}
\title{Analyzed data of review by MeCab}
\format{
A data frame with  199985 rows and 14 variable:
(column names are escaped by stringi::stri_escape_unicode(),
stringi::stri_unescape_unicode() or unescape_utf() will show Japanese)
\describe{
\item{text_id}{id}
\item{chap}{chapter}
\item{sect}{section}
\item{para}{paragraph}
\item{\\u8868\\u5c64\\u5f62}{result of MeCab}
\item{\\u54c1\\u8a5e}{result of MeCab}
\item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1}{result of MeCab}
\item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2}{result of MeCab}
\item{\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3}{result of MeCab}
\item{\\u6d3b\\u7528\\u578b}{result of MeCab}
\item{\\u6d3b\\u7528\\u5f62}{result of MeCab}
\item{\\u539f\\u5f62}{result of MeCab}
\item{\\u8aad\\u307f}{result of MeCab}
\item{\\u767a\\u97f3}{result of MeCab}
}
}
\usage{
review_mecab
}
\description{
MeCab: https://taku910.github.io/mecab/
}
\examples{
data(review_mecab)
review_mecab |>
  unescape_utf()
}
\keyword{datasets}
