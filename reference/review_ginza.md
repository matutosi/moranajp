# Analyzed data of review by GiNZA

GiNZA: https://megagonlabs.github.io/ginza/

## Usage

``` r
review_ginza
```

## Format

A data frame with 19514 rows and 16 variable:

- text_id:

  id

- chap:

  chapter

- sect:

  section

- para:

  paragraph

- id:

  result of GiNZA

- \u8868\u5c64\u5f62:

  result of GiNZA

- \u539f\u5f62:

  result of GiNZA

- UD\u54c1\u8a5e\u30bf\u30b0:

  result of GiNZA

- \u54c1\u8a5e:

  result of GiNZA

- \u54c1\u8a5e\u7d30\u5206\u985e1:

  result of GiNZA

- \u54c1\u8a5e\u7d30\u5206\u985e2:

  result of GiNZA

- \u5c5e\u6027:

  result of GiNZA

- \u4fc2\u53d7\u5143:

  result of GiNZA

- \u4fc2\u53d7\u30bf\u30b0:

  result of GiNZA

- \u4fc2\u53d7\u30da\u30a2:

  result of GiNZA

- \u305d\u306e\u4ed6:

  result of GiNZA

## Examples

``` r
data(review_ginza)
review_ginza |>
  unescape_utf()
#> # A tibble: 19,514 × 16
#>    text_id  chap  sect  para id    表層形 原形   UD品詞タグ 品詞   品詞細分類1
#>      <dbl> <dbl> <dbl> <dbl> <chr> <chr>  <chr>  <chr>      <chr>  <chr>      
#>  1       1     1     1     1 1     農地   農地   NOUN       名詞   普通名詞   
#>  2       1     1     1     1 2     は     は     ADP        助詞   係助詞     
#>  3       1     1     1     1 3     農産物 農産物 NOUN       名詞   普通名詞   
#>  4       1     1     1     1 4     を     を     ADP        助詞   格助詞     
#>  5       1     1     1     1 5     生産   生産   VERB       名詞   普通名詞   
#>  6       1     1     1     1 6     する   する   AUX        動詞   非自立可能 
#>  7       1     1     1     1 7     機能   機能   NOUN       名詞   普通名詞   
#>  8       1     1     1     1 8     だけ   だけ   ADP        助詞   副助詞     
#>  9       1     1     1     1 9     で     だ     AUX        助動詞 NA         
#> 10       1     1     1     1 10    なく   ない   AUX        形容詞 非自立可能 
#> # ℹ 19,504 more rows
#> # ℹ 6 more variables: 品詞細分類2 <chr>, 属性 <chr>, 係受元 <chr>,
#> #   係受タグ <chr>, 係受ペア <chr>, その他 <chr>
```
