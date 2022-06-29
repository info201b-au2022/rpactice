#' @version ps-1
#' @short DS-7-1
#' @title Creating and operating on vectors
#' @descr
#' Exercise 7.1 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg
#' Create a vector `names` that contains the names of three people,
#' namely "Alex," "Drew," and "Jordan." Be sure to print out the vector
#' with the command `print(names)`.
#' @end
#' @code
names <- c("Alex", "Drew", "Jordan")
#' @end

#' @id ?
#' @msg
#' Use the colon operator : to create a vector, named `n`, of numbers from 10 to 49.
#' @end
#' @code
n <- 10:49
#' @end

#' @id ?
#' @msg
#' Use the `length()` function to get the number of elements in `n`.  Assign the length
#' to the variable n_len
#' @end
#' @code
n_len <- length(n)
#' @end

#' @id ?
#' @msg
#' Add 1 to each element in `n`. Assign this new vector to `n1`.
#' @end
#' @code
n1 <- n + 1
#' @end

#' @id ?
#' @msg
#' Create a vector `m` that contains the numbers 10 to 1 (in that order).
#' Hint: use the `seq()` function.
#' @end
#' @code
m <- seq(10,1)
#' @end

#' @id ?
#' @msg
#' Subtract `m` FROM `n`. Assign the new vector to v1. Note the recycling!
#' @end
#' @code
v1 <- n - m
#' @end

#' @id ?
#' @msg
#' Use the `seq()` function to produce a range of numbers from -5 to 10 in `0.1`
#' increments. Store it in a variable `x_range`
#' @end
#' @code
x_range <- seq(-5, 10, 0.1)
#' @end

#' @id ?
#' @msg
#' Create a vector `sin_wave` by calling the `sin()` function on each element
#' in `x_range`. `
#' @end
#' @code
sin_wave <- sin(x_range)
#' @end

#' @id ?
#' @msg
#' Create a vector `cos_wave` by calling the `cos()` function on each element
#' in `x_range`.
#' @end
#' @codes
cos_wave <- cos(x_range)
#' @end

#' @id ?
#' @msg
#' Create a vector `wave` by multiplying `sin_wave` and `cos_wave` together, then
#' adding `sin_wave` to the product
#' @end
#' @code
wave <- (sin_wave * cos_wave) + sin_wave
#' @end

#' @id -
#' @msg
#' Use the `plot()` function to plot your `wave`!
#' @end

