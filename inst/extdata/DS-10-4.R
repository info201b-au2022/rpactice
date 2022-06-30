#' @version ps-1
#' @short DS-10-4
#' @title External data sets: Gates Foundation Educational Grants
#' @descr
#' Exercise 10.4 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end

#' @id ?
#' @msg
#' Use the `read.csv()` function to read the data from the `data/gates_money.csv`
#' file into a variable called `grants` using the `read.csv()`
#' Be sure to set your working directory in RStudio, and do NOT treat strings as
#' factors!
#' @end
#' @code
grants <- read.csv("data/gates_money.csv", stringsAsFactors = FALSE)
#' @end

#' @id -
#' @msg
#' Use the View function to look at the loaded data
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
#' function.
#' This is a useful debugging tip if you hit errors later!
#' @end
#' @code
is.vector(organization)
#' @end

#' @id -
#' @msg
#' Now you can ask some interesting questions about the dataset
#' @end

#' @id -
#' @msg
#' What was the mean grant value?
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
