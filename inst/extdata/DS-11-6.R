#' @version ps-1
#' @short DS-11-6
#' @title dplyr join operations
#' @descr
#' Exercise 11.6 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
library("dplyr")
library(nycflights13)
#' @end

#' @id -
#' @msg
#' For this practice set, you will need to install and load the `nycflights13`
#' package. Here are the commands for doing so:
#'    > install.packages("nycflights13")  #' One time only
#'    > library("nycflights13")
#'
#' In addition, you will need to install the `dplyr` library, as usual:
#'    . install.packages("tidyverse")     #' One time only
#'    > library("dplyr")
#' @end

#' @id -
#' @msg
#' In the following two prompts, you will use `flights`, `airports`, and
#' `airlines` dataframes. Before proceeding, it is recommended that you
#' review each of these dataframes, with
#'    > View(airports)
#'    > ?airports
#'
#' And so forth.
#' @end

#' @id ?
#' @msg
#' For this practice prompt you will join two tables, namely `flights` and
#' `airports`. Create a dataframe of the average arrival delays for each
#' _destination_. Then, use `left_join()` to join on the "airports" dataframe,
#' which has the airport information. Note: The key for joining `flights` and
#' `airports` is `faa`. Which airport had the largest average arrival delay?
#' @end
#' @code
largest_arrival_delay <- flights %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  mutate(faa = dest) %>%
  left_join(airports, by = "faa") %>%
  filter(avg_delay == max(avg_delay, na.rm = TRUE))
#' @end

#' @id ?
#' @msg
#' Create a dataframe of the average arrival delay for each _airline_, then use
#' `left_join()` to join on the "airlines" dataframe. Which airline had the
#' smallest average arrival delay?
#' @end
#' @code
smallest_airline_delay <- flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier") %>%
  filter(avg_delay == max(avg_delay, na.rm = TRUE))
#' @end
