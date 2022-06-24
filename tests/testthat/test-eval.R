
# testthat::test_file("tests/testthat/test-eval.R")


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

statement <- "1 _ 2"
t <- eval_string_and_format(statement)
test_that("Syntax areas", {
  expect_equal(t, "Error: <text>:1:3: unexpected input 1: 1 _       ^")
})

statement <- "list(a=1, b=TRUE)"
t <- eval_string_and_format(statement)
test_that("Lists are currently unhandled", {
  expect_equal(t, "Type unhandled: list")
})

statement <- "t <- 1; x <- t + 1; y <- x + 1"
t <- eval_string_and_format(statement)
test_that("Three statements with semi-colons.", {
  expect_equal(t, "atomic: 3")
})

statement <- c("t <- 1", "x <- t + 1", "y <- x + 1")
t <- eval_string_and_format(statement)
test_that("Three statements in a vector.", {
  expect_equal(t, "atomic: 3")
})

statement <- "t <- 1\n x <- t + 1\n y <- x + 1"
t <- eval_string_and_format(statement)
test_that("Three statements with semi-colons.", {
  expect_equal(t, "atomic: 3")
})

