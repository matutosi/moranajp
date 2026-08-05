# Analyzed data of neko by GiNZA

GiNZA: https://megagonlabs.github.io/ginza/

## Usage

``` r
neko_ginza
```

## Format

A data frame with 2945 rows and 13 variable:

- text_id:

  id

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
data(neko_ginza)
neko_ginza |>
  unescape_utf()
#> # A tibble: 2,945 × 13
#>    text_id id    表層形 原形  UD品詞タグ 品詞     品詞細分類1 品詞細分類2 属性 
#>      <dbl> <chr> <chr>  <chr> <chr>      <chr>    <chr>       <chr>       <chr>
#>  1       1 1     吾輩   吾輩  NOUN       代名詞   NA          NA          _    
#>  2       1 2     は     は    ADP        助詞     係助詞      NA          _    
#>  3       1 3     猫     猫    NOUN       名詞     普通名詞    一般        _    
#>  4       1 4     で     だ    AUX        助動詞   NA          NA          _    
#>  5       1 5     ある   ある  VERB       動詞     非自立可能  NA          _    
#>  6       1 6     。     。    PUNCT      補助記号 句点        NA          _    
#>  7       1 1     名前   名前  NOUN       名詞     普通名詞    一般        _    
#>  8       1 2     は     は    ADP        助詞     係助詞      NA          _    
#>  9       1 3     まだ   まだ  ADV        副詞     NA          NA          _    
#> 10       1 4     無い   無い  ADJ        形容詞   非自立可能  NA          _    
#> # ℹ 2,935 more rows
#> # ℹ 4 more variables: 係受元 <chr>, 係受タグ <chr>, 係受ペア <chr>,
#> #   その他 <chr>
```
