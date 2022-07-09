#' @version ps-1
#' @short DS-11-4
#' @title Practicing with dplyr
#' @descr
#' Exercise 10.5 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end


# Install the `"nycflights13"` package. Load (`library()`) the package.
# You'll also need to load `dplyr`
install.packages("nycflights13")
library(nycflights13)
library(dplyr)

#' @id ?
#' @msg
# The data frame `flights` should now be accessible to you.
# Use functions to inspect it: how many rows and columns does it have?
# What are the names of the columns?
# Use `??flights` to search for documentation on the data set (for what the
# columns represent)
#' @end
#' @code
nrow(flights)
ncol(flights)
colnames(flights)
?flights
#' @end

#' @id ?
#' @msg
# Use `dplyr` to give the data frame a new column that is the amount of time
# gained or lost while flying (that is: how much of the delay arriving occured
# during flight, as opposed to before departing).
#' @end
#' @code
flights <- mutate(flights, gain_in_air = arr_delay - dep_delay)
#' @end

#' @id ?
#' @msg
# Use `dplyr` to sort your data frame in descending order by the column you just
# created. Remember to save this as a variable (or in the same one!)
#' @end
#' @code
flights <- arrange(flights, desc(gain_in_air))
View(head(flights))
#' @end

#' @id ?
#' @msg
# For practice, repeat the last 2 steps in a single statement using the pipe
# operator. You can clear your environmental variables to "reset" the data frame
#' @end
#' @code
flights <- flights %>% mutate(gain_in_air = arr_delay - dep_delay) %>% arrange(desc(gain_in_air))
#' @end

#' @id ?
#' @msg
# Make a histogram of the amount of time gained using the `hist()` function
#' @end
#' @code
hist(flights$gain_in_air)
#' @end

#' @id ?
#' @msg
# On average, did flights gain or lose time?
# Note: use the `na.rm = TRUE` argument to remove NA values from your aggregation
#' @end
#' @code
mean(flights$gain_in_air, na.rm = TRUE) # Gained 5 minutes!
#' @end

#' @id ?
#' @msg
# Create a data.frame of flights headed to SeaTac ('SEA'), only including the
# origin, destination, and the "gain_in_air" column you just created
#' @end
#' @code
to_sea <- flights %>% select(origin, dest, gain_in_air) %>% filter(dest == "SEA")
#' @end

#' @id ?
#' @msg
# On average, did flights to SeaTac gain or loose time?
#' @end
#' @code
mean(to_sea$gain_in_air, na.rm = TRUE) # Gained 11 minutes!
#' @end

#' @id ?
#' @msg
# Consider flights from JFK to SEA. What was the average, min, and max air time
# of those flights? Bonus: use pipes to answer this question in one statement
# (without showing any other data)!
#' @end
#' @code
filter(flights, origin == "JFK", dest == "SEA") %>%
  summarize(
    avg_air_time = mean(air_time, na.rm = TRUE),
    max_air_time = max(air_time, na.rm = TRUE),
    min_air_time = min(air_time, na.rm = TRUE)
  )
#' @end
