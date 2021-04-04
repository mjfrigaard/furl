Creating an R package
=============


## Install and load the necessary packages

```r
install.packages(c("devtools", "roxygen2", "testthat", "knitr",
                   "tidyverse", "fs", "withr"))
```

```r
library(devtools)
library(roxygen2)
library(testthat)
library(knitr)
library(tidyverse)
library(fs)
library(withr)
```

## Create the package

Navigate to the appropriate folder and use the `usethis::create_package()` function to create our new function:

```r
usethis::create_package("~/@r-packages/furl")
✓ Creating '@r-packages/furl/'
✓ Setting active project to '@r-packages/furl'
✓ Creating 'R/'
✓ Writing 'DESCRIPTION'
Package: furl
Title: What the Package Does (One Line, Title Case)
Version: 0.0.0.9000
Authors@R (parsed):
    * First Last <first.last@example.com> [aut, cre] (YOUR-ORCID-ID)
Description: What the package does (one paragraph).
License: `use_mit_license()`, `use_gpl3_license()` or friends to
    pick a license
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.1.1
✓ Writing 'NAMESPACE'
✓ Writing 'furl.Rproj'
✓ Adding '^furl\\.Rproj$' to '.Rbuildignore'
✓ Adding '.Rproj.user' to '.gitignore'
✓ Adding '^\\.Rproj\\.user$' to '.Rbuildignore'
✓ Opening '@r-packages/furl/' in new RStudio session
✓ Setting active project to '<no active project>'
```

This creates the following folder and contents:

```r
furl/
    ├── DESCRIPTION
    ├── NAMESPACE
    ├── R
    └── furl.Rproj
```

## Use Git

Next we want to make sure we're using Git with this project, which we can do with `usethis::use_git()`

```r
usethis::use_git()

✓ Setting active project to '@r-packages/furl'
✓ Initialising Git repo
✓ Adding '.Rhistory', '.Rdata', '.httr-oauth', '.DS_Store' to '.gitignore'
There are 5 uncommitted files:
* '.gitignore'
* '.Rbuildignore'
* 'DESCRIPTION'
* 'furl.Rproj'
* 'NAMESPACE'
Is it ok to commit them?

1: No way
2: Negative
3: For sure

Selection: 3
```

This prompts us to restart R:


```r
✓ Adding files
✓ Making a commit with message 'Initial commit'
● A restart of RStudio is required to activate the Git pane
Restart now?

1: No
2: Negative
3: Definitely

Selection: 3
```

We can check the content from these functions in the Terminal with `ls -la`

```zsh
$ ls -la
total 40
drwxr-xr-x@ 10 mjfrigaard  staff  320 Apr  4 00:14 .
drwxr-xr-x@  8 mjfrigaard  staff  256 Apr  4 00:11 ..
-rw-rw-rw-@  1 mjfrigaard  staff   30 Apr  4 00:11 .Rbuildignore
drwxr-xr-x@  4 mjfrigaard  staff  128 Apr  4 00:11 .Rproj.user
drwxr-xr-x@ 11 mjfrigaard  staff  352 Apr  4 00:14 .git
-rw-rw-rw-@  1 mjfrigaard  staff   51 Apr  4 00:12 .gitignore
-rw-rw-rw-@  1 mjfrigaard  staff  500 Apr  4 00:11 DESCRIPTION
-rw-rw-rw-@  1 mjfrigaard  staff   46 Apr  4 00:11 NAMESPACE
drwxr-xr-x@  2 mjfrigaard  staff   64 Apr  4 00:11 R
-rw-rw-rw-@  1 mjfrigaard  staff  414 Apr  4 00:14 furl.Rproj
```

## Write a function

We're going to write a function for splitting a column with an unknown number of elements into an unkown number of columns.

To create this function, we use `usethis::use_r("separate_multi")`

```r
usethis::use_r("separate_multi")
✓ Setting active project to '@r-packages/furl'
● Modify 'R/separate_multi.R'
● Call `use_test()` to create a matching test file
```

We put the code below into the new `'R/separate_multi.R'` script:


```r
separate_multi <- function(data, col, pattern = "[^[:alnum:]]+", into_prefix){
  # use regex for pattern, or whatever is provided
  in_pattern <- pattern
  # convert data to tibble
  in_data <- as_tibble(data)
  # convert col to character vector
  in_col <- as.character(col)
  # split columns into character matrix
  out_cols <- str_split_fixed(in_data[[in_col]],
                                       pattern = in_pattern,
                                       n = Inf)
  # replace NAs in matrix
  out_cols[which(out_cols == "")] <- NA
  # get number of cols
  m <- dim(out_cols)[2]
  # assign column names
  colnames(out_cols) <- paste(into_prefix, 1:m, sep = "_")
  # convert to tibble
  out_cols <- as_tibble(out_cols)
  # bind cols together
  out_tibble <- bind_cols(in_data, out_cols)
  # return the out_tibble
  return(out_tibble)
}
```

As we can see, this function uses the `tibble`, `stringr` and `dplyr` packages, so we need to add these to the `DESCRIPTION` file using the `usethis::use_package()` function:

```r
usethis::use_package(package = "tibble")
✓ Adding 'tibble' to Imports field in DESCRIPTION
● Refer to functions with `tibble::fun()`
usethis::use_package(package = "dplyr")
✓ Adding 'dplyr' to Imports field in DESCRIPTION
● Refer to functions with `dplyr::fun()`
usethis::use_package(package = "stringr")
✓ Adding 'stringr' to Imports field in DESCRIPTION
● Refer to functions with `stringr::fun()`
```

We see these lines added to the `DESCRIPTION` file:

```
Imports:
    dplyr,
    stringr,
    tibble
```

The output tells us we need to add the package::function() syntax for the three imported functions (`tibble`, `dplyr`, `stringr`):

```r
separate_multi <- function(data, col, pattern = "[^[:alnum:]]+", into_prefix){
  # use regex for pattern, or whatever is provided
  in_pattern <- pattern
  # convert data to tibble
  in_data <- tibble::as_tibble(data)
  # convert col to character vector
  in_col <- as.character(col)
  # split columns into character matrix
  out_cols <- stringr::str_split_fixed(in_data[[in_col]],
                                       pattern = in_pattern,
                                       n = Inf)
  # replace NAs in matrix
  out_cols[which(out_cols == "")] <- NA
  # get number of cols
  m <- dim(out_cols)[2]
  # assign column names
  colnames(out_cols) <- paste(into_prefix, 1:m, sep = "_")
  # convert to tibble
  out_cols <- tibble::as_tibble(out_cols)
  # bind cols together
  out_tibble <- dplyr::bind_cols(in_data, out_cols)
  # return the out_tibble
  return(out_tibble)
}
```

## Insert Roxygen skeleton

With our cursor placed inside the `separate_multi()` function, we can navigate to the toolbar and under the *'Code'* option, we will select the *'Insert Roxygen skeleton'* option.

This inserts the following code at the top of the `R/separate_multi.R` file:

```r
#' Title
#'
#' @param data
#' @param col
#' @param pattern
#' @param into_prefix
#'
#' @return
#' @export
#'
#' @examples
```

The `Title` can be changed to `separate_multi`.

```r
#' separate_multi
```

The `@param` tags need a `name` and a `description`, we we include below:

```r
#' @param data data.frame or tibble
#' @param col column to be separated
#' @param pattern regular expression pattern
#' @param into_prefix prefix for new columns
```

The `@export` tag is set to `separate_multi`

```r
#' @export separate_multi
```

We will remove the `@return` and `@example` tags from the `separate_multi.R` file and use the `devtools::document()` function (wrapper for  `roxygen2::roxygenize()`) to include the documentation for  `separate_multi()`.

```r
devtools::document()
Updating furl documentation
ℹ Loading furl
Writing NAMESPACE
```

This creates a `man/separate_multi.Rd` file with the following content:

```rd
% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/separate_multi.R
\name{separate_multi}
\alias{separate_multi}
\title{separate_multi}
\usage{
separate_multi(data, col, pattern = "[^[:alnum:]]+", into_prefix)
}
\arguments{
\item{data}{data.frame or tibble}

\item{col}{column to be separated}

\item{pattern}{regular expression pattern}

\item{into_prefix}{prefix for new columns}
}
\description{
separate_multi
}
```

The `NAMESPACE` also includes `export(separate_multi)`

```rd
# Generated by roxygen2: do not edit by hand

export(separate_multi)
```

## Check the package

Finally, we will run `check()` (*`check` automatically builds and checks a source package, using all known best practices.*)


```r
check()
Updating furl documentation
ℹ Loading furl
Writing NAMESPACE
Writing NAMESPACE
── Building ────────────────────────────────────────────────────────────── furl ──
Setting env vars:
● CFLAGS    : -Wall -pedantic -fdiagnostics-color=always
● CXXFLAGS  : -Wall -pedantic -fdiagnostics-color=always
● CXX11FLAGS: -Wall -pedantic -fdiagnostics-color=always
──────────────────────────────────────────────────────────────────────────────────
✓  checking for file ’/@r-packages/furl/DESCRIPTION’ (543ms)
─  preparing ‘furl’:
✓  checking DESCRIPTION meta-information ...
─  checking for LF line-endings in source and make files and shell scripts
─  checking for empty or unneeded directories
─  building ‘furl_0.0.0.9000.tar.gz’

── Checking ────────────────────────────────────────────────────────────── furl ──
Setting env vars:
● _R_CHECK_CRAN_INCOMING_REMOTE_: FALSE
● _R_CHECK_CRAN_INCOMING_       : FALSE
● _R_CHECK_FORCE_SUGGESTS_      : FALSE
● NOT_CRAN                      : true
── R CMD check ───────────────────────────────────────────────────────────────────
─  using log directory ‘/private/var/folders/3p/wzkys03s6p1cvmn8yzm934400000gn/T/Rtmpw1MwmS/furl.Rcheck’ (359ms)
─  using R version 4.0.4 (2021-02-15)
─  using platform: x86_64-apple-darwin17.0 (64-bit)
─  using session charset: UTF-8
─  using options ‘--no-manual --as-cran’
✓  checking for file ‘furl/DESCRIPTION’ ...
─  this is package ‘furl’ version ‘0.0.0.9000’
─  package encoding: UTF-8
✓  checking package namespace information ...
✓  checking package dependencies (1.4s)
✓  checking if this is a source package
✓  checking if there is a namespace
✓  checking for executable files ...
✓  checking for hidden files and directories
✓  checking for portable file names
✓  checking for sufficient/correct file permissions
✓  checking serialization versions
✓  checking whether package ‘furl’ can be installed (2s)
✓  checking installed package size ...
✓  checking package directory ...
✓  checking for future file timestamps (1.1s)
W  checking DESCRIPTION meta-information ...
   Non-standard license specification:
     `use_mit_license()`, `use_gpl3_license()` or friends to pick a
     license
   Standardizable: FALSE
✓  checking top-level files ...
✓  checking for left-over files
✓  checking index information ...
✓  checking package subdirectories ...
✓  checking R files for non-ASCII characters ...
✓  checking R files for syntax errors ...
✓  checking whether the package can be loaded ...
✓  checking whether the package can be loaded with stated dependencies ...
✓  checking whether the package can be unloaded cleanly ...
✓  checking whether the namespace can be loaded with stated dependencies ...
✓  checking whether the namespace can be unloaded cleanly ...
✓  checking dependencies in R code (895ms)
✓  checking S3 generic/method consistency (475ms)
✓  checking replacement functions ...
✓  checking foreign function calls ...
✓  checking R code for possible problems (2.1s)
✓  checking Rd files ...
✓  checking Rd metadata ...
✓  checking Rd line widths ...
✓  checking Rd cross-references ...
✓  checking for missing documentation entries ...
✓  checking for code/documentation mismatches (522ms)
✓  checking Rd \usage sections (848ms)
✓  checking Rd contents ...
✓  checking for unstated dependencies in examples ...
─  checking examples ... NONE
✓  checking for non-standard things in the check directory
✓  checking for detritus in the temp directory

   See
     ‘/private/var/folders/3p/wzkys03s6p1cvmn8yzm934400000gn/T/Rtmpw1MwmS/furl.Rcheck/00check.log’
   for details.


── R CMD check results ────────────────────────────────────── furl 0.0.0.9000 ────
Duration: 12.9s

> checking DESCRIPTION meta-information ... WARNING
  Non-standard license specification:
    `use_mit_license()`, `use_gpl3_license()` or friends to pick a
    license
  Standardizable: FALSE

0 errors ✓ | 1 warning x | 0 notes ✓
```

We can see the package passed all the checks with one warning (`Non-standard license specification`) we can fix this with `usethis::use_mit_license()`

```r
usethis::use_mit_license()
✓ Setting License field in DESCRIPTION to 'MIT + file LICENSE'
✓ Writing 'LICENSE'
✓ Writing 'LICENSE.md'
✓ Adding '^LICENSE\\.md$' to '.Rbuildignore'
```

When we rerun check, we see the following:

```r
0 errors ✓ | 0 warnings ✓ | 0 notes ✓
```

## Data

We're going to create a test dataset for the `separate_multi()` function. We can do this with the `usethis::use_data_raw()` function:

```r
usethis::use_data_raw(name = "j3s")
✓ Creating 'data-raw/'
✓ Adding '^data-raw$' to '.Rbuildignore'
✓ Writing 'data-raw/j3s.R'
● Modify 'data-raw/j3s.R'
● Finish the data preparation script in 'data-raw/j3s.R'
● Use `usethis::use_data()` to add prepared data to package
```

We will add the code to the `data-raw/j3s.R` file:

```r
j3s <- tibble::tribble(
        ~value,                       ~name,
           29L,                      "John",
           91L,               "John, Jacob",
           39L, "John, Jacob, Jingleheimer",
           28L,     "Jingleheimer, Schmidt",
           12L,              "JJJ, Schmidt")
```

After running this code, we can add `j3s` to the `data` folder by using the `usethis::use_data()` function:

```r
usethis::use_data(j3s, j3s)
Warning: Saving duplicates only once: 'j3s'
✓ Saving 'j3s' to 'data/j3s.rda'
● Document your data (see 'https://r-pkgs.org/data.html')
```

Lets take a look at the package contents:

```r
furl/
    ├── DESCRIPTION
    ├── LICENSE
    ├── LICENSE.md
    ├── NAMESPACE
    ├── R
    │   └── separate_multi.R
    ├── data
    │   └── j3s.rda
    ├── data-raw
    │   └── j3s.R
    ├── furl.Rproj
    └── man
        └── separate_multi.Rd
```
