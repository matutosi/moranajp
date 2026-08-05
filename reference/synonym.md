# An example of synonym word pairs

An example of synonym word pairs

## Usage

``` r
synonym
```

## Format

A data frame with 25 rows and 2 variables:

- from:

  Words to be replaced from. Escaped by stringi::stri_escape_unicode().

- to:

  Words to be replaced to.

## Examples

``` r
data(synonym)
synonym |>
  unescape_utf()
#> # A tibble: 25 × 2
#>    from     to    
#>    <chr>    <chr> 
#>  1 出来る   できる
#>  2 わかる   分かる
#>  3 みる     見る  
#>  4 よい     良い  
#>  5 いい     良い  
#>  6 無い     ない  
#>  7 有る     ある  
#>  8 もつ     持つ  
#>  9 変える   変わる
#> 10 締め切り 締切  
#> # ℹ 15 more rows
```
