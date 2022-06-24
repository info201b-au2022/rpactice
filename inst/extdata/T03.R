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
#' @msg Call function that is pre-installed
#' @code
t01 <- g(10)  #A: 11
#' @end

#' @id ?
#' @msg Create a function that squares a number
#' @var squared
#' @check c(1, 2, 3, 0, -1, -2, -3, NA)
#' @code
squared <- function(x) {
  t <- x^2
  return(t)
}
#' @end

#' @id ?
#' @msg Use the function
#' @code
t02 <- squared(100)
#' @end

#' @id ?
#' @msg Test a function with a vector of inputs
#' @var f
#' @check c(1, 1000, 10, 0, -1, NA)
#' @code
f <- function(arg1) {
  t <- arg1 + 1
  return(t)
}
#' @end
#'
#' #' @id ?
#' @msg Test a function with two arguments - and call a callback function (see g.T03_Check())
#' @var h
#' @code
h <- function(arg1, precision) {
  t <- round(arg1 + pi, precision)
  return(t)
}
#' @end
