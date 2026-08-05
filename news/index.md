# Changelog

## moranajp 0.9.8

CRAN release: 2026-08-05

- 2026-08-05
- [`web_chamame()`](https://matutosi.github.io/moranajp/reference/web_chamame.md)
  fails gracefully when web chamame is not available
  - Shows a message and returns `NULL` instead of an error
  - `moranajp_all(method = "chamame")` also returns `NULL`
- Examples using web chamame are wrapped in `\dontrun{}`
- Follow the 2025 update of web chamame
  - Select the form fields by name, not by index (web chamame added 8
    fields, which shifted all the indices)
  - Keep the new `dic_version` field: without it, web chamame returns a
    server error for UniDic dictionaries
  - Add `dic` argument to
    [`web_chamame()`](https://matutosi.github.io/moranajp/reference/web_chamame.md)
    and
    [`moranajp_all()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
    to select the dictionary
  - Request only the output items to use, and select the columns by name
    (the columns of web chamame changed, and the previous positions
    returned the conjugation type as the part of speech, and the lexeme
    as the base form)
- Fix
  [`add_sentence_no()`](https://matutosi.github.io/moranajp/reference/add_sentence_no.md):
  `cond` is evaluated in the caller’s environment
- Fix
  [`add_depend_ginza()`](https://matutosi.github.io/moranajp/reference/clean_up.md):
  remove an unused argument of
  [`add_sentence_no()`](https://matutosi.github.io/moranajp/reference/add_sentence_no.md)
- Restore `brk` argument of
  [`add_text_id()`](https://matutosi.github.io/moranajp/reference/add_text_id.md)
- Use
  [`dplyr::all_of()`](https://tidyselect.r-lib.org/reference/all_of.html)
  instead of `.data[[x]]` in tidyselect contexts, where `.data[[x]]` is
  deprecated (`.data[[x]]` is kept in data-masking contexts)

## moranajp 0.9.7

CRAN release: 2024-08-01

- 2024-07-12
- Update
  [`moranajp()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
  according to web-chamame update
- Use pkgdown
- Change pipe `%>%` into `|>`

## moranajp 0.9.6

CRAN release: 2023-02-28

- 2023-02-28
- Add
  [`bigram()`](https://matutosi.github.io/moranajp/reference/draw_bigram_network.md)
  and related functions
- Can use “sudachi”, “ginza” and “chamame”
  - Add `method` argument in
    [`mecab()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
    and
    [`mecab_all()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
    to be able to use “sudachi”, “ginza” and “chamame”

## moranajp 0.9.5

CRAN release: 2022-07-12

- 2022-07-12
- Fix Bugs: to apply illegal character
  - [`moranajp()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
    add argument “iconv” to convert encoding of MeCab output
  - Remove illegal character ( &, \|, \<. \> or “) for command in
    [`moranajp_all()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)

## moranajp 0.9.4

CRAN release: 2022-05-06

- 2022-05-06
- Can apply over 8000 length strings.
  - [`make_groups()`](https://matutosi.github.io/moranajp/reference/make_groups.md)
  - [`make_groups_sub()`](https://matutosi.github.io/moranajp/reference/make_groups.md)
  - [`max_sum_str_length()`](https://matutosi.github.io/moranajp/reference/make_groups.md)
- Use [`purrr::map()`](https://purrr.tidyverse.org/reference/map.html)
  in
  [`moranajp()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)

## moranajp 0.9.3

CRAN release: 2022-03-30

- 2022-03-30
- Improve functions.
  - [`moranajp_all()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
    \<-
    [`mecab_all()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
  - [`moranajp()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
    \<-
    [`mecab()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
- Add tests by testthat
- Add data-raw

## moranajp 0.9.2

- bug fix

## moranajp 0.9.1

- code of line breaks will be removed to avoid declination.

## moranajp 0.9.0

- First release
- [`mecab()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md),
  [`mecab_all()`](https://matutosi.github.io/moranajp/reference/moranajp_all.md)
  : main functions for morphological analysis using ‘MeCab’. Can use
  data.frame.
- [`add_text_id()`](https://matutosi.github.io/moranajp/reference/add_text_id.md):
  internal function.
- `neko`: The first part of ‘I Am a Cat’ by Soseki Natsume
