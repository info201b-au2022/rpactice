#' @version ps-1
#' @short T03
#' @title Test cases: Functions
#' @descr
#' Test statements that return functions (including the @check tag)
#' @end
#' @initial-vars
g <- function(x) {return(x+1)}
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

#'
#' #' @id ?
#' @msg Test a function with two arguments - correctness is tested with a callback (see g.T03_Check()) [f(arg1,arg2)]
#' @var h
#' @code
h <- function(arg1, precision) {
  t <- round(arg1 + pi, precision)
  return(t)
}
#' @end
