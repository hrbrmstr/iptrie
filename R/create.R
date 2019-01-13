#' Create a new IPv4 Trie
#'
#' Creates a new IPv4 Trie
#'
#' @md
#' @return an external pointer to an IP trie
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_create <- function() {
  .Call(Rcreate)
  # .Call("Rcreate", PACKAGE = "iptrie")
}

#' Insert a value for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' Inserts a value for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' @md
#' @param trie a trie created with [iptrie_create()]
#' @param ip an IPv4 address with mask (will use `/32` if not provided)
#' @param value character value to store
#' @return `NULL` (invisibly)
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_insert <- function(trie, ip, value) {
  invisible(.Call(Rinsert, trie=trie, ip=ip, value=value))
  # invisible(.Call("Rinsert", trie=trie, ip=ip, value=value, PACKAGE = "iptrie"))
}

#' Remove a trie entry for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' Removes a trie entry for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' @md
#' @param trie a trie created with [iptrie_create()]
#' @param ip an IPv4 address with mask (will use `/32` if not provided)
#' @return `NULL` (invisibly)
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_remove <- function(trie, ip) {
  invisible(.Call(Rlookup, trie=trie, entry=ip))
  # invisible(.Call("Rlookup", trie=trie, entry=ip, PACKAGE = "iptrie"))
}

#' Destroy an IP trie
#'
#' Destroies an IP trie
#'
#' @md
#' @param trie a trie created with [iptrie_create()]
#' @return `NULL` (invisibly)
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_destroy <- function(trie) {
  invisible(.Call(Rdestroy, trie=trie))
  # invisible(.Call("Rdestroy", trie=trie, PACKAGE = "iptrie"))
}
