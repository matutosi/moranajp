# Analyzed data of neko by Sudachi

Sudachi: https://github.com/WorksApplications/Sudachi

## Usage

``` r
neko_sudachi_a

neko_sudachi_b

neko_sudachi_c
```

## Format

A data frame with 3130 rows and 9 variable:

- text_id:

  id

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

A data frame with 3088 rows and 9 variable:

A data frame with 3080 rows and 9 variable:

## Examples

``` r
data(neko_sudachi_a)
neko_sudachi_a |>
  unescape_utf()
#> # A tibble: 3,130 × 9
#>    text_id 表層形 品詞     品詞細分類1 品詞細分類2 品詞細分類3 品詞細分類4
#>      <dbl> <chr>  <chr>    <chr>       <chr>       <chr>       <chr>      
#>  1       1 吾輩   代名詞   *           *           *           *          
#>  2       1 は     助詞     係助詞      *           *           *          
#>  3       1 猫     名詞     普通名詞    一般        *           *          
#>  4       1 で     助動詞   *           *           *           助動詞-ダ  
#>  5       1 ある   動詞     非自立可能  *           *           五段-ラ行  
#>  6       1 。     補助記号 句点        *           *           *          
#>  7       1 EOS    NA       NA          NA          NA          NA         
#>  8       1 名前   名詞     普通名詞    一般        *           *          
#>  9       1 は     助詞     係助詞      *           *           *          
#> 10       1 まだ   副詞     *           *           *           *          
#> # ℹ 3,120 more rows
#> # ℹ 2 more variables: 品詞細分類5 <chr>, 原形 <chr>
```
