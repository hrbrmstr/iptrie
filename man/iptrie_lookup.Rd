% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/iptrie-lookup.R
\name{iptrie_lookup}
\alias{iptrie_lookup}
\alias{iptrie_ip_in}
\title{Lookup a value for an IPv4 Address+CIDR combo into an IPv4 Trie or Test for Existence}
\usage{
iptrie_lookup(trie, ip, precision = c("best", "exact"))

iptrie_ip_in(trie, ip)
}
\arguments{
\item{trie}{a trie created with \code{\link[=iptrie_create]{iptrie_create()}}}

\item{ip}{an IPv4 address with mask (will use \code{/32} if not provided)}

\item{precision}{If "\code{best}" (the default) then the closest match is
returned. This is useful when the trie is full of CIDRs and
you're trying to test if an IP addressin a CIDR. Using "\code{exact}"
will force a test for an exact match (i.e. both the IP address
and mask have to match).}
}
\value{
length 1 character vector with attributes \code{ip}, \code{ipn}, and \code{mask}, or \code{NULL}
}
\description{
Looks up a value for or tests existence of an IPv4 Address+CIDR combo into an IPv4 Trie.
This is somewhat promiscuous as it uses \code{iptree_lookup_best_str()} from the
underlying C library vs \code{iptree_lookup_exact()}
}
\examples{
x <- iptrie_create()
iptrie_insert(x, "10.1.10.0/24", "HOME")
iptrie_ip_in(x,"10.1.10.1/32")
iptrie_ip_in(x,"10.1.11.1/32")
iptrie_lookup(x, "10.1.10.1/32")
}
