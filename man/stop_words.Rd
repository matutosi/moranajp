% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{stop_words}
\alias{stop_words}
\title{Stop words for morphological analysis}
\format{
A data frame with 310 rows and 1 variable:
\describe{
\item{stop_word}{
Stop words can be used with delete_stop_words().
Escaped by stringi::stri_escape_unicode().
Downloaded from
http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt
}
}
}
\usage{
stop_words
}
\description{
Stop words for morphological analysis
}
\examples{
data(stop_words)
stop_words |>
  unescape_utf()
}
\keyword{datasets}
