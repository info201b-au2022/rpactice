#' @version ps-1
#' @short DS-05-1
#' @title Practice with basic R syntax
#' @descr
#' Exercise 5.1 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg Create a variable `hometown` that stores the city in which you were born
#' @check list(re="^[a-zA-Z\\s\\.]*$")
#' @code
hometown <- "St. Louis"
#' @end

#' @id ?
#' @msg Assign your name to the variable `my_name`
#' @check list(re="^[a-zA-Z\\s]*$")
#' @code
my_name <- "Mike"
#' @end

#' @id ?
#' @msg Assign your height (in inches) to a variable `my_height`
#' @check list(re="^[0-9]+(\\.[0-9]+)$")
#' @code
my_height <- 73.5
#' @end

#' @id ?
#' @msg Create a variable `puppies` equal to the number of puppies you'd like to have. Let's assume 5 puppies!
#' @check list(re="^[0-9]$")
#' @code
puppies <- 5
#' @end

#' @id ?
#' @msg Create a variable `puppy_price`, which is how much a puppy costs. Assume puppies cost $250.00.
#' @check list(re="^.*$")
#' @code
puppy_price <- 250.00
#' @end

#' @id ?
#' @msg Create a variable `total_cost` that has the total cost of all of your puppies
#' @code
total_cost <- puppies * puppy_price
#' @end

#' @id ?
#' @msg Create a boolean variable `too_expensive`, set to TRUE if the cost is greater than $1,000
#' @code
too_expensive <- total_cost > 1000
#' @end

#' @id ?
#' @msg Create a variable `max_puppies`, which is the number of puppies you can afford for $1,000
#' @code
max_puppies <- 1000%/%puppy_price
#' @end
