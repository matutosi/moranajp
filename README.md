
# moranajp

The goal of moranajp is a tool of morphological analysis for Japanese.

readme in Japanese:
<https://github.com/matutosi/moranajp/blob/main/READMEjp.md>

## Installation

You can install the released version of moranajp from \[GitHub\] (
<https://github.com/> ). moranajp will not be released in cran, because
the main user is only Japanese speakers. You need install MeCab (
<https://taku910.github.io/mecab/> ).

``` r
  # CRAN
install.packages("moranajp")

  # development
  # install.packages("devtools")
devtools::install_github("matutosi/moranajp")
```

You can download binary version (zip file).

<https://github.com/matutosi/moranajp/tree/main/zip>

## Example

``` r
options(encoding="UTF-8")
library(moranajp)
library(tidyverse)
library(magrittr)

data(neko)
neko <- 
  neko %>%
  dplyr::mutate(text = stringi::stri_unescape_unicode(text)) %>%
  dplyr::mutate(cols = 1:nrow(.))
neko  # First part of 'I Am a Cat' by Soseki Natsume

  # Directory of mecab
bin_dir <- "c:/MeCab/bin/"  # set your environment

res <- moranajp_all(neko, text_col="text", bin_dir=bin_dir)
res
  # # if illegal character, use iconv = "CP932_UTF-8" or iconv = "EUC_UTF-8"
  # moranajp_all(neko, text_col="text", bin_dir=bin_dir, iconv="CP932_UTF-8")
```

## Note

Line breaks in the text will be removed to avoid lag text id. If you
want to remain line breaks, please change them into other character.

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
