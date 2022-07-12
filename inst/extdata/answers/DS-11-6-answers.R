# pinfo201 / ps-1
#
# DS-11-6: dplyr join operations
#    Exercise 11.6 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-11-6", learner="[your name]", email="[your e-mail]")

# Key practice set variables (already initialized) ----
#   library("dplyr")
#   library(nycflights13)

# Your 2 prompts: (a)-(b) ----

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
#    In the following two prompts, you will use `flights`, `airports`, and
#    `airlines` dataframes. Before proceeding, it is recommended that you
#    review each of these dataframes, with
#       > View(airports)
#       > ?airports
#
#    And so forth.


# a: For this practice prompt you will join two tables, namely `flights` and
#    `airports`. Create a dataframe of the average arrival delays for each
#    _destination_. Then, use `left_join()` to join on the "airports" dataframe,
#    which has the airport information. Note: The key for joining `flights` and
#    `airports` is `faa`. Which airport had the largest average arrival delay? (Variable: largest_arrival_delay)
largest_arrival_delay <- flights %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  mutate(faa = dest) %>%
  left_join(airports, by = "faa") %>%
  filter(avg_delay == max(avg_delay, na.rm = TRUE))

# b: Create a dataframe of the average arrival delay for each _airline_, then use
#    `left_join()` to join on the "airlines" dataframe. Which airline had the
#    smallest average arrival delay? (Variable: smallest_airline_delay)
smallest_airline_delay <- flights %>%
  group_by(carrier) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE)) %>%
  left_join(airlines, by = "carrier") %>%
  filter(avg_delay == max(avg_delay, na.rm = TRUE))


