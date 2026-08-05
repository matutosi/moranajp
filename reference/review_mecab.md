# Analyzed data of review by MeCab

MeCab: https://taku910.github.io/mecab/

## Usage

``` r
review_mecab
```

## Format

A data frame with 199985 rows and 14 variable: (column names are escaped
by stringi::stri_escape_unicode(), stringi::stri_unescape_unicode() or
unescape_utf() will show Japanese)

- text_id:

  id

- chap:

  chapter

- sect:

  section

- para:

  paragraph

- \u8868\u5c64\u5f62:

  result of MeCab

- \u54c1\u8a5e:

  result of MeCab

- \u54c1\u8a5e\u7d30\u5206\u985e1:

  result of MeCab

- \u54c1\u8a5e\u7d30\u5206\u985e2:

  result of MeCab

- \u54c1\u8a5e\u7d30\u5206\u985e3:

  result of MeCab

- \u6d3b\u7528\u578b:

  result of MeCab

- \u6d3b\u7528\u5f62:

  result of MeCab

- \u539f\u5f62:

  result of MeCab

- \u8aad\u307f:

  result of MeCab

- \u767a\u97f3:

  result of MeCab

## Examples

``` r
data(review_mecab)
review_mecab |>
  unescape_utf()
#> # A tibble: 19,985 × 14
#>    text_id  chap  sect  para 表層形 品詞   品詞細分類1 品詞細分類2 品詞細分類3
#>      <dbl> <dbl> <dbl> <dbl> <chr>  <chr>  <chr>       <chr>       <chr>      
#>  1       1     1     1     1 農地   名詞   一般        *           *          
#>  2       1     1     1     1 は     助詞   係助詞      *           *          
#>  3       1     1     1     1 農産物 名詞   一般        *           *          
#>  4       1     1     1     1 を     助詞   格助詞      一般        *          
#>  5       1     1     1     1 生産   名詞   サ変接続    *           *          
#>  6       1     1     1     1 する   動詞   自立        *           *          
#>  7       1     1     1     1 機能   名詞   サ変接続    *           *          
#>  8       1     1     1     1 だけ   助詞   副助詞      *           *          
#>  9       1     1     1     1 で     助動詞 *           *           *          
#> 10       1     1     1     1 なく   助動詞 *           *           *          
#> # ℹ 19,975 more rows
#> # ℹ 5 more variables: 活用型 <chr>, 活用形 <chr>, 原形 <chr>, 読み <chr>,
#> #   発音 <chr>
```
