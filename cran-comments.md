## Resubmission of an archived package

  moranajp was archived on 2025-10-25 for a policy violation on internet access.
  The examples of `web_chamame()` accessed web chamame
  (<https://chamame.ninjal.ac.jp/>) and gave an error
  when the web service was not available.

  In this version I have:

  * Made `web_chamame()` fail gracefully.
    When the web service is not available or its response has changed,
    it shows an informative message and returns `NULL`
    instead of giving an error.
    Both reading the page and submitting the form are guarded.
    `moranajp_all(method = "chamame")` also returns `NULL` in that case.
  * Wrapped all examples that need an internet resource in `\dontrun{}`,
    so that no example accesses the internet.
    This also applies to the inherited examples of `make_groups()`.
  * Added a test that `web_chamame()` returns `NULL` with a message
    when the resource is not available.
    No test accesses an internet resource.
  * Followed the 2025 update of web chamame, which had changed its form
    and its output columns, so that the package works with it again.

  Other fixes: two functions gave an error, which made an example fail.
  See NEWS.md.

## Test environments

* local
    * Windows 11, R 4.5.1
* devtools::check_win_devel()
    * Windows Server 2022, R Under development (2026-08-04 r90350 ucrt)
* rhub::rc_submit()
    * ubuntu-latest, R-devel
    * windows-latest, R-devel
    * macos-15-intel, R-devel

## R CMD check results

There were 0 ERRORs, 0 WARNINGs, and 1 NOTE.

The NOTE is on the local check and on win-builder:

* checking CRAN incoming feasibility ... NOTE
    Maintainer: 'Toshikazu Matsumura <matutosi@gmail.com>'
    New submission
    Package was archived on CRAN

All three R-hub platforms gave "Status: OK" with no NOTEs.

## Downstream dependencies

There are currently no downstream dependencies for this package.
