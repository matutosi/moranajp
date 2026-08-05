# Generate code like "stringi::stri_unescape_unicode(...)"

Generate code like "stringi::stri_unescape_unicode(...)"

## Usage

``` r
escape_japanese(x)
```

## Arguments

- x:

  A string or vector of Japanese

## Value

        A string or vector

## Examples

``` r
stringi::stri_unescape_unicode("\\u8868\\u5c64\\u5f62") |>
  print() |>
  escape_japanese()
#> [1] "表層形"
#> stringi::stri_unescape_unicode("\u8868\u5c64\u5f62")
```
