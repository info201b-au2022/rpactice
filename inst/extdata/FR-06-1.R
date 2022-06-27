#' @version ps-1
#' @short FR-06-1
#' @title Book: 06: Exercise 1: Calling built-in functions
#' @descr
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg Create a variable `my_name` that contains "Grace Hopper".
#' @code
my_name <- "Grace Hopper"
#' @end

#' @id ?
#' @msg
#' Create a variable `name_length` that holds how many letters (including spaces)
#' are in your name (use the `nchar()` function).
#' @end
#' @code
name_length <- nchar(my_name)
#' @end

#' @id -
#' @msg Print the number of letters in `your name`my_name`

#' @id ?
#' @msg
#' Create a variable `now_doing` that is your name followed by "is programming!"
#' (use the `paste()` function)
#' @end
#' @code
now_doing <- paste(my_name, "is programming!")
#' @end

#' @id ?
#' @msg Make the `now_doing` variable upper case
#' @code
now_doing <- toupper(now_doing)
#' @end

#' @id -
#' @msg Bonus

#' @id ?
#' @msg Pick two numbers -- say 51 and 76 -- and assign the variables to `fav_1` and `fav_2`
#' @code
fav_1 <- 51
fav_2 <- 76
#' @end

#' @id -
#' @msg
#' Create two variables - `fav_1` and `fav_2` - and, respectively, assign 51 and 76  to
#' these variables.

#' @id -
#' @msg
#' Divide each of the variables - `fav_1` and `fav_2` - by the square root of 201 and save
#' the new values in the original variables.
#' @end

#' @id ?
#' @msg
#' Create a variable `raw_sum` that is the sum of the two variables. Use the
#' `sum()` function for practice.
#' @end
#' @code
raw_sum <- sum(fav_1, fav_2)
#' @end

#' @id ?
#' @msg
#' Create a variable `round_sum` that is the `raw_sum` rounded to 1 decimal place.
#' Use the `round()` function.
#' @end
#' @code
round_sum <- round(raw_sum,1)
#' @end

#' @id -
#' @msg
#' Create two new variables `round_1` and `round_2` that are your `fav_1` and
#' `fav_2` variables rounded to 1 decimal places
#' @end

#' @id -
#' @msg Create a variable `sum_round` that is the sum of the rounded values
#' @end
#' @code
sum_round <- round(fav_1,1) + round(fav_2,1)
#' @end

#' @id -
#' @msg Which is bigger, `round_sum` or `sum_round`? Assign your answer to the variable `bigger`. (You can use the `max()` function!)
#' @end
#' @code
bigger <- max(round_sum, sum_round)
#' @end
