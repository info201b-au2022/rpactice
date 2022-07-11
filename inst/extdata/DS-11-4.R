#' @version ps-1
#' @short DS-11-4
#' @title Practicing with dplyr
#' @descr
#' Exercise 10.5 adapted from Programming Skills for Data Science by
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
#' After installing the `nycflights13` package and loading it with
#' `library("nycflights13")`, you should have access to this dataframe:
#' `flights`. Following good practice, inspect the dataframe with
#'    > View(flights)
#'
#' Also, it is a good idea to read the documentation, with:
#'    > ??flights
#'
#' @end

#' @id -
#' @msg
#' Use a function to determine how many rows are in the dataframe.
#' @end
#' @code
num_rows <- nrow(flights)
#' @end

#' @id -
#' @msg
#' Use a function to determine how many columns are in the dataframe.
#' @end
#' @code
num_cols <- ncol(flights)
#' @end

#' @id -
#' @msg
#' Use a function to determine the names of the columns.
#' @end
#' @code
col_names <- colnames(flights)
#' @end

#' @id ?
#' @msg
#' Use `dplyr` to give the dataframe a new column that is the amount of time
#' gained or lost while flying. That is, how much of the delay arriving occurred
#' during a flight, as opposed to before departing. Put this new column in a
#' dataframe called `flights_new1`.
#' @end
#' @code
flights_new1 <- mutate(flights, gain_in_air = arr_delay - dep_delay)
#' @end

#' @id ?
#' @msg
#' Use `dplyr` to sort your data frame in descending order by the column you just
#' created. Save this as a variable, `flights_new2`.
#' @end
#' @code
flights_new2 <- arrange(flights_new1, desc(gain_in_air))
#' @end

#' @id -
#' @msg
#' As you know, when doing these kinds of transformations, it is a good idea to
#' examine the new data frames being created.  For example,
#'    > View(flights_new2)
#' @end

#' @id ?
#' @msg
#' For practice, repeat the last 2 steps in a single statement using the pipe
#' operator. Assign your result to the variable `flights` -- that is, you will
#' mutate and sort the `flights` dataframe.
#' @end
#' @code
flights <- flights %>%
  mutate(gain_in_air = arr_delay - dep_delay) %>%
  arrange(desc(gain_in_air))
#' @end

#' @id -
#' @msg
#' The `hist()` function can be used to make histograms. Create a histogram of
#' the amount of time gained in the air.
#' @end
#' @code
hist(flights$gain_in_air)
#' @end

#' @id ?
#' @msg
#' On average, did flights gain or lose time? Note: Use the `na.rm = TRUE`
#' argument to remove NA values from your aggregation. Recall that NA
#' refers to values that are "not available" -- in general, they must be
#' removed making aggregate calculations.
#' @end
#' @code
time_change <- mean(flights$gain_in_air, na.rm = TRUE) #' Gained 5 minutes!
#' @end

#' @id ?
#' @msg
#' Create a data.frame of flights headed to SeaTac ('SEA'), only including the
#' origin, destination, and the "gain_in_air" column you just created.
#' @end
#' @code
to_sea <- flights %>%
  select(origin, dest, gain_in_air) %>%
  filter(dest == "SEA")
#' @end

#' @id ?
#' @msg
#' On average, did flights to SeaTac gain or loose time?
#' @end
#' @code
time_change_to_SEA <- mean(to_sea$gain_in_air, na.rm = TRUE) #' Gained 11 minutes!
#' @end

#' @id ?
#' @msg
#' Consider flights from JFK to SEA. What was the average, min, and max air time
#' of those flights? See if you can use pipes to answer this question in one statement
#' (without showing any other data)!
#' @end
#' @code
summary_info <- filter(flights, origin == "JFK", dest == "SEA") %>%
  summarize(
    avg_air_time = mean(air_time, na.rm = TRUE),
    max_air_time = max(air_time, na.rm = TRUE),
    min_air_time = min(air_time, na.rm = TRUE)
  )
#' @end
