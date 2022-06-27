#' @version ps-1
#' @short DS-6-3
#' @title Writing and executing functions
#' @descr
#' Exercise 6.3 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg
#' Define a function `add_three` that takes a single argument and
#' returns a value 3 greater than the input.
#' @end
#' @check list(arg1=c(-10,0,10,NA))
#' @code
add_three <- function(value) {
   value + 3 # return the result
}
#' @end

#' @id ?
#' @msg
#' Create a variable `ten` that is the result of passing 7 to your `add_three` function.
#' @end
#' @code
ten <- add_three(7)
#' @end

#' @id ?
#' @msg
#' Define a function `imperial_to_metric` that takes in two arguments: a number
#' of feet and a number of inches. The function should return the equivalent
#' length in meters.
#' @end
#' @check list(arg1=c(4,5,100,0,NA), arg2=c(0,1,1.5,12.0,24))
#' @code
imperial_to_metric <- function(feet, inches) {
   total_inches <- feet * 12 + inches
   meters <- total_inches * 0.0254
   meters # return the value in meters
}
#' @end

#' @id ?
#' @msg
#' Create a variable `height_in_meters` by passing your height in imperial to the
#' `imperial_to_metric` function. For testing, assuming you are 5 feet 8 inches tall.
#' @end
#' @code
height_in_meters <- imperial_to_metric(5, 8)
#' @end


