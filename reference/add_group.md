# Add group id column into result of morphological analysis

Add group id column into result of morphological analysis

## Usage

``` r
add_group(
  tbl,
  col,
  brk = "EOS",
  grp = "group",
  cond = NULL,
  end_with_brk = TRUE
)
```

## Arguments

- tbl:

  A dataframe

- col:

  A string to specify the column including breaks

- brk:

  A string to specify breaks

- grp:

  A string to specify group

- cond:

  A string to specify condition

- end_with_brk:

  A logical

## Value

A dataframe

## Examples

``` r
brk <- "EOS"
tbl <- tibble::tibble(col_a = c(rep("a", 2), brk, rep("b", 3), brk, rep("c", 4), brk))
add_group(tbl, col = "col_a", grp = "text_id")
#> # A tibble: 12 × 2
#>    col_a text_id
#>    <chr>   <dbl>
#>  1 a           1
#>  2 a           1
#>  3 EOS         1
#>  4 b           2
#>  5 b           2
#>  6 b           2
#>  7 EOS         2
#>  8 c           3
#>  9 c           3
#> 10 c           3
#> 11 c           3
#> 12 EOS         3
add_group(tbl, col = "col_a", end_with_brk = FALSE)
#> # A tibble: 12 × 2
#>    col_a group
#>    <chr> <dbl>
#>  1 a         1
#>  2 a         1
#>  3 EOS       2
#>  4 b         2
#>  5 b         2
#>  6 b         2
#>  7 EOS       3
#>  8 c         3
#>  9 c         3
#> 10 c         3
#> 11 c         3
#> 12 EOS       4
```
