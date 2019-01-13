#' Lookup a value for an IPv4 Address+CIDR combo into an IPv4 Trie or Test for Existence
#'
#' Looks up a value for or tests existence of an IPv4 Address+CIDR combo into an IPv4 Trie.
#' This is somewhat promiscuous as it uses `iptree_lookup_best_str()` from the
#' underlying C library vs `iptree_lookup_exact()`
#'
#' @md
#' @param trie a trie created with [iptrie_create()]
#' @param ip an IPv4 address with mask (will use `/32` if not provided)
#' @param precision If "`best`" (the default) then the closest match is
#'        returned. This is useful when the trie is full of CIDRs and
#'        you're trying to test if an IP addressin a CIDR. Using "`exact`"
#'        will force a test for an exact match (i.e. both the IP address
#'        and mask have to match).
#' @return length 1 character vector with attributes `ip`, `ipn`, and `mask`, or `NULL`
#' @export
iptrie_lookup <- function(trie, ip, precision = c("best", "exact")) {
  precision <- match.arg(precision[1], c("best", "exact"))
  switch(
    precision,
    best = .Call(Rlookup, trie=trie, ip=ip),
    exact = .Call(Rexact, trie=trie, ip=ip)
  )
  # .Call("Rlookup", trie=trie, ip=ip, PACKAGE = "iptrie")
}

#' @rdname iptrie_lookup
#' @export
#' @examples
#' x <- iptrie_create()
#' iptrie_insert(x, "10.1.10.0/24", "HOME")
#' iptrie_ip_in(x,"10.1.10.1/32")
#' iptrie_ip_in(x,"10.1.11.1/32")
#' iptrie_lookup(x, "10.1.10.1/32")
iptrie_ip_in <- function(trie, ip) {
  !is.null(iptrie_lookup(trie, ip, "best"))
}
