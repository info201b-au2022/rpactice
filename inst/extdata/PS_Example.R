#' @version ps-1
#' @short PS-Example
#' @title Example practice set
#' @descr
#' An example that illustrates the essentials of practice sets.
#' @end
#' @initial-vars
library(dplyr)
X <- c(1,2,3)
cDF <- data.frame(A=c(1,2,3,4), B=c('a','b','c','d'), C=c(T,F,T,T))
#' @end
#'
#' @id a
#' @msg Add ten, nine, and eight together.
#' @code
sum1 <- 10 + 9 + 8
#' @end
#' @hints
#' Do you use the math plus operator (+)?
#' Do you use the assignment operator (<-)?
#' Is the variable name (sum1) correct?
#' @end

#' @id b
#' @msg Add 10 to each of the elements of vector X
#' @code
v1 <- X + 10
#' @end

#' @id ?
#' @msg Create a function that squares a number
#' @var squared
#' @check list(f_checks=c(1, 2, 3, 0, -1, -2, -3, NA))
#' @code
squared <- function(x) {
  t <- x^2
  return(t)
}
#' @end

#' @id ?
#' @msg Select rows from cDF, where C==TRUE. Show only A and C columns.
#' @code
df4 <- cDF %>%
  filter(C==TRUE) %>%
  select(A,C)
#' @end


#' @id -
#' @msg Next: Consider reading up on built-in mathematical functions.
