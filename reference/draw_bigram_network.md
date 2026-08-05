# Draw bigram network using morphological analysis data.

Draw bigram network using morphological analysis data.

## Usage

``` r
draw_bigram_network(df, draw = TRUE, ...)

bigram(df, group = "sentence", depend = FALSE, term_depend = NULL, ...)

trigram(df, group = "sentence")

bigram_depend(df, group = "sentence")

bigram_network(bigram, rand_seed = 12, threshold = 100, ...)

word_freq(df, big_net, ...)

bigram_network_plot(
  big_net,
  freq,
  ...,
  arrow_size = 5,
  circle_size = 5,
  text_size = 5,
  font_family = "",
  arrow_col = "darkgreen",
  circle_col = "skyblue",
  x_limits = NULL,
  y_limits = NULL,
  no_scale = FALSE
)
```

## Arguments

- df:

  A dataframe including result of morphological analysis.

- draw:

  A logical.

- ...:

  Extra arguments to internal functions.

- group:

  A string to specify sentence.

- depend:

  A logical.

- term_depend:

  A string of dependent terms column to use bigram.

- bigram:

  A result of bigram().

- rand_seed:

  A numeric.

- threshold:

  A numeric used as threshold for frequency of bigram.

- big_net:

  A result of bigram_network().

- freq:

  A numeric of word frequency in bigram_network. Can be got using
  word_freq().

- arrow_size, circle_size, text_size, :

  A numeric.

- font_family:

  A string.

- arrow_col, circle_col:

  A string to specify arrow and circle color in bigram network.

- x_limits, y_limits:

  A Pair of numeric to specify range.

- no_scale:

  A logical. FALSE: Not draw x and y axis.

## Value

A list including df (input), bigram, freq (frequency) and gg (ggplot2
object of bigram network plot).

## Examples

``` r

sentences <- 50
len <- 30
n <- sentences * len
x <- letters
prob <- (length(x):1) ^ 3
df <- 
  tibble::tibble(
    lemma = sample(x = x, size = n, replace = TRUE, prob = prob),
    sentence = rep(seq(sentences), each = len))
draw_bigram_network(df)

#> $df
#> # A tibble: 1,500 × 2
#>    lemma sentence
#>    <chr>    <int>
#>  1 a            1
#>  2 j            1
#>  3 f            1
#>  4 b            1
#>  5 a            1
#>  6 d            1
#>  7 e            1
#>  8 c            1
#>  9 h            1
#> 10 i            1
#> # ℹ 1,490 more rows
#> 
#> $bigram
#> # A tibble: 264 × 3
#>    word_1 word_2  freq
#>    <chr>  <chr>  <int>
#>  1 b      a         25
#>  2 a      c         22
#>  3 b      d         21
#>  4 e      b         21
#>  5 d      b         20
#>  6 a      a         19
#>  7 b      g         19
#>  8 a      b         18
#>  9 b      c         18
#> 10 c      b         18
#> # ℹ 254 more rows
#> 
#> $freq
#>  [1] 10 10 10 10 10 10 10 10  8  8  8  8  6  6
#> 
#> $gg

#> 
```
