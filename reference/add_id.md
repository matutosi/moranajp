# Add id in each group

Add id in each group

## Usage

``` r
add_id(tbl, grp = "group", id = "id")
```

## Arguments

- tbl:

  A dataframe

- grp, id:

  A string to specify the column of group and id

## Value

A dataframe

## Examples

``` r
brk <- "EOS"
tbl <- tibble::tibble(col=c(rep("a", 2), brk, rep("b", 3), brk, rep("c", 4), brk))
add_group(tbl, col = "col") |>
  add_id(id = "id_in_group")
#> # A tibble: 12 × 3
#>    col   group id_in_group
#>    <chr> <dbl>       <int>
#>  1 a         1           1
#>  2 a         1           2
#>  3 EOS       1           3
#>  4 b         2           1
#>  5 b         2           2
#>  6 b         2           3
#>  7 EOS       2           4
#>  8 c         3           1
#>  9 c         3           2
#> 10 c         3           3
#> 11 c         3           4
#> 12 EOS       3           5
```
