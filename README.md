
[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/iptrie.svg?branch=master)](https://travis-ci.org/hrbrmstr/iptrie)
[![Coverage
Status](https://codecov.io/gh/hrbrmstr/iptrie/branch/master/graph/badge.svg)](https://codecov.io/gh/hrbrmstr/iptrie)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/iptrie)](https://cran.r-project.org/package=iptrie)

# iptrie

Efficiently Store and Query ‘IPv4’ Internet Addresses with Associated
Data

## Description

Tries are great ways to store data that has obvious hierarchichal
properties, such as ‘IPv4’ addresses. Methods are provided to create
‘IPv4’ tries and store, retrieve and delete ‘IPv4’ address keys with
values. Functions are based on the ‘zmap’ ‘iptree’ ‘C’ library.

## NOTE

This is an experiment that will not likely turn into a CRAN package or
get migrated to either the `iptools` or `asntools` package.

I initially wanted to feel the pain (again) of using R’s own C interface
(i.e. no `Rcpp` crutch) since it’s easy to forget just how handy Rcpp
is. (It turns out that my ill memories of playing at the R C level are
also unjustified).

This is orders of magnitude slower than the method used in
`astools::as_asntrie()` for an `astools::routeviews_latest()` data set.

## What’s Inside The Tin

The following functions are implemented:

  - `as_iptrie`: Convert a data frame to an IP trie
  - `iptrie`: Efficiently Store and Query ‘IPv4’ Internet Addresses with
    Associated Data
  - `iptrie_create`: Create a new IPv4 Trie
  - `iptrie_destroy`: Destroy an IP trie
  - `iptrie_insert`: Insert a value for an IPv4 Address+CIDR combo into
    an IPv4 Trie
  - `iptrie_ip_in`: Lookup a value for an IPv4 Address+CIDR combo into
    an IPv4 Trie or Test for Existence
  - `iptrie_lookup`: Lookup a value for an IPv4 Address+CIDR combo into
    an IPv4 Trie or Test for Existence
  - `iptrie_remove`: Remove a trie entry for an IPv4 Address+CIDR combo
    into an IPv4 Trie
  - `is_iptrie`: Create a new IPv4 Trie \#\# Installation

<!-- end list -->

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
library(tidyverse)

# current version
packageVersion("iptree")
## [1] '0.1.0'
```

### Basic Usage

``` r
x <- iptrie_create()

iptrie_insert(x, "10.1.10.0/24", "HOME")

iptrie_ip_in(x,"10.1.10.1/32")
## [1] TRUE

iptrie_ip_in(x,"10.1.11.1/32")
## [1] FALSE

iptrie_lookup(x, "10.1.10.1/32")
## [1] "HOME"
## attr(,"ip")
## [1] "10.1.10.0"
## attr(,"ipn")
## [1] 167840256
## attr(,"mask")
## [1] 24

iptrie_lookup(x, "10.1.10.1/32", "exact")
## NULL
```

### Data frame to iptrie

``` r
xdf <- data.frame(a = "10.1.10.0/24", b = "HOME", stringsAsFactors = FALSE)

(xt <- as_iptrie(xdf))
## <iptrie>

is_iptrie(xt)
## [1] TRUE

(xt <- as_iptrie(xdf, "a", "b"))
## <iptrie>

iptrie_ip_in(xt, "10.1.10.6")
## [1] TRUE
```

### Bigger example (kinda what `as.data.frame.iptrie` does)

``` r
# Make a trie from autonomous system CIDRs
xdf <- astools::routeviews_latest()

cat(scales::comma(nrow(xdf)), "\n")
## 790,647

asntrie <- iptrie_create()

system.time(for (i in 1:nrow(xdf)) {
  iptrie_insert(asntrie, xdf[["cidr"]][i], xdf[["asn"]][i])
})
##    user  system elapsed 
##   8.835   0.178   9.114

# Get a block list (picked at ransom)
blklst <- url("https://iplists.firehol.org/files/botscout_1d.ipset")
y <- readLines(blklst)
close(blklst)

y <- y[!grepl("^#", y)] # comments at the top

cat(scales::comma(length(y)), "\n")
## 1,079

system.time(do.call(
  rbind.data.frame,
  lapply(y, function(.x) {
    r <- iptrie_lookup(asntrie, .x, "best")
    if (is.null(r)) {
      data.frame(
        ip = .x, 
        asn = NA_character_, 
        cidr = NA_character_,
        stringsAsFactors = FALSE
      )
    } else {
      data.frame(
        ip = .x, 
        asn = r, 
        cidr = sprintf("%s/%d", attr(r, "ip"), attr(r, "mask")),
        stringsAsFactors = FALSE
      )
    }
  })
) -> cdf)
##    user  system elapsed 
##   0.303   0.005   0.314

as_tibble(cdf)
## # A tibble: 1,079 x 3
##    ip            asn    cidr          
##    <chr>         <chr>  <chr>         
##  1 1.10.186.158  23969  1.10.186.0/24 
##  2 1.20.100.251  23969  1.20.100.0/24 
##  3 1.20.253.128  23969  1.20.253.0/24 
##  4 1.179.157.237 131293 1.179.157.0/24
##  5 1.179.198.37  131293 1.179.198.0/24
##  6 2.61.150.231  12389  2.61.0.0/16   
##  7 2.61.173.36   12389  2.61.0.0/16   
##  8 2.95.6.233    3216   2.95.6.0/24   
##  9 2.188.164.58  42337  2.188.164.0/22
## 10 5.8.37.214    50896  5.8.37.0/24   
## # … with 1,069 more rows

count(cdf, cidr, sort=TRUE)
## # A tibble: 786 x 2
##    cidr                 n
##    <chr>            <int>
##  1 185.220.101.0/24    19
##  2 5.188.210.0/24      11
##  3 51.15.0.0/17        10
##  4 183.198.0.0/16       8
##  5 199.249.230.0/24     8
##  6 172.68.244.0/22      7
##  7 173.44.224.0/22      7
##  8 31.184.238.0/24      7
##  9 192.42.116.0/22      6
## 10 104.223.0.0/17       5
## # … with 776 more rows
```

## iptree Metrics

| Lang         | \# Files |  (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :----------- | -------: | ---: | --: | ---: | ----------: | ---: | -------: | ---: |
| C            |        3 | 0.23 | 346 | 0.65 |          37 | 0.32 |        7 | 0.03 |
| R            |        8 | 0.62 | 103 | 0.19 |          25 | 0.22 |      165 | 0.66 |
| Rmd          |        1 | 0.08 |  54 | 0.10 |          45 | 0.39 |       62 | 0.25 |
| C/C++ Header |        1 | 0.08 |  30 | 0.06 |           9 | 0.08 |       15 | 0.06 |

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
