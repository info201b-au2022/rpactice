#' @version ps-1
#' @short PS-Example
#' @title Example practice set
#' @descr
#' This file illustrates the essentials of specifying a practice set. It is
#' intended to informally show what kinds of prompts can be presented to
#' students and what kind of testing can be accomplished.
#' @end
#' @initial-vars
library(dplyr)
X <- c(1,2,3)
cDF <- data.frame(A=c(1,2,3,4), B=c('a','b','c','d'), C=c(T,F,T,T))
#' @end

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
#' @msg Add 10 to each of the elements of vector X.
#' @code
v1 <- X + 10
#' @end

#' @id -
#' @msg Working with functions

#' @id c
#' @msg Write a function, named `what_is_pi` which returns pi (3.1415).
#' @var what_is_pi
#' @code
what_is_pi <- function() {
pi
}
#' @end

#' @id d
#' @msg Create a function that squares a number.
#' @var squared
#' @check list(arg1 = c(1, 2, 3, 0, -1, -2, -3, NA))
#' @code
squared <- function(x) {
  t <- x^2
  return(t)
}
#' @end

#' @id e
#' @msg
#' Define a function, named `imperial_to_metric`, that takes in two arguments: a
#' number of feet and a number of inches. The function should return the
#' equivalent length in meters.
#' @end
#' @check list(arg1 = c(4, 5, 100, 0, NA), arg2 = c(0, 1, 1.5, 12.0, 24))
#' @code
imperial_to_metric <- function(feet, inches) {
  total_inches <- feet * 12 + inches
  meters <- total_inches * 0.0254
  meters
}
#' @end

#' @id -
#' @msg Working with dataframes

#' @id f
#' @msg Select rows from cDF, where C==TRUE. Show only A and C columns.
#' @code
df4 <- cDF %>%
  filter(C==TRUE) %>%
  select(A,C)
#' @end
