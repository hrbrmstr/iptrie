context("Core IP trie ops work")
test_that("we can do something", {

  x <- iptrie_create()
  expect_true(!is.null(x))

  expect_true(is_iptrie((iptrie_insert(x, "10.1.10.0/24", "HOME"))))

  expect_true(iptrie_ip_in(x,"10.1.10.1/32"))
  expect_false(iptrie_ip_in(x,"10.1.11.1/32"))

  xpct <- "HOME"
  attr(xpct, "ip") <- "10.1.10.0"
  attr(xpct, "ipn") <- 167840256
  attr(xpct, "mask") <- 24

  expect_equal(iptrie_lookup(x, "10.1.10.1/32"), xpct)

  expect_null(iptrie_lookup(x, "10.1.10.1/32", "exact"))

  xdf <- data.frame(a = "10.1.10.0/24", b = "HOME", stringsAsFactors = FALSE)

  xt <- as_iptrie(xdf)

  expect_true(is_iptrie(xt))

})
