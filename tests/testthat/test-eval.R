practice.begin("T01")


test_that("xxx", {
  ps <- ps_get_by_short("P01")
  expect_equal(eval_string("1+4"), 5)
  expect_equal(as.character(eval_string("1+4")),"5")
})
