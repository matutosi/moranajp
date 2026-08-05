# iconv x

iconv x

## Usage

``` r
iconv_x(x, iconv = "", reverse = FALSE)
```

## Arguments

- x:

  A string vector or a tibble.

- iconv:

  A text. Convert encoding of MeCab output. Default (""): don't convert.
  "CP932_UTF-8": iconv(output, from = "Shift-JIS" to = "UTF-8")
  "EUC_UTF-8" : iconv(output, from = "eucjp", to = "UTF-8") iconv is
  also used to convert input text before running MeCab. "CP932_UTF-8":
  iconv(input, from = "UTF-8", to = "Shift-JIS")

- reverse:

  A logical.

## Value

        A string vector.
