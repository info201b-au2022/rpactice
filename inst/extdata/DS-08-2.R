#' @version ps-1
#' @short DS-08-2
#' @title Using `*apply()` function
#' @descr
#' Exercise 8.2 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
random_nums1 <- c(45.061645, 55.431745, 27.627803, 3.912747, 12.678429, 15.237589, 61.714670, 61.171740, 92.668415, 54.066513)
#' @end

#' @id ?
#' @msg
#' The variable `random_nums1` contains 10 random numbers between 1 and
#' 100. Use the function `as.list()` to convert `random_nums1` into
#' a list. Assign your list to a variable named `nums1`.
#' @end
#' @code
nums1 <- as.list(random_nums1)
#' @end

#' @id ?
#' @msg
#' Use `lapply()` to apply the `round()` function to each number, rounding it to
#' the nearest 0.1 (one decimal place).
#' @end
#' @code
nums1_rounded <- lapply(nums1, round, 1)
#' @end

#' @id -
#' @msg
#' (1) Create a *list* of 100 random numbers. Use the `runif()` function to make a
#' vector of random numbers, then use `as.list()` to convert that to a list.
#' assign your list to a variable named `nums`.
#'
#' (2) Use `lapply()` to apply the `round()` function to each number, rounding it to
#' the nearest 0.1 (one decimal place).
#' @end

#' @id ?
#' @msg
#' Create a variable, named `sentence`, that contains a sentence of text (something
#' longish). For the purpose of evaluating your code, use this sentence:
#'    "I do not like green eggs and ham. I do not like them, Sam-I-Am".
#' @end
#' @code
sentence <- "I do not like green eggs and ham. I do not like them, Sam-I-Am"
#' @end

#' @id ?
#' @msg
#' Create a variable, named `sentence_lcase`, that converts the string to all
#' lower case.
#' @end
#' @code
sentence_lcase <- tolower("I do not like green eggs and ham. I do not like them, Sam-I-Am")
#' @end
#'

#' @id ?
#' @msg
#' Use the `strsplit()` function to split the sentence into a vector of letters.
#' Hint: split on `""` to split every character. Note: this will return
#' a _list_ with 1 element (which is the vector of letters).
#' @end
#' @code
letters_list <- strsplit(sentence_lcase, "")
#' @end

#' @id ?
#' @msg
#' Extract the vector of letters from the resulting list
#' @end
#' @code
letters <- letters_list[[1]]
#' @end

#' @id ?
#' @msg
#' Use the `unique()` function to get a vector of unique letters
#' @end
#' @code
letters_unique <- unique(letters)
#' @end

#' @id ?
#' @msg
#' Define a function `count_occurrences` that takes in two parameters: a letter
#' and a vector of letters. The function should return how many times that letter
#' occurs in the provided vector.
#' Hint: use a filter operation!
#' @end
#' @code
count_occurrences <- function(letter, all_letters) {
  # Approach 1:
  #s <- length(all_letters[all_letters == letter])

  # Approach 2:
  t <- all_letters == letter
  s <- sum(t)
  return(s)
}
#' @end

#' @id ?
#' @msg
#' Call your `count_occurrences()` function to see how many times the letter 'e'
#' is in your sentence.
#' @end
#' @code
num_e <- count_occurrences("e", letters)
#' @end

#' @id ?
#' @msg
#' Use `sapply()` to apply your `count_occurrences()` function to each unique
#' letter in the vector to determine their frequencies.
#' Convert the result into a list (using `as.list()`).
#' @end
#' @code
frequencies <- as.list(sapply(letters_unique, count_occurrences, letters))
#' @end
