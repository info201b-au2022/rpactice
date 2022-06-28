#' @version ps-1
#' @short DS-8-2
#' @title Using `*apply()` function
#' @descr
#' Exercise 6.4 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end


#' @id ?
#' @msg
# Create a *list* of 10 random numbers. Use the `runif()` function to make a
# vector of random numbers, then use `as.list()` to convert that to a list
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Use `lapply()` to apply the `round()` function to each number, rounding it to
# the nearest 0.1 (one decimal place)
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Create a variable 'sentence' that contains a sentence of text (something
# longish). Make the sentence lowercase; you can use a function to help.
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Use the `strsplit()` function to split the sentence into a vector of letters.
# Hint: split on `""` to split every character
# Note: this will return a _list_ with 1 element (which is the vector of letters)
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Extract the vector of letters from the resulting list
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Use the `unique()` function to get a vector of unique letters
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Define a function `count_occurrences` that takes in two parameters: a letter
# and a vector of letters. The function should return how many times that letter
# occurs in the provided vector.
# Hint: use a filter operation!
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Call your `count_occurrences()` function to see how many times the letter 'e'
# is in your sentence.
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Use `sapply()` to apply your `count_occurrences()` function to each unique
# letter in the vector to determine their frequencies.
# Convert the result into a list (using `as.list()`).
#' @end
#' @code
xxx
#' @end

#' @id ?
#' @msg
# Print the resulting list of frequencies
#' @end
#' @code
xxx
#' @end
