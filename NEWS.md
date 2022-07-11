# moranajp release news


# moranajp 0.9.5.9000

* Todo
    * Deprecate `mecab()` and `mecab_all()`.
    * Add `method` argument in `mecab()` and `mecab_all()` 
      to be able to use "sudachi"
* Done

# moranajp 0.9.5

* 2022-07-12
* Fix Bugs: to apply illegal character
    * `moranajp()` add argument "iconv" to convert encoding of MeCab output
    * Remove illegal character ( &, |, <. > or ") for command in `moranajp_all()`

# moranajp 0.9.4

* 2022-05-06
* Can apply over 8000 length strings.
    * `make_groups()`
    * `make_groups_sub()`
    * `max_sum_str_length()`
* Use `purrr::map()` in `moranajp()`

# moranajp 0.9.3

* 2022-03-30
* Improve functions.
    * `moranajp_all()` <- `mecab_all()`
    * `moranajp()` <- `mecab()`
* Add tests by testthat
* Add data-raw

# moranajp 0.9.2

* bug fix

# moranajp 0.9.1

* code of line breaks will be removed to avoid declination. 

#  moranajp 0.9.0

* First release
* `mecab()`, `mecab_all()` : main functions for morphological analysis using 'MeCab'. Can use data.frame. 
* `add_text_id()`: internal function. 
* `neko`: The first part of 'I Am a Cat' by Soseki Natsume
