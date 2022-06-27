#' Practice Set Example
#' @version ps-1
#' @short P03
#' @title Using vectors and basic functions
#' @descr
#' Check into length() and sum()
#' @end
#' @initial-vars
X <- c(1,2,3,4)
#' @end

#' @id ?
#' @msg How many elements are in the vector X?
#' @code
num <- length(X)
#' @end

#' @id ?
#' @msg Use a function to compute the sum of the numbers in vector X?
#' @code
sum_of_X <- sum(X)
#' @end

#' @id ?
#' @msg Create a vector with these three elements: 1, 2, 3.
#' @code
v1 <- c(1,2,3)
#' @end

#' @id ?
#' @msg Add 5 to each element of the vector X.
#' @code
v2 <- X + 5
#' @end

#' @id ?
#' @msg Make a function
#' @code
f <- function(x) {10 * x}
#' @end
