#' Create a new IPv4 Trie
#'
#' Creates a new IPv4 Trie
#'
#' @md
#' @return an external pointer to an IP trie
#' @export
#' @return an `iptrie`
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_create <- function() {
  .Call(Rcreate)
}

#' @rdname iptrie_create
#' @export
#' @param x an `iptrie`
is_iptrie <- function(x) {
  if (inherits(x, "iptrie")) {
    if (is_null_xptr(x)) {
      message("Object was a populated iptrie but is now an invalid xptr")
      FALSE
    } else {
      TRUE
    }
  } else {
    FALSE
  }
}

#' Print for iptrie
#'
#' @md
#' @param x an iptrie
#' @param ... ignored
#' @keywords internal
#' @return `trie` (invisibly)
#' @export
print.iptrie <- function(x, ...) {
  if (is_null_xptr(x)) {
    cat("<iptree (null/invalid)>\n")
  } else {
    cat("<iptrie>\n")
  }
  invisible(x)
}

#' Insert a value for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' Inserts a value for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' @md
#' @param trie a trie created with [iptrie_create()]
#' @param ip an IPv4 address with mask (will use `/32` if not provided)
#' @param value character value to store
#' @return `trie` (invisibly)
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_insert <- function(trie, ip, value) {
  stopifnot(!is_null_xptr(trie))
  .Call(Rinsert, trie=trie, ip=ip, value=value)
  invisible(trie)
}

#' Remove a trie entry for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' Removes a trie entry for an IPv4 Address+CIDR combo into an IPv4 Trie
#'
#' @md
#' @param trie a trie created with [iptrie_create()]
#' @param ip an IPv4 address with mask (will use `/32` if not provided)
#' @return `trie` (invisibly)
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_remove <- function(trie, ip) {
  stopifnot(!is_null_xptr(trie))
  .Call(Rlookup, trie=trie, entry=ip)
  invisible(trie)
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
  if (!is_null_xptr(trie)) invisible(.Call(Rdestroy, trie=trie))
  # invisible(.Call("Rdestroy", trie=trie, PACKAGE = "iptrie"))
}

