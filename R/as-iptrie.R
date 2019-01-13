#' Convert a data frame to an IP trie
#'
#' Pass in a data frame with column 1 full of IP addresses or CIDRs and
#' a column 2 full of character values and this will convert it to an
#' IP trie. You can use the `...` to positionally identify the column
#' names you want (as strings) to select.
#'
#' @md
#' @export
#' @param x a data frame with at least two columns. Unless you pass
#'        two string column names via `...` the first two columns
#'        in the data frame will be used.
#' @export
#' @examples
#' xdf <- data.frame(a = "10.1.10.0/24", b = "HOME", stringsAsFactors = FALSE)
#' asip_trie(xdf)
as_iptrie <- function(x, ...) {

  stopifnot(is.data.frame(x))

  use_names <- list(...)

  df_names <- colnames(x)

  if (length(use_names) > 0) {
    if (length(use_names) != 2) {
      stop("Two names required when specifying columns to use.", call.=FALSE)
    } else {
      use_names <- unlist(use_names, use.names = FALSE)
      if (!(all(use_names %in% df_names))) {
        stop("One or more specified columns not found.", call.=FALSE)
      }
    }
  } else {
    if (length(x) < 2)  stop("Data frame requires two columns.", call.=FALSE)
    use_names <- df_names[1:2]
    message(
      "Using '", use_names[1], "' for IP/CIDR and '", use_names[2],
      "' for data/value."
    )
  }

  ctree <- iptrie_create()

  for (i in 1:nrow(x)) {
    iptrie_insert(
      trie = ctree,
      ip = as.character(x[[use_names[1]]][i]),
      value = as.character(x[[use_names[2]]][i])
    )
  }

  ctree

}
