# Analyzed data of neko by MeCab

MeCab: https://taku910.github.io/mecab/

## Usage

``` r
neko_mecab
```

## Format

A data frame with 2884 rows and 11 variable: (column names are escaped
by stringi::stri_escape_unicode(), stringi::stri_unescape_unicode() or
unescape_utf() will show Japanese)

- text_id:

  id

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
data(neko_mecab)
neko_mecab |>
  unescape_utf()
#> # A tibble: 2,884 × 11
#>    text_id 表層形 品詞   品詞細分類1 品詞細分類2 品詞細分類3 活用型 活用形 原形 
#>      <dbl> <chr>  <chr>  <chr>       <chr>       <chr>       <chr>  <chr>  <chr>
#>  1       1 吾輩   名詞   代名詞      一般        *           *      *      吾輩 
#>  2       1 は     助詞   係助詞      *           *           *      *      は   
#>  3       1 猫     名詞   一般        *           *           *      *      猫   
#>  4       1 で     助動詞 *           *           *           特殊・ダ…… 連用形 だ   
#>  5       1 ある   助動詞 *           *           *           五段・ラ行… 基本形 ある 
#>  6       1 。     記号   句点        *           *           *      *      。   
#>  7       1 名前   名詞   一般        *           *           *      *      名前 
#>  8       1 は     助詞   係助詞      *           *           *      *      は   
#>  9       1 まだ   副詞   助詞類接続  *           *           *      *      まだ 
#> 10       1 無い   形容詞 自立        *           *           形容詞・ア… 基本形 無い 
#> # ℹ 2,874 more rows
#> # ℹ 2 more variables: 読み <chr>, 発音 <chr>
```
