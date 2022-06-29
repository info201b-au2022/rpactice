#' @version ps-1
#' @short DS-7-2
#' @title Indexing and filtering vectors
#' @descr
#' Exercise 6.4 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg
#' Create a vector `first_ten` that has the values 10 through 20 in it (using
#' the : operator).
#' @end
#' @code
first_ten <- 10:20
#' @end

#' @id ?
#' @msg
#' Create a vector `next_ten` that has the values 21 through 30 in it (using the
#' seq() function).
#' @end
#' @code
next_ten <- seq(21,30,1)
#' @end

#' @id ?
#' @msg
#' Create a vector `all_numbers` by combining the previous two vectors.
#' @end
#' @code
all_numbers <- append(first_ten, next_ten)
#' @end

#' @id ?
#' @msg
#' Create a variable `eleventh` that contains the 11th element in `all_numbers`.
#' @end
#' @code
eleventh <- all_numbers[11]
#' @end

#' @id ?
#' @msg
#' Create a vector `some_numbers` that contains the 2nd through the 5th elements
#' of `all_numbers`.
#' @end
#' @code
some_numbers <- all_numbers[2:5]
#' @end

#' @id ?
#' @msg
#' Create a vector `even` that holds the even numbers from 1 to 100.
#' @end
#' @code
even <- seq(2,100,2)
#' @end

#' @id ?
#' @msg
#' Using the `all()` function and `%%` (modulo) operator, confirm that all of the
#' numbers in your `even` vector are even.
#' @end
#' @code
all(seq(2,100,2) %% 2 == 0)
#' @end

#' @id ?
#' @msg
#' Create a vector `phone_numbers` that contains the numbers 8, 6, 7, 5, 3, 0, 9.
#' @end
#' @code
phone_numbers <- c(8,6,7,5,3,0,9)
#' @end

#' @id ?
#' @msg
#' Create a vector `prefix` that has the first three elements of `phone_numbers`.
#' @end
#' @code
prefix <- prefix[1:3]
#' @end

#' @id ?
#' @msg
#' Create a vector `small` that has the values of `phone_numbers` that are
#' less than or equal to 5.
#' @end
#' @code
small <- phone_numbers[phone_numbers<=5]
#' @end

#' @id ?
#' @msg
#' Create a vector `large` that has the values of `phone_numbers` that are
#' strictly greater than 5. "Strictly" mean greater than.
#' @end
#' @code
large <- phone_numbers[phone_numbers > 5]
#' @end

#' @id ?
#' @msg
#' Assign `phone_numbers` to the variable `phone_numbers2`.
#' Replace the values in `phone_numbers2` that are larger than 5 with the number 5.
#' @end
#' @code
phone_numbers2 <- phone_numbers
phone_numbers2[phone_numbers2 > 5] <- 5
#' @end

#' @id ?
#' @msg
#' Assign `phone_numbers2` to the variable `phone_numbers3`. Replace every odd-numbered
#' value in `phone_numbers3` with the number 0.
#' @end
#' @code
phone_numbers3[phone_numbers3%%2==1] <- 0
#' @end
