#' @version ps-1
#' @short DS-11-8
#' @title Exploring data sets
#' @descr
#' Exercise 11.8 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#'
#' @initial-vars
library("dplyr")
#' @end

#' @id -
#' @msg
#' To work on this practice set, you need to download the file:
#'    `pulitzer-circulation-data.csv`
#'
#' This file is located in this GitHub directory:
#'    https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-11-exercises/exercise-8/data
#'
#' Save `pulitzer-circulation-data.csv` in your working directory, under the directory
#' `data`. Your working directory should be:
#'    ~/Documents/info201
#'
#' So, you should save the file here:
#'    ~/Documents/info201/data/pulitzer-circulation-data.csv
#'
#' Hint: Use a spreadsheet or text editor and double-check that the file
#' is located in this directory. This is always a good practice
#' when downloading a data set.
#'
#' Recall that you can check and set your working directory with
#' RStudio and with these R functions:
#'    > ?getwd()
#'    > ?setwd()
#' @end

#' @id -
#' @msg
#' You will also need to load the `dplyr` library:
#'    > library(dplyr)
#' @end

#' @id ?
#' @msg
#' Assign the path name to your file in the variable `fn_path`. As
#' described in the previous note, your path should look something
#' like this:
#'    fn_path <- "~/Documents/info201/data/pulitzer-circulation-data.csv"
#' @end
#' @cp-var fn_path

#' @id ?
#' @msg
#' Use the `read.csv()` function and your variable, `fn_path`,
#' to read this data set
#'    `pulitzer-circulation-data.csv`
#' Assign the data into a variable called `pulitzer`.
#'
#' Note: Do NOT treat strings as factors.
#' @end
#' @code
pulitzer <- read.csv(fn_path, stringsAsFactors = FALSE)
#' @end

#' @id -
#' @msg
#' As usual, examine the dataframe:
#'    > View(pulitzer)
#' @end

#' @id ?
#' @msg
#' Determine the names of the columns for reference.
#' @end
#' @code
the_col_names <- colnames(pulitzer)
#' @end

#' @id ?
#' @msg
#' Use the 'str()' function to also see what types of values are contained in
#' each column (you're looking at the second column after the `:`)
#' Did any value type surprise you? Why do you think they are that type?
#' @end
#' @code
col_information <- str(pulitzer)
#' @end

#' @id ?
#' @msg
#' Add a column to the data frame called 'Pulitzer.Prize.Change` that contains
#' the difference in the number of times each paper was a winner or finalist
#' (hereafter "winner") during 2004-2014 and during 1990-2003
#' @end
#' @code
pulitzer2 <- mutate(pulitzer,
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
most_winners <- filter(pulitzer, max(Pulitzer.Prize.Winners.and.Finalists..2004.2014) ==
         Pulitzer.Prize.Winners.and.Finalists..2004.2014) %>%
  select(Newspaper)
#' @end

#' @id ?
#' @msg
#' Which publication with at least 5 winners between 2004-2014 had the biggest
#' decrease(negative) in daily circulation numbers?
#' @end
#' @code
least_winners <- filter(pulitzer, Pulitzer.Prize.Winners.and.Finalists..2004.2014 >= 5) %>%
  filter(min(Change.in.Daily.Circulation..2004.2013) == Change.in.Daily.Circulation..2004.2013) %>%
  select(Newspaper)
#' @end

#' @id -
#' @msg
#' An important part about being a data scientist is asking questions.
#' Write a question you may be interested in about this data set, and then use
#' dplyr to figure out the answer!
#' @end

