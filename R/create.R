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
#' iptrie_ip_exists(x,"10.1.10.1/32")
#' iptrie_ip_exists(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_create <- function() {
  .Call("Rcreate", PACKAGE = "iptrie")
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
#' iptrie_ip_exists(x,"10.1.10.1/32")
#' iptrie_ip_exists(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_insert <- function(trie, ip, value) {
  invisible(.Call("Rinsert", trie=trie, ip=ip, value=value, PACKAGE = "iptrie"))
}

#' Lookup a value for an IPv4 Address+CIDR combo into an IPv4 Trie or Test for Existence
#'
#' Looks up a value for or tests existence of an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' @md
#' @param trie a trie created with [iptrie_create()]
#' @param ip an IPv4 address with mask (will use `/32` if not provided)
#' @return character vector or `NULL`
#' @export
iptrie_lookup <- function(trie, ip) {
  .Call("Rlookup", trie=trie, ip=ip, PACKAGE = "iptrie")
}

#' @rdname iptrie_lookup
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_exists(x,"10.1.10.1/32")
#' iptrie_ip_exists(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_ip_exists <- function(trie, ip) {
  !is.null(iptrie_lookup(trie, ip))
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
#' iptrie_ip_exists(x,"10.1.10.1/32")
#' iptrie_ip_exists(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_remove <- function(trie, ip) {
  invisible(.Call("Rlookup", trie=trie, entry=ip, PACKAGE = "iptrie"))
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
#' iptrie_ip_exists(x,"10.1.10.1/32")
#' iptrie_ip_exists(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_destroy <- function(trie) {
  invisible(.Call("Rdestroy", trie=trie, PACKAGE = "iptrie"))
}
