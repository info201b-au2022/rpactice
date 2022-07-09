#' @version ps-1
#' @short DS-10-5
#' @title Large data sets: Baby Name Popularity Over Time
#' @descr
#' Exercise 10.5 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end

# Exercise 2: working with `dplyr`
#' @id ?
#' @msg
# Note that this exercise repeats the analysis from Exercise 1, but should be
# performed using `dplyr` (do not directly access or manipulate the data frames)

# Install and load the "fueleconomy" package
# install.packages("devtools")
# devtools::install_github("hadley/fueleconomy")
library(fueleconomy)

# Install and load the "dplyr" library
install.packages("dplyr")
library("dplyr")

#' @id ?
#' @msg
# Select the different manufacturers (makes) of the cars in this data set.
# Save this vector in a variable
#' @end
#' @code
makes <- select(vehicles, make)
#' @code

#' @id ?
#' @msg
# Use the `distinct()` function to determine how many different car manufacturers
# are represented by the data set
#' @end
#' @code
nrow(distinct(vehicles, make))
length(unique(makes$make)) # without deplyr
#' @code

#' @id ?
#' @msg
# Filter the data set for vehicles manufactured in 1997
#' @end
#' @code
cars_1997 <- filter(vehicles, year == 1997)
#' @code

#' @id ?
#' @msg
# Arrange the 1997 cars by highway (`hwy`) gas milage
#' @end
#' @code
cars_1997 <- arrange(cars_1997, hwy)
#' @code

#' @id ?
#' @msg
# Mutate the 1997 cars data frame to add a column `average` that has the average
# gas milage (between city and highway mpg) for each car
#' @end
#' @code
cars_1997 <- mutate(cars_1997, average = (hwy + cty) / 2)
#' @code

#' @id ?
#' @msg
# Filter the whole vehicles data set for 2-Wheel Drive vehicles that get more
# than 20 miles/gallon in the city.
# Save this new data frame in a variable.
#' @end
#' @code
two_wheel_20_mpg <- filter(vehicles, drive == "2-Wheel Drive", cty > 20)
#' @code

#' @id ?
#' @msg
# Of the above vehicles, what is the vehicle ID of the vehicle with the worst
# hwy mpg?
# Hint: filter for the worst vehicle, then select its ID.
#' @end
#' @code
filtered <- filter(two_wheel_20_mpg, hwy == min(hwy))
worst_hwy <- select(filtered, id)
#' @code

#' @id ?
#' @msg
# Write a function that takes a `year_choice` and a `make_choice` as parameters,
# and returns the vehicle model that gets the most hwy miles/gallon of vehicles
# of that make in that year.
# You'll need to filter more (and do some selecting)!
#' @end
#' @code
make_year_filter <- function(make_choice, year_choice) {
  filtered <- filter(vehicles, make == make_choice, year == year_choice)
  filtered <- filter(filtered, hwy == max(hwy))
  selected <- select(filtered, model)
  selected
}
#' @code

#' @id ?
#' @msg
# What was the most efficient Honda model of 1995?
#' @end
#' @code
make_year_filter("Honda", 1995)
#' @code

