#' @version ps-1
#' @short DS-10-5
#' @title Large data sets: Baby Name Popularity Over Time
#' @descr
#' Exercise 10.5 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end

# Exercise 1: working with data frames (review)

# Install devtools package: allows installations from GitHub
install.packages("devtools")

# Install "fueleconomy" dataset from GitHub
devtools::install_github("hadley/fueleconomy")

# Use the `libary()` function to load the "fueleconomy" package
library(fueleconomy)

#' @id ?
#' @msg
# You should now have access to the `vehicles` data frame
# You can use `View()` to inspect it
View(vehicles)
#' @code

#' @id ?
#' @msg
# Select the different manufacturers (makes) of the cars in this data set.
# Save this vector in a variable
#' @end
#' @code
makes <- vehicles$make
#' @code

#' @id ?
#' @msg
# Use the `unique()` function to determine how many different car manufacturers
# are represented by the data set
#' @end
#' @code
length(unique(makes))
#' @code

#' @id ?
#' @msg
# Filter the data set for vehicles manufactured in 1997
#' @end
#' @code
cars_1997 <- vehicles[vehicles$year == 1997, ]
#' @code

#' @id ?
#' @msg
# Arrange the 1997 cars by highway (`hwy`) gas milage
# Hint: use the `order()` function to get a vector of indices in order by value
# See also:
# https://www.r-bloggers.com/r-sorting-a-data-frame-by-the-contents-of-a-column/
#' @end
#' @code
cars_1997 <- cars_1997[order(cars_1997$hwy), ]
#' @code

#' @id ?
#' @msg
# Mutate the 1997 cars data frame to add a column `average` that has the average
# gas milage (between city and highway mpg) for each car
#' @end
#' @code
cars_1997$average <- (cars_1997$hwy + cars_1997$cty) / 2
#' @code

#' @id ?
#' @msg
# Filter the whole vehicles data set for 2-Wheel Drive vehicles that get more
# than 20 miles/gallon in the city.
# Save this new data frame in a variable.
#' @end
#' @code
two_wheel_20_mpg <- vehicles[vehicles$drive == "2-Wheel Drive" & vehicles$cty > 20, ]
#' @code

#' @id ?
#' @msg
# Of the above vehicles, what is the vehicle ID of the vehicle with the worst
# hwy mpg?
# Hint: filter for the worst vehicle, then select its ID.
#' @end
#' @code
worst_hwy <- two_wheel_20_mpg$id[two_wheel_20_mpg$hwy == min(two_wheel_20_mpg$hwy)]
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
  filtered <- vehicles[vehicles$make == make_choice & vehicles$year == year_choice, ]
  filtered[filtered$hwy == max(filtered$hwy), "model"]
}
#' @code

#' @id ?
#' @msg
# What was the most efficient Honda model of 1995?
#' @end
#' @code
make_year_filter("Honda", 1995)
#' @code
