
# moranajp

The goal of moranajp is a tool of morphological analysis for Japanese.

moranajpは，日本語形態素解析をするためのものです．

## Installation

You can install the released version of wameicheckr from \[GitHub\] (
<https://github.com/> ). moranajp will not be released in cran, because
the main user is only Japanese speakers. You need install MeCab (
<https://taku910.github.io/mecab/> ).

最新バージョンは，\[GitHub\] ( <https://github.com/> )
でダウンロードできます．
日本語話者のみを対象としていますので，cranでの公開は予定していません．
MeCab ( <https://taku910.github.io/mecab/> )
を別途インストールする必要があります．

``` r
# install.packages("devtools")
devtools::install_github("matutosi/moranajp")
```

You can download binary version (zip file).

<https://github.com/matutosi/moranajp/tree/main/zip>

Windows版のzipファイルは，以下からダウンロード可能です．

<https://github.com/matutosi/moranajp/tree/main/zip>

## Example

``` r
library(tidyverse)
library(moranajp)

data(neko)
# neko$text <- iconv(neko$text, from="cp932", to="utf-8")# Mac, LinuxなどUTF-8の場合
neko

  # Directory of mecab
  # No need when setting path to mecab
  # MeCabの実行ファイルのディレクトリ
  # pathがとおっている場合は，設定不要
bin_dir <- "c:/MeCab/bin"  # set your environment

  # Fileencoding in mecab. "CP932" (shift_jis) , "UTF-8" or "EUC"
  # MeCab.exeの文字コード
fileEncoding <- "CP932"  # set your environment

res <- 
  neko %>%
  mutate(cols=rep(1:2, each=2)) %>%
  mecab_all(text_col="text", bin_dir=bin_dir, fileEncoding=fileEncoding) %>%
  print(n=nrow(.))
```

## Citation

Toshikazu Matsumura (2021) Morphological analysis for Japanese with R.
<https://github.com/matutosi/moranajp/>.

松村 俊和 (2021) Rによる日本語形態素解析.
<https://github.com/matutosi/moranajp/>.
