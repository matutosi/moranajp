
# moranajp

moranajpは，日本語形態素解析をするためのものです．

## Installation

最新バージョンは，\[GitHub\] ( <https://github.com/> )
でダウンロードできます．
日本語話者のみを対象としていますので，cranでの公開は予定していません．
MeCab ( <https://taku910.github.io/mecab/> )
を別途インストールする必要があります．

``` r
install.packages("moranajp")

# install.packages("devtools")
devtools::install_github("matutosi/moranajp")
```

Windows版のzipファイルは，以下からダウンロード可能です．

<https://github.com/matutosi/moranajp/tree/main/zip>

## Example

Windows用の例

``` r
library(moranajp)
library(tidyverse)
library(magrittr)

data(neko)
neko  # 『吾輩は猫である』(夏目漱石)の冒頭部分

  # MeCabの実行ファイルのディレクトリ
  # pathがとおっている場合は，設定不要
bin_dir <- "c:/MeCab/bin/"  # set your environment

res <- 
  neko %>%
  mutate(cols=rep(1:2, each=2)) %>%
  moranajp_all(text_col="text", bin_dir=bin_dir) %>%
  print(n=nrow(.))
```

Mac用の例

``` r
library(moranajp)
library(tidyverse)
library(magrittr)

data(neko)
neko$text <- iconv(neko$text, from="cp932", to="utf-8")# Mac, LinuxなどUTF-8の場合
neko

  # MeCabの実行ファイルのディレクトリ
  # pathがとおっている場合は，設定不要
bin_dir <- "/opt/local/mecab/bin/"  # set your environment

res <- 
  neko %>%
  mutate(cols=rep(1:2, each=2)) %>%
  moranajp_all(text_col="text", bin_dir=bin_dir) %>%
  print(n=nrow(.))
```

## Note

文字列内の改行コード(,
)は，削除されます(EOSでtext_idを見分けており，改行コードでずれるのを防ぐため)．
改行コードに意味がある場合は，事前に改行コードを別の文字列に変更するなどの対応をしてください．

## Citation

松村 俊和 (2021) Rによる日本語形態素解析.
<https://github.com/matutosi/moranajp/>.

## 参考(Linux / Mac へのMeCabインストール)

ファイルのダウンロード(mecab-0.996.tar.gz,
mecab-ipadic-2.7.0-20070801.tar.gz)

<http://taku910.github.io/mecab/#download>

インストール

      tar xvf mecab-0.996.tar.gz
      cd mecab-0.996
      ./configure --enable-utf8-only --prefix=/opt/local/mecab
      make
      sudo make install
      # 辞書のインストール
      tar xvf mecab-ipadic-2.7.0-20070801.tar.gz
      cd mecab-ipadic-2.7.0-20070801
      ./configure  --with-mecab-config=/opt/local/mecab/bin/mecab-config --with-charset=utf8 --prefix=/opt/local/mecab
      make
      sudo make install
      # パスの追加
      echo 'export PATH=/opt/local/mecab/bin:$PATH' >> ~/.bash_profile
      source ~/.bash_profile
      # mecabの実行
      mecab

参考：<https://qiita.com/nkjm/items/913584c00af199794257>
