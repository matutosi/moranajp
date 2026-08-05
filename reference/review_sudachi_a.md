# Analyzed data of review by Sudachi

Sudachi: https://github.com/WorksApplications/Sudachi

## Usage

``` r
review_sudachi_a

review_sudachi_b

review_sudachi_c
```

## Format

A data frame with 20100 rows and 12 variable:

- text_id:

  id

- chap:

  chapter

- sect:

  section

- para:

  paragraph

- \u8868\u5c64\u5f62:

  result of Sudachi

- \u54c1\u8a5e:

  result of Sudachi

- \u54c1\u8a5e\u7d30\u5206\u985e1:

  result of Sudachi

- \u54c1\u8a5e\u7d30\u5206\u985e2:

  result of Sudachi

- \u54c1\u8a5e\u7d30\u5206\u985e3:

  result of Sudachi

- \u54c1\u8a5e\u7d30\u5206\u985e4:

  result of Sudachi

- \u54c1\u8a5e\u7d30\u5206\u985e5:

  result of Sudachi

- \u539f\u5f62:

  result of Sudachi

A data frame with 19565 rows and 12 variable:

A data frame with 19526 rows and 12 variable:

## Examples

``` r
data(review_sudachi_a)
review_sudachi_a |>
  unescape_utf()
#> # A tibble: 20,100 × 12
#>    text_id  chap  sect  para 表層形 品詞   品詞細分類1 品詞細分類2 品詞細分類3
#>      <dbl> <dbl> <dbl> <dbl> <chr>  <chr>  <chr>       <chr>       <chr>      
#>  1       1     1     1     1 農地   名詞   普通名詞    一般        *          
#>  2       1     1     1     1 は     助詞   係助詞      *           *          
#>  3       1     1     1     1 農産   名詞   普通名詞    一般        *          
#>  4       1     1     1     1 物     接尾辞 名詞的      一般        *          
#>  5       1     1     1     1 を     助詞   格助詞      *           *          
#>  6       1     1     1     1 生産   名詞   普通名詞    サ変可能    *          
#>  7       1     1     1     1 する   動詞   非自立可能  *           *          
#>  8       1     1     1     1 機能   名詞   普通名詞    サ変可能    *          
#>  9       1     1     1     1 だけ   助詞   副助詞      *           *          
#> 10       1     1     1     1 で     助動詞 *           *           *          
#> # ℹ 20,090 more rows
#> # ℹ 3 more variables: 品詞細分類4 <chr>, 品詞細分類5 <chr>, 原形 <chr>
```
