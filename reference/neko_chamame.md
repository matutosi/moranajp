# Analyzed data of neko by chamame

chamame: https://chamame.ninjal.ac.jp/index.html

## Usage

``` r
neko_chamame
```

## Format

A data frame with 2959 rows and 7 variable: (column names are escaped by
stringi::stri_escape_unicode(), stringi::stri_unescape_unicode() or
unescape_utf() will show Japanese)

- text_id:

  id

- \u8868\u5c64\u5f62:

  result of chamame

- \u54c1\u8a5e:

  result of chamame

- \u54c1\u8a5e\u7d30\u5206\u985e1:

  result of chamame

- \u54c1\u8a5e\u7d30\u5206\u985e2:

  result of chamame

- \u54c1\u8a5e\u7d30\u5206\u985e3:

  result of chamame

- \u539f\u5f62:

  result of chamame

## Examples

``` r
data(neko_chamame)
neko_chamame |>
  unescape_utf()
#> # A tibble: 2,959 × 7
#>    text_id 表層形 品詞     品詞細分類1  品詞細分類2 品詞細分類3 原形 
#>      <dbl> <chr>  <chr>    <chr>        <chr>       <chr>       <chr>
#>  1       1 吾輩   代名詞   ""           ""          ""          吾輩 
#>  2       1 は     助詞     "係助詞"     ""          ""          は   
#>  3       1 猫     名詞     "普通名詞"   "一般"      ""          猫   
#>  4       1 で     助動詞   ""           ""          ""          だ   
#>  5       1 ある   動詞     "非自立可能" ""          ""          ある 
#>  6       1 。     補助記号 "句点"       ""          ""          。   
#>  7       1 名前   名詞     "普通名詞"   "一般"      ""          名前 
#>  8       1 は     助詞     "係助詞"     ""          ""          は   
#>  9       1 まだ   副詞     ""           ""          ""          まだ 
#> 10       1 無い   形容詞   "非自立可能" ""          ""          無い 
#> # ℹ 2,949 more rows
```
