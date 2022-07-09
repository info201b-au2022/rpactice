#' @version ps-1
#' @short DS-11-6
#' @title dplyr join operations
#' @descr
#' Exercise 11.6 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end

# Install the `"nycflights13"` package. Load (`library()`) the package.
# You'll also need to load `dplyr`
# install.packages("nycflights13")  # should be done already
library("nycflights13")
library("dplyr")

#' @id ?
#' @msg
# Create a dataframe of the average arrival delays for each _destination_, then
# use `left_join()` to join on the "airports" dataframe, which has the airport
# information
# Which airport had the largest average arrival delay?
#' @end
#' @code
largest_arrival_delay <- flights %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  mutate(faa = dest) %>%
  left_join(airports, by = "faa") %>%
  filter(avg_delay == max(avg_delay, na.rm = TRUE))
largest_arrival_delay
#' @end

#' @id ?
#' @msg
# Create a dataframe of the average arrival delay for each _airline_, then use
# `left_join()` to join on the "airlines" dataframe
# Which airline had the smallest average arrival delay?
#' @end
#' @code
smallest_airline_delay <- flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier") %>%
  filter(avg_delay == max(avg_delay, na.rm = TRUE))
smallest_airline_delay
#' @end
