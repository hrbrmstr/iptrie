# Coerece an iptrie to a data frame
#
# @md
# @param x an `iptrie`
# @param ... unused
# @param stringsAsFactors always `FALSE` so this is ignored even if `TRUE`
# @export
# as.data.frame.iptrie <- function(x, ..., stringsAsFactors = FALSE) {
#
#   stopifnot(is_iptrie(x))
#
#   do.call(
#     rbind.data.frame,
#     lapply(y, function(.x) {
#       r <- iptrie_lookup(asntrie, .x, "best")
#       if (is.null(r)) {
#         data.frame(
#           ip = .x,
#           asn = NA_character_,
#           cidr = NA_character_,
#           stringsAsFactors = FALSE
#         )
#       } else {
#         data.frame(
#           ip = .x,
#           asn = r,
#           cidr = sprintf("%s/%d", attr(r, "ip"), attr(r, "mask")),
#           stringsAsFactors = FALSE
#         )
#       }
#     })
#   ) -> cdf
#
# }