
[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/iptree.svg?branch=master)](https://travis-ci.org/hrbrmstr/iptree)
[![Coverage
Status](https://codecov.io/gh/hrbrmstr/iptree/branch/master/graph/badge.svg)](https://codecov.io/gh/hrbrmstr/iptree)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/iptree)](https://cran.r-project.org/package=iptree)

# iptrie

Efficiently Store and Query ‘IPv4’ Internet Addresses with Associated
Data

## Description

Tries are great ways to store data that has obvious hierarchichal
properties, such as ‘IPv4’ addresses. Methods are provided to create
‘IPv4’ tries and store, retrieve and delete ‘IPv4’ address keys with
values. Functions are based on the ‘zmap’ ‘iptree’ ‘C’ library.

## NOTE

This is an experiment but will likely turn into a CRAN package or get
migrated to either the `iptools` or `asntools` package.

I initially wanted to feel the pain (again) of using R’s own C interface
(i.e. no `Rcpp` crutch) since it’s easy to forget just how handy Rcpp
is. (It turns out that my ill memories of playing at the R C level are
also unjustified).

Having said that, I also need this functionality and the basic functions
here will have more robust conterparts soon.

PRs and issues welcome.

## What’s Inside The Tin

The following functions are implemented:

  - `iptrie_create`: Create a new IPv4 Trie
  - `iptrie_destroy`: Destroy an IP trie
  - `iptrie_insert`: Insert a value for an IPv4 Address+CIDR combo into
    an IPv4 Trie
  - `iptrie_lookup`: Lookup a value for an IPv4 Address+CIDR combo into
    an IPv4 Trie or Test for Existence
  - `iptrie_remove`: Remove a trie entry for an IPv4 Address+CIDR combo
    into an IPv4 Trie

## Installation

``` r
devtools::install_git("https://sr.ht.com/~hrbrmstr/iptrie.git")
# or
devtools::install_git("https://gitlab.com/hrbrmstr/iptrie.git")
# or (if you must)
devtools::install_github("hrbrmstr/iptree")
```

## Usage

``` r
library(iptrie)

# current version
packageVersion("iptree")
## [1] '0.1.0'
```

### Basic Usage

``` r
x <- iptrie_create()

iptrie_insert(x, "10.1.10.0/24", "HOME")

iptrie_ip_exists(x,"10.1.10.1/32")
## [1] TRUE

iptrie_ip_exists(x,"10.1.11.1/32")
## [1] FALSE

iptrie_lookup(x, "10.1.10.1/32")
## [1] "HOME"
```

## iptree Metrics

| Lang         | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :----------- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| C            |        2 | 0.25 | 271 | 0.80 |          25 | 0.36 |        0 | 0.00 |
| C/C++ Header |        1 | 0.12 |  29 | 0.09 |           9 | 0.13 |       15 | 0.12 |
| R            |        4 | 0.50 |  24 | 0.07 |           7 | 0.10 |       61 | 0.48 |
| Rmd          |        1 | 0.12 |  13 | 0.04 |          29 | 0.41 |       51 | 0.40 |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
