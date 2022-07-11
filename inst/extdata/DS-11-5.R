#' @version ps-1
#' @short DS-11-5
#' @title dplyr grouped operations
#' @descr
#' Exercise 11.5 adapted from Programming Skills for Data Science by
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

#' @id ?
#' @msg
#' What was the average departure delay in each month?. Save this as a data
#' frame `dep_delay_by_month` Hint: you'll have to perform a grouping operation
#' then summarizing your data.
#' @end
#' @code
dep_delay_by_month <- flights %>%
  group_by(month) %>%
  summarize(delay = mean(dep_delay, na.rm = TRUE))
#' @end

#' @id ?
#' @msg
#' Which month had the greatest average departure delay?
#' @end
#' @code
departure_delay <-
  filter(dep_delay_by_month, delay == max(delay)) %>%
  select(month, delay)
#' @end

#' @id -
#' @msg
#' If your above data frame contains just two columns (e.g., "month", and "delay"
#' in that order), you can create a scatterplot by passing that data frame to the
#' `plot()` function.
#' @end
#' @code
plot(dep_delay_by_month)
#' @end

#' @id ?
#' @msg
#' To which destinations were the average arrival delays the highest? Hint:
#' you'll have to perform a grouping operation then summarize your data. You can
#' use the `head()` function to view just the first few rows.
#' @end
#' @code
arr_delay_by_month <- flights %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(-delay)
#' @end

#' @id ?
#' @msg
#' You can look up these airports in the `airports` data frame!
#' @end
#' @code
the_airports <- filter(airports, faa == arr_delay_by_month$dest[1]) #' for example
#' @end

#' @id ?
#' @msg
#' Which city was flown to with the highest average speed?
#' @end
#' @code
city_fast_speed <- flights %>%
  mutate(speed = distance / air_time * 60) %>%
  group_by(dest) %>%
  summarise(avg_speed = mean(speed, na.rm = TRUE)) %>%
  filter(avg_speed == max(avg_speed, na.rm = TRUE))
#' @end
