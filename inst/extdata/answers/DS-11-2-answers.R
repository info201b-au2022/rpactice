# pinfo201 / ps-1
#
# DS-11-2: Working with `dplyr`
#    Exercise 11.2 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-11-2", learner="[your name]", email="[your e-mail]")

# Key practice set variables (already initialized) ----
#   library("dplyr")
#   library("fueleconomy")

# Your 15 prompts: (a)-(o) ----

#                                         Note 01.
#    This practice set repeats the analysis from practice set DS-11-1, but is to be
#    completed using `dplyr`.  With practice, you will find `dplyr` easier for
#    complex data filtering an manipulation.
#
#    You will need to install and load the `fueleconomy` package. Here are
#    the commands for doing so:
#       > install.packages("devtools")                     # One time only
#       > devtools::install_github("hadley/fueleconomy")   # One time only
#       > library(fueleconomy)
#
#    In addition, you will need to install the `dplyr` library. `dplyr` comes with
#    the `tidyverse`, which you should have already installed into your system. In
#    case not, here is the command:
#       install.packages("tidyverse")     # One time only
#
#    Then, to use `dplyr`, you use the `library()` statement, like this:
#       > library("dplyr")


# a: Select the different manufacturers (makes) of the cars in this data set.
#    Save this vector in a variable, named `makes`. (DPLYR command: `select()`.) (Variable: makes)
makes <- select(vehicles, make)

# b: Use the `distinct()` function to determine how many different car
#    manufacturers are represented by the data set. Assign this number
#    to the variable, `num_makes`. (DPLYR command: `distinct()`.) (Variable: num_makes)
num_makes <- nrow(distinct(vehicles, make)) # base: length(unique(makes$make))

# c: Filter the data set for vehicles manufactured in 1997.
#    (DPLYR command: `filter()`.) (Variable: cars_1997)
cars_1997 <- filter(vehicles, year == 1997)

# d: Sort the 1997 cars by highway gas mileage (`hwy`). (DPLYR command: `arrange()`) (Variable: cars_1997_sorted)
cars_1997_sorted <- arrange(cars_1997, hwy)

# e: Filter the data set for vehicles manufactured between 1997 and 2000. (Hint:
#    You will need to use the `filter` DPLYR function, along with the logical
#    operator `&` (AND) to combine the results of two relational operators (`>=`
#    and `<=`)). (Variable: cars_1997_to_2000)
cars_1997_to_2000 <- filter(vehicles, year >= 1997 & year <= 2000)

# f: Filter the data set for vehicles manufactured either in 1997 or 2000. (Hint:
#    You will need to use the `filter` DPLYR function, You along with the logical
#    operator `|` (OR) to combine the results of two relational operators (`==`
#    and `==`)). (Variable: cars_1997_or_2000)
cars_1997_or_2000 <- filter(vehicles, year == 1997 | year == 2000)

# g: In the `vehicles` dataframe, what is the highest highway gas mileage? (Hint:
#    You will need to use the DPLYR `summarize()` command and the `max` function.) (Variable: best_mpg_hwy)
best_mpg_hwy <- summarize(vehicles, max(hwy))

# h: In the `vehicles` dataframe, what is lowest highway gas mileage? (Hint:
#    You will need to use the DPLYR `summarize()` command and the `min` function.) (Variable: poorest_mpg_hwy)
poorest_mpg_hwy <- summarize(vehicles, min(hwy))

# i: In the `vehicles` dataframe, what is the average highway gas mileage? (Variable: average_mpg_hwy)
average_mpg_hwy <- summarize(vehicles, mean(hwy))

# j: Mutate the 1997 cars data frame to add a column `average` that has the average
#    gas mileage (between city and highway mpg) for each car. (Variable: cars_1997_new)
cars_1997_new <- mutate(cars_1997, average = (hwy + cty) / 2)

# k: Filter the whole vehicles data set for 2-Wheel Drive vehicles that get more
#    than 20 miles/gallon in the city. Save this new data frame in a variable,
#    named `two_wheel_20_mpg`. (Variable: two_wheel_20_mpg)
two_wheel_20_mpg <- filter(vehicles, drive == "2-Wheel Drive", cty > 20)

# l: Of the above vehicles, that is, `two_wheel_20_mpg`, what is the vehicle with the worst
#    hwy gas mileage?  (Hint: Do this in two steps:  for the worst vehicle, then select its ID.) (Variable: filtered)
filtered <- filter(two_wheel_20_mpg, hwy == min(hwy))

# m: Given the previous result, `filtered`, what is the id of the vehicle? (Hint: Use the
#    DYPLR `select()` command and select the `id`.) (Variable: worst_hwy_id)
worst_hwy_id <- filter(two_wheel_20_mpg, hwy == min(hwy))

# n: Write a function that takes a `year_choice` and a `make_choice` as parameters,
#    and returns the vehicle model that gets the most hwy miles/gallon of vehicles
#    of that make in that year.
#    You'll need to filter more (and do some selecting)! (Variable: make_year_filter)
make_year_filter <- function(make_choice, year_choice) {
  filtered <- filter(vehicles, make == make_choice, year == year_choice)
  filtered <- filter(filtered, hwy == max(hwy))
  selected <- select(filtered, model)
  selected
}

# o: What was the most efficient Honda model of 1995? (Variable: most_efficient)
most_efficient <- make_year_filter("Honda", 1995)


