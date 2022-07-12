## Test environments

* local
    * Windows 10, R 4.2.1
    * Mac OS 11 Big Sur, R 4.2.1
* devtools::check_rhub()
    * Windows Server 2022, R-devel, 64 bit
    * Ubuntu Linux 20.04.1 LTS, R-release, GCC
    * Fedora Linux, R-devel, clang, gfortran
* devtools::check_win_devel()

## R CMD check results

There were no ERRORs, no WARNINGs, and 1 NOTEs.

* checking for detritus in the temp directory ... NOTE   
  Found the following files/directories:   
    'lastMiKTeXException'   

check_rhub() on Windows Server shows this note. 

## Downstream dependencies

There are currently no downstream dependencies for this package.
