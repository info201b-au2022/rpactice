#' @version ps-1
#' @short DS-07-3
#' @title Vector practice
#' @descr
#' Exercise 7.3 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg
#' Create a vector `words` of 6 (or more) words. You can Google for a "random word generator" if you wish!
#' @end
#' @code
words <- c("convivial", "love", "excitment", "mountains", "fast", "bicycles", "stars")
#' @end

#' @id ?
#' @msg
#' Create a vector `words_of_the_day` that is your `words` vector with the string
#' "is the word of the day!" pasted on to the end.
#' BONUS: Surround the word in quotes (e.g., `'data' is the word of the day!`)
#' Note that the results are more obviously correct with single quotes.
#' @end
#' @code
words_of_the_day <- paste0("\"", words, "\" is the word of the day!", collpase = "")
#' @end

#' @id ?
#' @msg
#' Create a vector `a_f_words` which are the elements in `words` that start with
#' "a" through "f"
#' Hint: use a comparison operator to see if the word comes before "f" alphabetically!
#' Tip: make sure all the words are lower-case, and only consider the first letter
#' of the word!
#' @end
#' @code
a_f_words <- words[substring(words, 1, 1) <= "f"]
#' @end

#' @id ?
#' @msg
#' Create a vector `g_m_words` which are the elements in `words` that start with
#' "g" through "m"
#' @end
#' @code
g_m_words <- words[words >= "g" & substring(words, 1, 1) <= "m"]
#' @end

#' @id ?
#' @msg
#' Define a function `word_bin` that takes in three arguments: a vector of words,
#' and two letters. The function should return a vector of words that go between
#' those letters alphabetically.
#' @end
#' @code
word_bin <- function(words, start, end){
  words[words >= start & substring(words, 1, 1) <= end]
}
#' @end

#' @id ?
#' @msg
#' Use your `word_bin` function to determine which of your words start with "e"
#' through "q". Assign the answer to variable `word_bin_test`.
#' @end
#' @code
word_bin_test <- word_bin(words, "e", "q")
#' @end
