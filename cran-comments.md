## Resubmission

  This is a resubmission. In this version I have: 
      * Solved issues for archived version by updating codes and examples in 'bigram.R'. 
      * Described references in the DESCRIPTION file.
      * Added \value to .Rd files. 
          'add_text_id.Rd', 'combine_words.Rd', 'remove_brk.Rd'
      * Replaced dontrun{} with \donttest{} in examples that can be execute in < 5 secs.
      * Replaced \dontrun with \donttest.
        However, some example codes cannot be excuted, because installations are needed. 
        I have descrived in examples as a comment. 
          "Need to install 'mecab', 'ginza', or 'sudachi' in local PC" in 'moranajp_all.Rd'
      * Replaced `print()` with `message()`.
          'R/moranajp.R'
      * Removed tools directory by .Rbuildignore to remove global environment and 'structure.R'.

## Test environments

* local
    * Windows 11, R 4.3.3
* devtools::check_win_devel()
* rhub::rc_submit()
    * ubuntu-latest on GitHub
    * macos-latest on GitHub
    * windows-latest on GitHub

## R CMD check results

There were 0 ERRORs, 0 WARNINGs, and 1 NOTEs.

* checking CRAN incoming feasibility ... NOTE
    Maintainer: 'Toshikazu Matsumura <matutosi@gmail.com>'
    New submission
    Package was archived on CRAN

## Downstream dependencies

There are currently no downstream dependencies for this package.
