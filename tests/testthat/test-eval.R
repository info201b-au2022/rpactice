
#


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


#----------------------------------------------------------------------------#
# Tests of get_var_name() (see util.R)
#----------------------------------------------------------------------------#

t <- get_var_name("t <- 10")
test_that("get_var_name", {
  expect_equal(t$lhs, "t")
})

t <- get_var_name("t <- x <- 10")
test_that("get_var_name", {
  expect_equal(t$lhs, "t")
})

t <- get_var_name("2t <- x <- 10")
test_that("get_var_name", {
  expect_equal(t$lhs, NULL)
})

t <- get_var_name("t <- x <- 10; s <- 100")
test_that("get_var_name", {
  expect_equal(t$lhs, "s")
})

t <- get_var_name("t <- x <- 10\ns <- 100")
test_that("get_var_name", {
  expect_equal(t$lhs, "s")
})

t <- get_var_name("t <- function(a,b) {p <- 10; s <-100} ")
test_that("get_var_name", {
  expect_equal(t$lhs, "t")
})

t <- get_var_name("t <- { s <- 1} ")
test_that("get_var_name", {
  expect_equal(t$lhs, "t")
})

s <- "f3 <- function(x) {
t <- x + 1
return(t)
}"
t <- get_var_name(s)
test_that("get_var_name", {
  expect_equal(t$lhs, "f3")
})

s <-
"
df4 <- cDF %>%
  filter(C==TRUE) %>%
  select(A,C)
"
t <- get_var_name(s)
test_that("get_var_name", {
  expect_equal(t$lhs, "df4")
})

s <- "
df5_f <- function(test) {
  cDF %>%
    filter(C==test) %>%
    select(A,C)
}
"
t <- get_var_name(s)
test_that("get_var_name", {
  expect_equal(t$lhs, "df5_f")
})

s <- "
# hello:
t <- 1 + 4
s <- t - 10
t_03 <- 10 + 9 + 8 + 7 + 6 + 5
"
t <- get_var_name(s)
test_that("get_var_name", {
  expect_equal(t$lhs, "t_03")
})

s <- "
t <- 1 + 4
s <- t - 10
t_03 <- 10 + 9 + 8 + 7 + 6 + 5
#print(0)
#print(t_03)
"
t <- get_var_name(s)
test_that("get_var_name", {
  expect_equal(t$lhs, "t_03")
})

#----------------------------------------------------------------------------#
# Test ast functions
#----------------------------------------------------------------------------#
t <- "m<-2; print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- 1; print('hello')"
line_nums <- ast_scan(parse(text=t), c("print", "cat"), FALSE)
test_that("ast_scan", {
  expect_equal(line_nums, c(1,5))
})

t <- "m<-2; print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- 1; print('hello')"
line_nums <- ast_scan(parse(text=t), c("print", "cat"))
test_that("ast_scan", {
  expect_equal(line_nums, c(2,3,4,6))
})

t <- "m<-2; print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- 1; print('hello')"
e2 <- ast_rm(parse(text=t),line_nums)
test_that("get_var_name", {
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
test_that("get_var_name", {
  expect_equal(length(line_nums), 5)
  expect_equal(deparse(e2[[3]]), "v <- 3")
  expect_equal(deparse(e2[[5]]), "w <- x <- 4")
})


t <-
  "
t <- 1
u <- 2; v <-3
cat(t, u)
w<- x <- 4
y<-5
practice.check()
"
e2 <- parse(text=t)
r <- ast_get_assignments(e2)
test_that("get_var_name", {
  expect_equal(length(r), 5)
  expect_equal(r[[3]]$lhs, "v")
  expect_equal(r[[4]]$lhs, "w")
})

r <- ast_last_assignment(e2)
test_that("get_var_name", {
  expect_equal(r$lhs, "y")
})
#testthat::test_file("tests/testthat/test-eval.R")
