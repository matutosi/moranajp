
# moranajp

The goal of moranajp is a tool of morphological analysis for Japanese.

moranajpは，日本語形態素解析をするためのものです．

## Installation

NOW, only for Windows.

現在，Windowsのみで利用可能です．Mac, Linux
では使用できません(エラーになります)．

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

Example for Windows

Windows用の例

``` r
library(moranajp)
library(tidyverse)
library(magrittr)

data(neko)
neko

  # Directory of mecab
  # No need when setting path to mecab
  # MeCabの実行ファイルのディレクトリ
  # pathがとおっている場合は，設定不要
bin_dir <- "c:/MeCab/bin/"  # set your environment

  # Fileencoding in mecab. "CP932" (shift_jis) , "UTF-8" or "EUC"
  # MeCabの文字コード
fileEncoding <- "CP932"  # set your environment

res <- 
  neko %>%
  mutate(cols=rep(1:2, each=2)) %>%
  mecab_all(text_col="text", bin_dir=bin_dir, fileEncoding=fileEncoding) %>%
  print(n=nrow(.))
```

Example for Mac

Mac用の例

``` r
library(moranajp)
library(tidyverse)
library(magrittr)

data(neko)
neko$text <- iconv(neko$text, from="cp932", to="utf-8")# Mac, LinuxなどUTF-8の場合
neko

  # Directory of mecab
  # No need when setting path to mecab
  # MeCabの実行ファイルのディレクトリ
  # pathがとおっている場合は，設定不要
bin_dir <- "/opt/local/mecab/bin"  # set your environment

  # Temporary directory
  # No need when using the same directory to bin_dir
  # 一時ファイルのディレクトリ
  # bin_dirと同じディレクトリを使用する時は，設定不要
tmp_dir <- "/tmp/"

  # Fileencoding in mecab. "CP932" (shift_jis) , "UTF-8" or "EUC"
  # MeCabの文字コード
fileEncoding <- "utf-8"  # set your environment

  # column names of output
res <- 
  neko %>%
  mutate(cols=rep(1:2, each=2)) %>%
  mecab_all(text_col="text", bin_dir=bin_dir, tmp_dir=tmp_dir, fileEncoding=fileEncoding) %>%
  print(n=nrow(.))
```

## Citation

Toshikazu Matsumura (2021) Morphological analysis for Japanese with R.
<https://github.com/matutosi/moranajp/>.

松村 俊和 (2021) Rによる日本語形態素解析.
<https://github.com/matutosi/moranajp/>.
