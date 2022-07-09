#' @version ps-1
#' @short DS-11-8
#' @title Exploring data sets
#' @descr
#' Exercise 11.8 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#'

#' Load the `dplyr` library
library(dplyr)

#' Read in the data (from `data/pupulitzer-circulation-data.csv`). Remember to
#' not treat strings as factors!
pulitzer <- read.csv("data/pulitzer-circulation-data.csv", stringsAsFactors = FALSE)

#' View in the data set. Start to understand what the data set contains
View(pulitzer)

#' @id ?
#' @msg
#' Print out the names of the columns for reference
#' @end
#' @code
colnames(pulitzer)
#' @end

#' @id ?
#' @msg
#' Use the 'str()' function to also see what types of values are contained in
#' each column (you're looking at the second column after the `:`)
#' Did any value type surprise you? Why do you think they are that type?
#' @end
#' @code
str(pulitzer)
#' @end

#' @id ?
#' @msg
#' Add a column to the data frame called 'Pulitzer.Prize.Change` that contains
#' the difference in the number of times each paper was a winner or finalist
#' (hereafter "winner") during 2004-2014 and during 1990-2003
#' @end
#' @code
mutate(pulitzer,
       Pulitzer.Prize.Change =
         Pulitzer.Prize.Winners.and.Finalists..2004.2014 -
         Pulitzer.Prize.Winners.and.Finalists..1990.2003
)
#' @end

#' @id ?
#' @msg
#' What was the name of the publication that has the most winners between
#' 2004-2014?
#' @end
#' @code
filter(pulitzer, max(Pulitzer.Prize.Winners.and.Finalists..2004.2014) ==
         Pulitzer.Prize.Winners.and.Finalists..2004.2014) %>%
  select(Newspaper)
#' @end

#' @id ?
#' @msg
#' Which publication with at least 5 winners between 2004-2014 had the biggest
#' decrease(negative) in daily circulation numbers?
#' @end
#' @code
filter(pulitzer, Pulitzer.Prize.Winners.and.Finalists..2004.2014 >= 5) %>%
  filter(min(Change.in.Daily.Circulation..2004.2013) == Change.in.Daily.Circulation..2004.2013) %>%
  select(Newspaper)
#' @end

#' An important part about being a data scientist is asking questions.
#' Write a question you may be interested in about this data set, and then use
#' dplyr to figure out the answer!
