# pinfo201 / ps-1
#
# DS-11-5: dplyr grouped operations
#    Exercise 11.5 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-11-5", learner="[your name]", email="[your e-mail]")

# Key practice set variables (already initialized) ----
#   library("dplyr")
#   library(nycflights13)

# Your 5 prompts: (a)-(e) ----

#                                         Note 01.
#    For this practice set, you will need to install and load the `nycflights13`
#    package. Here are the commands for doing so:
#       > install.packages("nycflights13")   One time only
#       > library("nycflights13")
#
#    In addition, you will need to install the `dplyr` library, as usual:
#       . install.packages("tidyverse")      One time only
#       > library("dplyr")


# a: What was the average departure delay in each month?. Save this as a data
#    frame `dep_delay_by_month` Hint: you'll have to perform a grouping operation
#    then summarizing your data. (Variable: dep_delay_by_month)
dep_delay_by_month <- flights %>%
  group_by(month) %>%
  summarize(delay = mean(dep_delay, na.rm = TRUE))

# b: Which month had the greatest average departure delay? (Variable: departure_delay)
departure_delay <-
  filter(dep_delay_by_month, delay == max(delay)) %>%
  select(month, delay)

#                                         Note 02.
#    If your above data frame contains just two columns (e.g., "month", and "delay"
#    in that order), you can create a scatterplot by passing that data frame to the
#    `plot()` function.
plot(dep_delay_by_month)

# c: To which destinations were the average arrival delays the highest? Hint:
#    you'll have to perform a grouping operation then summarize your data. You can
#    use the `head()` function to view just the first few rows. (Variable: arr_delay_by_month)
arr_delay_by_month <- flights %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(-delay)

# d: You can look up these airports in the `airports` data frame! (Variable: the_airports)
the_airports <- filter(airports, faa == arr_delay_by_month$dest[1]) #' for example

# e: Which city was flown to with the highest average speed? (Variable: city_fast_speed)
city_fast_speed <- flights %>%
  mutate(speed = distance / air_time * 60) %>%
  group_by(dest) %>%
  summarise(avg_speed = mean(speed, na.rm = TRUE)) %>%
  filter(avg_speed == max(avg_speed, na.rm = TRUE))


