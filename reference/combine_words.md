# Combine words after morphological analysis

Combine words after morphological analysis

## Usage

``` r
combine_words(df, combi, sep = "-")

combi_words(x, combi, sep = "-")
```

## Arguments

- df:

  A dataframe including result of morphological analysis.

- combi:

  A string (combi_words()) or string vector (combine_words()) to combine
  words.

- sep:

  A string of separator of words

- x:

  A pair of string joining with "-"

## Value

A data.frame with combined words.

## Examples

``` r
x <- letters[1:10]
combi <- c("b-c")
combi_words(x, combi)
#>  [1] "a"  "bc" NA   "d"  "e"  "f"  "g"  "h"  "i"  "j" 
expected <- c("a", "bc", NA, "d", "e", "f", "g", "h", "i", "j")
testthat::expect_equal(combi_words(x, combi), expected)

df <- unescape_utf(review_chamame) |> head(20)
combi <- unescape_utf(
           c("\\u751f\\u7269-\\u591a\\u69d8", "\\u8fb2\\u5730-\\u306f"       ,
             "\\u8fb2\\u7523-\\u7269"       , "\\u751f\\u7523-\\u3059\\u308b"))
combine_words(df, combi)
#> # A tibble: 16 × 10
#>    text_id  chap  sect  para 表層形 品詞     品詞細分類1 品詞細分類2 品詞細分類3
#>      <dbl> <dbl> <dbl> <dbl> <chr>  <chr>    <chr>       <chr>       <chr>      
#>  1       1     1     1     1 農地   名詞     "普通名詞"  "一般"      ""         
#>  2       1     1     1     1 農産   名詞     "普通名詞"  "一般"      ""         
#>  3       1     1     1     1 を     助詞     "格助詞"    ""          ""         
#>  4       1     1     1     1 生産   名詞     "普通名詞"  "サ変可能"  ""         
#>  5       1     1     1     1 機能   名詞     "普通名詞"  "サ変可能"  ""         
#>  6       1     1     1     1 だけ   助詞     "副助詞"    ""          ""         
#>  7       1     1     1     1 で     助動詞   ""          ""          ""         
#>  8       1     1     1     1 なく   形容詞   "非自立可能"…… ""          ""         
#>  9       1     1     1     1 ，     補助記号 "読点"      ""          ""         
#> 10       1     1     1     1 生物   名詞     "普通名詞"  "一般"      ""         
#> 11       1     1     1     1 性     接尾辞   "名詞的"    "一般"      ""         
#> 12       1     1     1     1 を     助詞     "格助詞"    ""          ""         
#> 13       1     1     1     1 維持   名詞     "普通名詞"  "サ変可能"  ""         
#> 14       1     1     1     1 する   動詞     "非自立可能"…… ""          ""         
#> 15       1     1     1     1 機能   名詞     "普通名詞"  "サ変可能"  ""         
#> 16       1     1     1     1 も     助詞     "係助詞"    ""          ""         
#> # ℹ 1 more variable: 原形 <chr>
```
