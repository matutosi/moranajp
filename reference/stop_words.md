# Stop words for morphological analysis

Stop words for morphological analysis

## Usage

``` r
stop_words
```

## Format

A data frame with 310 rows and 1 variable:

- stop_word:

  Stop words can be used with delete_stop_words(). Escaped by
  stringi::stri_escape_unicode(). Downloaded from
  http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt

## Examples

``` r
data(stop_words)
stop_words |>
  unescape_utf()
#> # A tibble: 310 × 1
#>    stop_word
#>    <chr>    
#>  1 あそこ   
#>  2 あたり   
#>  3 あちら   
#>  4 あっち   
#>  5 あと     
#>  6 あな     
#>  7 あなた   
#>  8 あれ     
#>  9 いくつ   
#> 10 いつ     
#> # ℹ 300 more rows
```
