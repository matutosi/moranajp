# Clean up result of morphological analyzed data frame

Clean up result of morphological analyzed data frame

## Usage

``` r
clean_up(df, add_depend = FALSE, ...)

pos_filter(df)

add_depend_ginza(df)

delete_stop_words(df, use_common_data = TRUE, add_stop_words = NULL, ...)

replace_words(
  df,
  synonym_df = tibble::tibble(),
  synonym_from = "",
  synonym_to = "",
  ...
)

term_lemma(df)

term_pos_0(df)

term_pos_1(df)
```

## Arguments

- df:

  A dataframe including result of morphological analysis.

- add_depend:

  A logical. Available for ginza

- ...:

  Extra arguments to internal functions.

- use_common_data:

  A logical. TRUE: use data(stop_words).

- add_stop_words:

  A string vector adding into stop words. When use_common_data is TRUE
  and add_stop_words are given, both of them will be used as stop_words.

- synonym_df:

  A data.frame including synonym word pairs. The first column: replace
  from, the second: replace to.

- synonym_from, synonym_to:

  A string vector. Length of synonym_from and synonym_to should be the
  same. When synonym_df and synonym pairs (synonym_from and synonym_to)
  are given, both of them will be used as synonym.

## Value

A data.frame.

## Examples

``` r
data(neko_mecab)
data(neko_ginza)
data(review_sudachi_c)
data(synonym)
synonym <- 
  synonym |> unescape_utf()

neko_mecab <- 
  neko_mecab |>
  unescape_utf() |>
  print()
#> # A tibble: 2,884 × 11
#>    text_id 表層形 品詞   品詞細分類1 品詞細分類2 品詞細分類3 活用型 活用形 原形 
#>      <dbl> <chr>  <chr>  <chr>       <chr>       <chr>       <chr>  <chr>  <chr>
#>  1       1 吾輩   名詞   代名詞      一般        *           *      *      吾輩 
#>  2       1 は     助詞   係助詞      *           *           *      *      は   
#>  3       1 猫     名詞   一般        *           *           *      *      猫   
#>  4       1 で     助動詞 *           *           *           特殊・ダ…… 連用形 だ   
#>  5       1 ある   助動詞 *           *           *           五段・ラ行… 基本形 ある 
#>  6       1 。     記号   句点        *           *           *      *      。   
#>  7       1 名前   名詞   一般        *           *           *      *      名前 
#>  8       1 は     助詞   係助詞      *           *           *      *      は   
#>  9       1 まだ   副詞   助詞類接続  *           *           *      *      まだ 
#> 10       1 無い   形容詞 自立        *           *           形容詞・ア… 基本形 無い 
#> # ℹ 2,874 more rows
#> # ℹ 2 more variables: 読み <chr>, 発音 <chr>

neko_mecab |>
  clean_up(use_common_data = TRUE, synonym_df = synonym)
#> # A tibble: 872 × 11
#>    text_id 表層形  品詞  品詞細分類1 品詞細分類2 品詞細分類3 活用型 活用形 原形 
#>      <dbl> <chr>   <chr> <chr>       <chr>       <chr>       <chr>  <chr>  <chr>
#>  1       1 猫      名詞  一般        *           *           *      *      猫   
#>  2       1 無い    形容詞…… 自立        *           *           形容詞・ア… 基本形 ない 
#>  3       2 生れ    動詞  自立        *           *           一段   連用形 生れる……
#>  4       2 見当    名詞  サ変接続    *           *           *      *      見当 
#>  5       2 つか    動詞  自立        *           *           五段・カ行… 未然形 つく 
#>  6       2 薄暗い  形容詞…… 自立        *           *           形容詞・ア… 基本形 薄暗い……
#>  7       2 し      動詞  自立        *           *           サ変・スル… 連用形 する 
#>  8       2 ニャーニャー… 名詞  一般        *           *           *      *      *    
#>  9       2 泣い    動詞  自立        *           *           五段・カ行… 連用タ接続… 泣く 
#> 10       2 いた事  名詞  一般        *           *           *      *      いた事……
#> # ℹ 862 more rows
#> # ℹ 2 more variables: 読み <chr>, 発音 <chr>

review_ginza |>
  unescape_utf() |>
  add_sentence_no() |>
  clean_up(add_depend = TRUE, use_common_data = TRUE, synonym_df = synonym)
#> # A tibble: 7,164 × 20
#>    text_id  chap  sect  para id    表層形 原形   UD品詞タグ 品詞  品詞細分類1
#>      <dbl> <dbl> <dbl> <dbl> <chr> <chr>  <chr>  <chr>      <chr> <chr>      
#>  1       1     1     1     1 1_1   農地   農地   NOUN       名詞  普通名詞   
#>  2       1     1     1     1 1_3   農産物 農産物 NOUN       名詞  普通名詞   
#>  3       1     1     1     1 1_5   生産   生産   VERB       名詞  普通名詞   
#>  4       1     1     1     1 1_7   機能   機能   NOUN       名詞  普通名詞   
#>  5       1     1     1     1 1_12  生物   生物   NOUN       名詞  普通名詞   
#>  6       1     1     1     1 1_13  多様性 多様性 NOUN       名詞  普通名詞   
#>  7       1     1     1     1 1_15  維持   維持   VERB       名詞  普通名詞   
#>  8       1     1     1     1 1_17  機能   機能   NOUN       名詞  普通名詞   
#>  9       1     1     1     1 1_19  有し   有する VERB       動詞  一般       
#> 10       2     1     1     1 2_2   農地   農地   NOUN       名詞  普通名詞   
#> # ℹ 7,154 more rows
#> # ℹ 10 more variables: 品詞細分類2 <chr>, 属性 <chr>, 係受元 <chr>,
#> #   係受タグ <chr>, 係受ペア <chr>, その他 <chr>, sentence <dbl>,
#> #   word_no <chr>, 係受元_id <chr>, 原形_dep <chr>

review_sudachi_c |>
  unescape_utf() |>
  add_sentence_no() |>
  clean_up(use_common_data = TRUE, synonym_df = synonym)
#> # A tibble: 7,251 × 13
#>    text_id  chap  sect  para 表層形 品詞  品詞細分類1 品詞細分類2 品詞細分類3
#>      <dbl> <dbl> <dbl> <dbl> <chr>  <chr> <chr>       <chr>       <chr>      
#>  1       1     1     1     1 農地   名詞  普通名詞    一般        *          
#>  2       1     1     1     1 農産物 名詞  普通名詞    一般        *          
#>  3       1     1     1     1 生産   名詞  普通名詞    サ変可能    *          
#>  4       1     1     1     1 機能   名詞  普通名詞    サ変可能    *          
#>  5       1     1     1     1 生物   名詞  普通名詞    一般        *          
#>  6       1     1     1     1 多様性 名詞  普通名詞    一般        *          
#>  7       1     1     1     1 維持   名詞  普通名詞    サ変可能    *          
#>  8       1     1     1     1 機能   名詞  普通名詞    サ変可能    *          
#>  9       1     1     1     1 有し   動詞  一般        *           *          
#> 10       2     1     1     1 農地   名詞  普通名詞    一般        *          
#> # ℹ 7,241 more rows
#> # ℹ 4 more variables: 品詞細分類4 <chr>, 品詞細分類5 <chr>, 原形 <chr>,
#> #   sentence <dbl>
```
