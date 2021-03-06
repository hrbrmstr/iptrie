% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create.R
\name{iptrie_remove}
\alias{iptrie_remove}
\title{Remove a trie entry for an IPv4 Address+CIDR combo into an IPv4 Trie}
\usage{
iptrie_remove(trie, ip)
}
\arguments{
\item{trie}{a trie created with \code{\link[=iptrie_create]{iptrie_create()}}}

\item{ip}{an IPv4 address with mask (will use \code{/32} if not provided)}
}
\value{
\code{trie} (invisibly)
}
\description{
Removes a trie entry for an IPv4 Address+CIDR combo into an IPv4 Trie
}
\examples{
x <- iptrie_create()
iptrie_insert(x, "10.1.10.0/24", "HOME")
iptrie_ip_in(x,"10.1.10.1/32")
iptrie_ip_in(x,"10.1.11.1/32")
iptrie_lookup(x, "10.1.10.1/32")
}
