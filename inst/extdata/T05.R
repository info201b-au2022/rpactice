#' @version ps-1
#' @short T05
#' @title Test cases: Functions
#' @descr
#' Test statements that return functions (including the @check tag)
#' @end
#' @initial-vars
g <- function(x) {return(x+1)}
X <- c(1,2,3,4,5,6)
#' @end

#' @id ?
#' @msg Call the pre-installed function, g(x), with ten. Does this result make sense?
#' @code
t01 <- g(10)  #A: 11
#' @end

#' @id ?
#' @msg Write a function, named `what_is_pi()`, which returns pi (3.1415). [f()]
#' @code
what_is_pi <- function() {
  return(pi)
}
#' @end

#' @id ?
#' @msg Write a function, named `squared` that takes one numeric argument and squares the number. [f(arg1)]
#' @var squared
#' @check list(arg1=c(1, 2, 3, 0, -1, -2, -3, NA))
#' @code
squared <- function(x) {
  t <- x^2
  return(t)
}
#' @end

#' @id ?
#' @msg Use the function, `squared()`, to test that it works for the number 100.
#' @code
t02 <- squared(100)
#' @end

#' @id ?
#' @msg A function with two parameters
#' @check list(arg1=c("aaa", "bbb", "ccc"), arg2=c("xxx", "aaa", "zzz"))
#' @code
f1 <- function(arg_one, arg_two) {
  return (arg_one == arg_two)
}
#' @end

#' @id ?
#' @msg Callback: Test a function with two arguments - correctness is tested with a callback (see g.T03_Check()) [f(arg1,arg2)]
#' @code
h <- function(arg1, precision) {
  t <- round(arg1 + pi, precision)
  return(t)
}
#' @end

#' @id ?
#' @msg Update X[3] to 200
#' @code
X[3] <- 200
#' @end

#' @id ?
#' @msg Update v[3] to 200 with a function, named f_update
#' @check list(arg1=list(v<-c(1,2,3,4,5)))
#' @code
f_update <- function(v) {
  v[3] <- 200
  return(v)
}
#' @end
