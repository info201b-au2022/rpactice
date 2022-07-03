#' @version ps-1
#' @short DS-10-4
#' @title External data sets: Gates Foundation Educational Grants
#' @descr
#' Exercise 10.4 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#'
#' @id -
#' @msg
#' To work on this practice set, you need to download the file
#' `data/gates_money.csv`, which is located in this GitHub directory:
#'    https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-10-exercises/exercise-4/data
#'
#' Save this file in your working directory, under the directory `data`:
#'    data/gates_money.csv
#'
#' Recall that you can check and set your working directory with
#' RStudio and with these commands:
#'    > ?getwd()
#'    > ?setwd()
#' @end
#' @code
grants <- read.csv("data/gates_money.csv", stringsAsFactors = FALSE)
#' @end

#' @id ?
#' @msg
#' Use the `read.csv()` function to read the data this file:
#'    `data/gates_money.csv`
#' Put the data into a variable called `grants`.
#'
#' Notes: (1) Be sure to set your working directory in RStudio; and
#' (2) Do NOT treat strings as factors.
#' @end
#' @code
grants <- read.csv("data/gates_money.csv", stringsAsFactors = FALSE)
#' @end

#' @id -
#' @msg
#' Use the View function to look at the loaded data.
#' @end
#' @code
View(grants)
#' @end

#' @id ?
#' @msg
#' Create a variable `organization` that contains the `organization` column of
#' the dataset
#' @end
#' @code
organization <- grants$organization
#' @end

#' @id ?
#' @msg
#' Confirm that the "organization" column is a vector using the `is.vector()`
#' function. This is a useful debugging tip if you encounter errors later!
#' @end
#' @code
is_vector <- is.vector(organization)
#' @end

#' @id -
#' @msg
#' Now that the data set as been loaded in the variable, `grants`, you can
#' ask some questions.
#' @end

#' @id -
#' @msg
#' What was the mean dollar amount of all grants?
#' @end
#' @code
mean_spending <- mean(grants$total_amount)
#' @end

#' @id ?
#' @msg
#' What was the dollar amount of the largest grant?
#' @end
#' @code
highest_amount <- max(grants$total_amount)
#' @end

#' @id ?
#' @msg
#' What was the dollar amount of the smallest grant?
#' @end
#' @code
lowest_amount <- min(grants$total_amount)
#' @end

#' @id ?
#' @msg
#' Which organization received the largest grant?
#' @end
#' @code
largest_recipient <- organization[grants$total_amount == highest_amount]
#' @end

#' @id ?
#' @msg
#' Which organization received the smallest grant?
#' @end
#' @code
smallest_recipient <- organization[grants$total_amount == lowest_amount]
#' @end

#' @id ?
#' @msg
#' How many grants were awarded in 2010?
#' @end
#' @code
length(grants$total_amount[grants$start_year == 2010])
#' @end
