# Make groups by splitting string length

Using 'MeCab' for morphological analysis. Keep other colnames in
dataframe.

## Usage

``` r
make_groups(
  tbl,
  text_col = "text",
  length = 8000,
  tmp_group = "tmp_group",
  str_length = "str_length"
)

make_groups_sub(tbl, text_col, n_group, tmp_group, str_length)

max_sum_str_length(tbl, tmp_group, str_length)
```

## Arguments

- tbl:

  A tibble or data.frame.

- text_col:

  A text. Colnames for morphological analysis.

- length:

  A numeric.

- tmp_group, str_length:

  A string to use temporary.

- n_group:

  A numeric.

## Value

A tibble. Output of morphological analysis and added column "text_id".
`NULL` when `method = "chamame"` and web chamame is not available.

A string

A string

A string

A character vector

A character vector

A character vector

A character vector

A character vector

A data.frame

## Examples

``` r
# make_groups() is an internal function, called by moranajp_all().
data(review)
review |>
  unescape_utf() |>
  moranajp:::make_groups(length = 1000)
#> # A tibble: 457 × 5
#>    text                                               chap  sect  para tmp_group
#>    <chr>                                             <dbl> <dbl> <dbl>     <int>
#>  1 農地は農産物を生産する機能だけでなく，生物多様性を維持する機能も有している．……     1     1     1         1
#>  2 特に農地の辺縁部は，管理・土地利用・景観構造などの違いを反映した複雑で多様な生態系であり（LeC…     1     1     1         1
#>  3 例えば，ヨーロッパでは農地の辺縁部はfieldmargin,fieldedge,fieldbau…     1     1     1         1
#>  4 しかし，農村景観における生物多様性は，土地利用の変化や耕作放棄などによって，世界各地で減少してい…     1     1     1         1
#>  5 日本においては水田の辺縁部として畦畔があり，畦畔に成立する半自然草原は生物の生息場所として重要で…     1     1     2         1
#>  6 2011年における日本全体の水田畦畔の面積は約14万haであり（総務省の政府統計の総合窓口，本最…     1     1     2         1
#>  7 主に採草地として維持されてきた山地の半自然草原の面積は減少しており（氷見山ほか1995），畦畔の…     1     1     2         1
#>  8 しかし，圃場整備や耕作放棄の影響を受けて，日本の水田畦畔に成立する半自然草原の種多様性は低下する…     1     1     2         2
#>  9 このような水田の畦畔は1990年代に入るまでは植生調査の対象とされることは少なかった．……     1     1     3         2
#> 10 大縮尺の植生図でない限り畦畔は水田に含められ，単独で調査されることはほとんどなかった．……     1     1     3         2
#> # ℹ 447 more rows
```
