
# moranajp

The goal of moranajp is a tool of morphological analysis for Japanese.

## Note

Line breaks in the text will be removed to avoid lag text id. If you
want to remain line breaks, please change them into other character.

## Installation

You can install the released version of moranajp from \[GitHub\] (
<https://github.com/> ). moranajp will not be released in cran, because
the main user is only Japanese speakers. You need install MeCab (
<https://taku910.github.io/mecab/> ).

``` r
# install.packages("devtools")
devtools::install_github("matutosi/moranajp")
```

You can download binary version (zip file).

<https://github.com/matutosi/moranajp/tree/main/zip>

## Example

Example for Windows

``` r
library(moranajp)
library(tidyverse)
library(magrittr)

data(neko)
neko  # The first part of 'I Am a Cat' by Soseki Natsume

  # Directory of mecab
  # No need when setting path to mecab
bin_dir <- "c:/MeCab/bin/"  # set your environment

  # Fileencoding in mecab. "CP932" (shift_jis) , "UTF-8" or "EUC"
fileEncoding <- "CP932"  # set your environment

res <- 
  neko %>%
  mutate(cols=rep(1:2, each=2)) %>%
  mecab_all(text_col="text", bin_dir=bin_dir, fileEncoding=fileEncoding) %>%
  print(n=nrow(.))
```

Example for Mac

``` r
library(moranajp)
library(tidyverse)
library(magrittr)

data(neko)
neko$text <- iconv(neko$text, from="cp932", to="utf-8")# Mac, LinuxなどUTF-8の場合
neko

  # Directory of mecab
  # No need when setting path to mecab
bin_dir <- "/opt/local/mecab/bin/"  # set your environment
tmp_dir <- "/Users/foo"             # set your environment

  # Fileencoding in mecab. "CP932" (shift_jis) , "UTF-8" or "EUC"
fileEncoding <- "utf-8"  # set your environment

res <- 
  neko %>%
  mutate(cols=rep(1:2, each=2)) %>%
  mecab_all(text_col="text", bin_dir=bin_dir, tmp_dir=tmp_dir, fileEncoding=fileEncoding) %>%
  print(n=nrow(.))
```

## Citation

Toshikazu Matsumura (2021) Morphological analysis for Japanese with R.
<https://github.com/matutosi/moranajp/>.

## Installation of MeCab for (Linux / Mac)

download file (mecab-0.996.tar.gz, mecab-ipadic-2.7.0-20070801.tar.gz)

<http://taku910.github.io/mecab/#download>

      tar xvf mecab-0.996.tar.gz
      cd mecab-0.996
      ./configure --enable-utf8-only --prefix=/opt/local/mecab
      make
      sudo make install
      # install directory
      tar xvf mecab-ipadic-2.7.0-20070801.tar.gz
      cd mecab-ipadic-2.7.0-20070801
      ./configure  --with-mecab-config=/opt/local/mecab/bin/mecab-config --with-charset=utf8 --prefix=/opt/local/mecab
      make
      sudo make install
      # add path
      echo 'export PATH=/opt/local/mecab/bin:$PATH' >> ~/.bash_profile
      source ~/.bash_profile
      # run mecab
      mecab

ref (in Japanese) <https://qiita.com/nkjm/items/913584c00af199794257>
