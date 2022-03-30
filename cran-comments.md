## Resubmission

This is a resubmission. In this version I have:

* Exported add_series_no() and add_text_id() in: add_series_no.Rd.
* Removed \dontrun{} in example of add_series_no().
* Removed the codes of moranajp() that write user's filespace.
* Removed encoding setting from vignettes because of needless.
* Revised readme.md, vignettes, and text to match the above.

## Test environments

* local
    * Windows 10, R 4.1.3
    * Mac OS 11 Big Sur, R 4.1.3
* devtools::check_rhub()
    * Windows Server 2022, R-devel, 64 bit
    * Ubuntu Linux 20.04.1 LTS, R-release, GCC
    * Fedora Linux, R-devel, clang, gfortran
*  devtools::check_win_devel()

## R CMD check results

There were no ERRORs, no WARNINGs, and 2 NOTEs.

* checking CRAN incoming feasibility ... NOTE   
  Maintainer: 'Toshikazu Matsumura <matutosi@gmail.com>'   
  New submission

This is a new release.

* checking for detritus in the temp directory ... NOTE   
  Found the following files/directories:   
    'lastMiKTeXException'   

check_rhub() on Windows Server and check_win_devel() show this note. 

## Downstream dependencies

There are currently no downstream dependencies for this package.

