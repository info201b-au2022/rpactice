#' @version ps-1
#' @short DS-6-2
#' @title Using built-in string functions
#' @descr
#' #' Exercise 6.2 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg
#' Create a variable `lyric` that contains the text "I like to eat apples and
#' bananas"
#' @end
#' @code
lyric <- "I like to eat apples and bananas"
#' @end
#'
#' @id ?
#' @msg
#' Use the `substr()` function to extract the 1st through 13th letters from the
#' `lyric`, and store the result in a variable called `intro`.  (Hint: Use `?substr` to see
#' more about this function.)
#' @end
#' @code
intro <- substr(lyric,1,13)
#' @end
#'
#' @id ?
#' @msg
#' Use the `substr()` function to extract the 15th through the last letter of the
#' `lyric`, and store the result in a variable called `fruits`. (Hint: use `nchar()` to
#' determine how many total letters there are!)
#' @end
#' @code
fruits <- substr(lyric,15,nchar(lyric))
#' @end

#' @id ?
#' @msg
#' Use the `gsub()` function to substitute all the "a"s in `fruits` with "ee".
#' Store the result in a variable called `fruits_e`. (Hint: see
#' http://www.endmemo.com/program/R/sub.php for a simple example or use
#' `?gsub`.)
#' @end
#' @code
fruits_e <- gsub("a","ee", fruits)
#' @end

#' @id ?
#' @msg
#' Use the `gsub()` function to substitute all the "a"s in `fruits` with "o".
#' Store the result in a variable called `fruits_o`.
#' @end
#' @code
fruits_o <- gsub("a","o", fruits)
#' @end

#' @id ?
#' @msg
#' Create a new variable `lyric_e` that is the `intro` combined with the new
#' `fruits_e` ending. Print out this variable.
#' @end
#' @code
lyric_e <- paste(intro, fruits_e)
print(fruits_e)
#' @end

#' @id -
#' @msg
#' Without making a new variable, print out the `intro` combined with the new
#' `fruits_o` ending.
#' @end
#' @code
print(paste(intro, fruits_o))
#' @end
