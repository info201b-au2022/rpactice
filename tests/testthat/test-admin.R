v <- ps_get_all()

test_that("xxx", {
  expect_equal(length(v), 6)
  expect_equal(v[1],"P01")
  expect_equal(v[2],"P03")
})

test_that("xxx", {
  ps <- ps_get_by_short("P01")
  expect_equal(ps$ps_short, "P01")
})

test_that("xxx", {
  ps <- ps_get_by_short("PXXX")
  expect_equal(ps, NULL)
})
