# Wrapper functions for escape and unescape unicode

Wrapper functions for escape and unescape unicode

## Usage

``` r
unescape_utf(x)

escape_utf(x)
```

## Arguments

- x:

  A dataframe or character vector

## Value

    A dataframe or character vector

## Examples

``` r
data(review_mecab)
review_mecab |>
  print() |>
  unescape_utf() |>
  print() |>
  escape_utf()
#> # A tibble: 19,985 × 14
#>    text_id  chap  sect  para `\\u8868\\u5c64\\u5f62` `\\u54c1\\u8a5e`       
#>      <dbl> <dbl> <dbl> <dbl> <chr>                   <chr>                  
#>  1       1     1     1     1 "\\u8fb2\\u5730"        "\\u540d\\u8a5e"       
#>  2       1     1     1     1 "\\u306f"               "\\u52a9\\u8a5e"       
#>  3       1     1     1     1 "\\u8fb2\\u7523\\u7269" "\\u540d\\u8a5e"       
#>  4       1     1     1     1 "\\u3092"               "\\u52a9\\u8a5e"       
#>  5       1     1     1     1 "\\u751f\\u7523"        "\\u540d\\u8a5e"       
#>  6       1     1     1     1 "\\u3059\\u308b"        "\\u52d5\\u8a5e"       
#>  7       1     1     1     1 "\\u6a5f\\u80fd"        "\\u540d\\u8a5e"       
#>  8       1     1     1     1 "\\u3060\\u3051"        "\\u52a9\\u8a5e"       
#>  9       1     1     1     1 "\\u3067"               "\\u52a9\\u52d5\\u8a5e"
#> 10       1     1     1     1 "\\u306a\\u304f"        "\\u52a9\\u52d5\\u8a5e"
#> # ℹ 19,975 more rows
#> # ℹ 8 more variables: `\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1` <chr>,
#> #   `\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2` <chr>,
#> #   `\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3` <chr>,
#> #   `\\u6d3b\\u7528\\u578b` <chr>, `\\u6d3b\\u7528\\u5f62` <chr>,
#> #   `\\u539f\\u5f62` <chr>, `\\u8aad\\u307f` <chr>, `\\u767a\\u97f3` <chr>
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
#> # A tibble: 19,985 × 14
#>    text_id  chap  sect  para `\\u8868\\u5c64\\u5f62` `\\u54c1\\u8a5e`       
#>      <dbl> <dbl> <dbl> <dbl> <chr>                   <chr>                  
#>  1       1     1     1     1 "\\u8fb2\\u5730"        "\\u540d\\u8a5e"       
#>  2       1     1     1     1 "\\u306f"               "\\u52a9\\u8a5e"       
#>  3       1     1     1     1 "\\u8fb2\\u7523\\u7269" "\\u540d\\u8a5e"       
#>  4       1     1     1     1 "\\u3092"               "\\u52a9\\u8a5e"       
#>  5       1     1     1     1 "\\u751f\\u7523"        "\\u540d\\u8a5e"       
#>  6       1     1     1     1 "\\u3059\\u308b"        "\\u52d5\\u8a5e"       
#>  7       1     1     1     1 "\\u6a5f\\u80fd"        "\\u540d\\u8a5e"       
#>  8       1     1     1     1 "\\u3060\\u3051"        "\\u52a9\\u8a5e"       
#>  9       1     1     1     1 "\\u3067"               "\\u52a9\\u52d5\\u8a5e"
#> 10       1     1     1     1 "\\u306a\\u304f"        "\\u52a9\\u52d5\\u8a5e"
#> # ℹ 19,975 more rows
#> # ℹ 8 more variables: `\\u54c1\\u8a5e\\u7d30\\u5206\\u985e1` <chr>,
#> #   `\\u54c1\\u8a5e\\u7d30\\u5206\\u985e2` <chr>,
#> #   `\\u54c1\\u8a5e\\u7d30\\u5206\\u985e3` <chr>,
#> #   `\\u6d3b\\u7528\\u578b` <chr>, `\\u6d3b\\u7528\\u5f62` <chr>,
#> #   `\\u539f\\u5f62` <chr>, `\\u8aad\\u307f` <chr>, `\\u767a\\u97f3` <chr>
```
