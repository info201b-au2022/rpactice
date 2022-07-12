#' @version ps-1
#' @short PS-Example
#' @title Example practice set
#' @descr
#' This file illustrates the essentials of specifying a practice set. It
#' show what kinds of prompts can be presented to #' students and what can be
#' tested.
#' @end
#' @initial-vars
library(stats)
X <- c(1,2,3)
#' @end

#' @id -
#' @msg
#' A practice set that illustrates the basics.
#' @end

#' @id a
#' @msg Add ten, nine, and eight together. Assign the result to `sum1`.
#' @code
sum1 <- 10 + 9 + 8
#' @end
#' @hints
#' Do you use the math plus operator (+)?
#' Do you use the assignment operator (<-)?
#' Is the expected variable name (sum1) used?
#' @end

#' @id b
#' @msg
#' Create a variable `hometown` that stores the city in which you were born.
#' @end
#' @check list(re="^[a-zA-Z\\s\\.]*$")
#' @code
hometown <- "St. Louis"
#' @end

#' @id c
#' @msg Add 10 to each of the elements of vector `X`.
#' @code
v1 <- X + 10
#' @end

#' @id d
#' @msg
#' Create 100 random numbers between 40000 and 50000. Round the numbers
#' to two decimal places.
#' @end
#' @cp-var salaries_2017
#' @code
salaries_2017 <- round(runif(100, 40000, 50000),2)
#' @end

#' @id -
#' @msg Working with functions.
#'
#' @id e
#' @msg Write a function, named `what_is_pi`, which returns pi (3.1415).
#' @var what_is_pi
#' @code
what_is_pi <- function() {pi}
#' @end

#' @id f
#' @msg Write a function, named `squared(x)`, which squares a number.
#' @var squared
#' @check list(arg1 = c(1, 2, 3, 0, -1, -2, -3, NA))
#' @code
squared <- function(x) {
   t <- x^2
   return(t)
}
#' @end

#' @id g
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
   return(meters)
}
#' @end
