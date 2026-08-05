# Full text of review article

Full text of review article

## Usage

``` r
review
```

## Format

A data frame with 457 rows and 4 variables:

- text:

  Body text. Escaped by stringi::stri_escape_unicode(). Body text.
  Escaped by stringi::stri_escape_unicode(). Citation is as below.
  Matsumura et al. 2014. Conditions and conservation for biodiversity of
  the semi-natural grassland vegetation on rice paddy levees. Vegetation
  Science, 31, 193-218. doi = 10.15031/vegsci.31.193
  https://www.jstage.jst.go.jp/article/vegsci/31/2/31_193/\_article/-char/en

- chap:

  chapter

- sect:

  section

- para:

  paragraph

## Examples

``` r
data(review)
review |>
  unescape_utf()
#> # A tibble: 457 × 4
#>    text                                                         chap  sect  para
#>    <chr>                                                       <dbl> <dbl> <dbl>
#>  1 農地は農産物を生産する機能だけでなく，生物多様性を維持する機能も有している．……     1     1     1
#>  2 特に農地の辺縁部は，管理・土地利用・景観構造などの違いを反映した複雑で多様な生態系であり（LeCoeuretal.2…     1     1     1
#>  3 例えば，ヨーロッパでは農地の辺縁部はfieldmargin,fieldedge,fieldbaundaryなどとよば…     1     1     1
#>  4 しかし，農村景観における生物多様性は，土地利用の変化や耕作放棄などによって，世界各地で減少している（Tilmanet…     1     1     1
#>  5 日本においては水田の辺縁部として畦畔があり，畦畔に成立する半自然草原は生物の生息場所として重要である（丑丸2012）…     1     1     2
#>  6 2011年における日本全体の水田畦畔の面積は約14万haであり（総務省の政府統計の総合窓口，本最大とされる阿蘇の草原…     1     1     2
#>  7 主に採草地として維持されてきた山地の半自然草原の面積は減少しており（氷見山ほか1995），畦畔の半自然草原は草原生生…     1     1     2
#>  8 しかし，圃場整備や耕作放棄の影響を受けて，日本の水田畦畔に成立する半自然草原の種多様性は低下するとともに，種組成は急…     1     1     2
#>  9 このような水田の畦畔は1990年代に入るまでは植生調査の対象とされることは少なかった．……     1     1     3
#> 10 大縮尺の植生図でない限り畦畔は水田に含められ，単独で調査されることはほとんどなかった．……     1     1     3
#> # ℹ 447 more rows
```
