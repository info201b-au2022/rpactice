# pinfo201 / ps-1
#
# DS-11-4: Practicing with dplyr
#    Exercise 10.5 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-11-4", learner="[your name]", email="[your e-mail]")

# Key practice set variables (already initialized) ----
library("dplyr")
library(nycflights13)

# Your 7 prompts: (a)-(g) ----

#                                         Note 01.
#    For this practice set, you will need to install and load the `nycflights13`
#    package. Here are the commands for doing so:
#       > install.packages("nycflights13")   One time only
#       > library("nycflights13")
#
#    In addition, you will need to install the `dplyr` library, as usual:
#       . install.packages("tidyverse")      One time only
#       > library("dplyr")


#                                         Note 02.
#    After installing the `nycflights13` package and loading it with
#    `library("nycflights13")`, you should have access to this dataframe:
#    `flights`. Following good practice, inspect the dataframe with
#       > View(flights)
#
#    Also, it is a good idea to read the documentation, with:
#       > ??flights


#                                         Note 03.
#    Use a function to determine how many rows are in the dataframe.
num_rows <- nrow(flights)

#                                         Note 04.
#    Use a function to determine how many columns are in the dataframe.
num_cols <- ncol(flights)

#                                         Note 05.
#    Use a function to determine the names of the columns.
col_names <- colnames(flights)

# a: Use `dplyr` to give the dataframe a new column that is the amount of time
#    gained or lost while flying. That is, how much of the delay arriving occurred
#    during a flight, as opposed to before departing. Put this new column in a
#    dataframe called `flights_new1`. (Variable: flights_new1)
flights_new1 <- mutate(flights, gain_in_air = arr_delay - dep_delay)

# b: Use `dplyr` to sort your data frame in descending order by the column you just
#    created. Save this as a variable, `flights_new2`. (Variable: flights_new2)
flights_new2 <- arrange(flights_new1, desc(gain_in_air))

#                                         Note 06.
#    As you know, when doing these kinds of transformations, it is a good idea to
#    examine the new data frames being created.  For example,
#       > View(flights_new2)


# c: For practice, repeat the last 2 steps in a single statement using the pipe
#    operator. Assign your result to the variable `flights` -- that is, you will
#    mutate and sort the `flights` dataframe. (Variable: flights)
flights <- flights %>%
  mutate(gain_in_air = arr_delay - dep_delay) %>%
  arrange(desc(gain_in_air))

#                                         Note 07.
#    The `hist()` function can be used to make histograms. Create a histogram of
#    the amount of time gained in the air.
hist(flights$gain_in_air)

# d: On average, did flights gain or lose time? Note: Use the `na.rm = TRUE`
#    argument to remove NA values from your aggregation. Recall that NA
#    refers to values that are "not available" -- in general, they must be
#    removed making aggregate calculations. (Variable: time_change)
time_change <- mean(flights$gain_in_air, na.rm = TRUE) #' Gained 5 minutes!

# e: Create a data.frame of flights headed to SeaTac ('SEA'), only including the
#    origin, destination, and the "gain_in_air" column you just created. (Variable: to_sea)
to_sea <- flights %>%
  select(origin, dest, gain_in_air) %>%
  filter(dest == "SEA")

# f: On average, did flights to SeaTac gain or loose time? (Variable: time_change_to_SEA)
time_change_to_SEA <- mean(to_sea$gain_in_air, na.rm = TRUE) #' Gained 11 minutes!

# g: Consider flights from JFK to SEA. What was the average, min, and max air time
#    of those flights? See if you can use pipes to answer this question in one statement
#    (without showing any other data)! (Variable: summary_info)
summary_info <- filter(flights, origin == "JFK", dest == "SEA") %>%
  summarize(
    avg_air_time = mean(air_time, na.rm = TRUE),
    max_air_time = max(air_time, na.rm = TRUE),
    min_air_time = min(air_time, na.rm = TRUE)
  )


