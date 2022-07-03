#' @version ps-1
#' @short DS-10-5
#' @title Large data sets: Baby Name Popularity Over Time
#' @descr
#' Exercise 10.5 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#'
#' #' @id -
#' @msg
#' To work on this practice set, you need to download the file:
#'    `data/female_names.csv`
#'
#' The file located in this GitHub directory:
#'    https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-10-exercises/exercise-5/data
#'
#' Save this file in your working directory, under the directory
#' `data`. Generally, your working directory should be:
#'    ~/Documents/info201
#'
#' So, the file should be located here:
#'    ~/Documents/info201/data/data/female_names.csv
#'
#' Recall that you can check and set your working directory with
#' RStudio and with these commands:
#'    > ?getwd()
#'    > ?setwd()
#' @end

#' @id ?
#' @msg
#' Read in the female baby names data file found in the `data` folder into a
#' variable called `names`. Remember to NOT treat the strings as factors!
#' @end
#' @code
names <- read.csv("data/female_names.csv", stringsAsFactors = FALSE)
#' @end

#' @id ?
#' @msg
#' Create a data frame `names_2013` that contains only the rows for the
#' year 2013.
#' @end
#' @code
names_2013 <- names[names$year == 2013, ]
#' @end

#' @id ?
#' @msg
#' What was the most popular female name in 2013?
#' @end
#' @code
most_popular_name_2013 <- names_2013[names_2013$prop == max(names_2013$prop), "name"]
#' @end

#' @id ?
#' @msg
#' Write a function `most_popular_in_year` that takes in a year as a value and
#' returns the most popular name in that year.
#' @end
#' @code
most_popular_in_year <- function(year) {
  names_year <- names[names$year == year, ]
  most_popular <- names_year[names_year$prop == max(names_year$prop), "name"]
  return(most_popular) # return most popular
}
#' @end

#' @id ?
#' @msg
#' What was the most popular female name in 1994?
#' @end
#' @code
most_popular_1994 <- most_popular_in_year(1994)
#' @end

#' @id ?
#' @msg
#' Write a function `number_in_million` that takes in a name and a year, and
#' returns statistically how many babies out of 1 million born that year have
#' that name. (Hint: Get the popularity percentage, and take that percentage
#' out of 1 million.)
#' @end
#' @code
number_in_million <- function(name, year) {
  name_popularity <- names[names$year == year & names$name == name, "prop"]
  round(name_popularity * 1000000, 1)
  #' @end
}

#' @id ?
#' @msg
#' How many babies out of 1 million had the name 'Laura' in 1995?
#' @end
#' @code
laura_answer <- number_in_million("Laura", 1995)
#' @end

#' @id -
#' @msg
#' How many babies out of 1 million had your name in the year you were born?
#' @end

#' @id -
#' @msg
## Consider: What does this tell you about how easy it is to identify you with
## just your name and birth year?
