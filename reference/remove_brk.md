# Remove break point and other unused rows from the result of morphological analysis

Internal function for moranajp_all().

## Usage

``` r
remove_brk(tbl, method, brk = "BP")
```

## Arguments

- tbl:

  A tibble or data.frame.

- method:

  A text. Method to use: "mecab", "ginza", "sudachi_a", "sudachi_b",
  "sudachi_c", or "chamame". "a", "b" and "c" specify the mode of
  splitting. "a" split shortest, "b" middle and "c" longest. See
  https://github.com/WorksApplications/Sudachi for detail. "chamame" use
  https://chamame.ninjal.ac.jp/ and rvest.

- brk:

  A string of break point

## Value

A data.frame.
