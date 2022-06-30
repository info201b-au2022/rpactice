


statement <-  "seq(1:100)"
r <- eval_string_details(statement)




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
  expect_equal(t, "list: [2]")
})

statement <- "t <- 1; x <- t + 1; y <- x + 1"
t <- eval_string_and_format(statement)
test_that("Three statements with semi-colons.", {
  expect_equal(t, "atomic [1]: 3")
})

statement <- c("t <- 1", "x <- t + 1", "y <- x + 1")
t <- eval_string_and_format(statement)
test_that("Three statements in a vector.", {
  expect_equal(t, "atomic [1]: 3")
})

statement <- "t <- 1\n x <- t + 1\n y <- x + 1"
t <- eval_string_and_format(statement)
test_that("Three statements with semi-colons.", {
  expect_equal(t, "atomic [1]: 3")
})


#----------------------------------------------------------------------------#
# Test ast functions
#----------------------------------------------------------------------------#
t <- "m<-2; print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- 1; print('hello')"
line_nums <- ast_scan(parse(text=t), c("print", "cat"), FALSE)
test_that("ast functions", {
  expect_equal(line_nums, c(1,5))
})

t <- "m<-2; print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- 1; print('hello')"
line_nums <- ast_scan(parse(text=t), c("print", "cat"))
test_that("ast functions", {
  expect_equal(line_nums, c(2,3,4,6))
})

t <- "m<-2; print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- 1; print('hello')"
e2 <- ast_rm(parse(text=t),line_nums)
test_that("ast functions", {
  expect_equal(deparse(e2[[1]]), "m <- 2")
  expect_equal(deparse(e2[[2]]), "u <- 1")
})

t <-
"
t <- 1
u <- 2; v <-3
cat(t, u)
w<- x <- 4
y<-5
"

e2 <- parse(text=t)
line_nums <- ast_scan(e2,"<-")
test_that("ast functions", {
  expect_equal(length(line_nums), 5)
  expect_equal(deparse(e2[[3]]), "v <- 3")
  expect_equal(deparse(e2[[5]]), "w <- x <- 4")
})

t <-
"
t[1] <- 10
"

e2 <- parse(text=t)
line_nums <- ast_scan(e2,"<-")
test_that("ast functions", {
  expect_equal(length(line_nums), 1)
  expect_equal(deparse(e2[[1]]), "t[1] <- 10")
})


t <-
  "
practice.begin()
t <- 1
u <- 2; v <-3
cat(t, u)
w<- x <- 4
y<-5
practice.check()
"
e2 <- parse(text=t)
r <- ast_get_assignments(e2)
test_that("ast functions", {
  expect_equal(length(r), 5)
  expect_equal(r[[3]]$lhs, "v")
  expect_equal(r[[4]]$lhs, "w")
})

t <-
"
t[3] <- 'aaa'
phone_numbers3[phone_numbers3%%2==1] <- 0
u <- 10
"

e2 <- parse(text=t)
r <- ast_get_assignments(e2)
test_that("ast functions", {
  expect_equal(length(r), 3)
  expect_equal(r[[1]]$lhs, "t")
  expect_equal(r[[1]]$rhs, "\"aaa\"")
  expect_equal(r[[2]]$lhs, "phone_numbers3")
  expect_equal(r[[2]]$rhs, "0")
  expect_equal(r[[3]]$lhs, "u")
  expect_equal(r[[3]]$rhs, "10")
})



t <-
  "
practice.begin()
t <- 1
u <- 2; v <-3
cat(t, u)
w<- x <- 4
y<-5
practice.check()
"
e2 <- parse(text=t)
r <- ast_get_assignments(e2)
test_that("ast functions", {
  expect_equal(length(r), 5)
  expect_equal(r[[3]]$lhs, "v")
  expect_equal(r[[4]]$lhs, "w")
})

r <- ast_last_assignment(e2)
test_that("ast functions", {
  expect_equal(r$lhs, "y")
})

t <-
"
practice.begin()
t <- 1
u <- 2; v <-3
cat(t, u)
w<- x <- 4
y<-5
practice.check()
"
e2 <- parse(text=t)
r <- ast_scan(e2,c("practice.begin", "practice.check", "practice.answers", "practice.qustions", "load_url"))
test_that("ast functions", {
  expect_equal(length(r),2)
  expect_equal(r[1], 1)
  expect_equal(r[2], 8)
})

t <-"
practice.begin()
practice.check()
practice.questions()
practice.answers()
practice.load_url()"
e2 <- parse(text=t)
r <- ast_scan(e2,c("practice.begin", "practice.check", "practice.answers", "practice.questions", "practice.load_url"))
test_that("ast functions", {
  expect_equal(length(r),5)
})

t <-""
e2 <- parse(text=t)
r <- ast_scan(e2,c("practice.begin", "practice.check", "practice.answers", "practice.questions", "practice.load_url"))
test_that("ast functions", {
  expect_equal(length(e2),0)
  expect_equal(length(r),0)
})

#testthat::test_file("tests/testthat/test-eval.R")
