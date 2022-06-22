
# testthat::test_file("tests/testthat/test-eval.R")


test_that("xxx", {
  ps <- ps_get_by_short("P01")
  expect_equal(eval_string("1+4"), 5)
  expect_equal(as.character(eval_string("1+4")),"5")
})

statement <- "t <-1"
r <- eval_string_details(statement)

test_that("Basic numeric", {
  expect_equal(r$ok, TRUE)
  expect_equal(r$type, "double")
  expect_equal(r$value, 1)
})

statement <- "f <- function(x) {return(x+1)}"
r <- eval_string_details(statement)

test_that("Basic function", {
  expect_equal(r$ok, TRUE)
  expect_equal(r$type, "closure")
})

statement <-
"
squared <- function(arg1) {
  s <- arg1^2
  return(s)
}
"
r <- eval_string_details(statement)
test_that("Basic function", {
  expect_equal(r$ok, TRUE)
  expect_equal(r$type, "closure")
})

statement <-
  "squared <- function(arg1) {arg1^2}"
r <- eval_string_details(statement)
test_that("Basic function", {
  expect_equal(r$ok, TRUE)
  expect_equal(r$type, "closure")
})
