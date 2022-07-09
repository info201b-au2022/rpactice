#' @version ps-1
#' @short DS-11-2
#' @title Working with `dplyr`
#' @descr
#' Exercise 11.2 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
library("dplyr")
library("fueleconomy")
#' @end

#' @id -
#' @msg
#' This practice set repeats the analysis from practice set DS-11-1, but is to be
#' completed using `dplyr` rather than directly access or manipulate the data
#' frames.
#'
#' You will need to install and load the `fueleconomy` package. Here are
#' the commands for doing so:
#'    install.packages("devtools")                     # One time only
#'    devtools::install_github("hadley/fueleconomy")   # One time only
#'    library(fueleconomy)
#'
#' In addition, you will need to install the `dplyr` library.  Here are
#' the commands:
#'    install.packages("dplyr")     # One time only
#'    library("dplyr")
#' @end

#' @id ?
#' @msg
#' Select the different manufacturers (makes) of the cars in this data set.
#' Save this vector in a variable, named `makes`.
#' @end
#' @code
makes <- select(vehicles, make)
#' @end

#' @id ?
#' @msg
#' Use the `distinct()` function to determine how many different car
#' manufacturers are represented by the data set. Assign this number
#' to the variable, `num_makes`.
#' @end
#' @code
num_makes <- nrow(distinct(vehicles, make)) # base: length(unique(makes$make))
#' @end

#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured in 1997.
#' @end
#' @code
cars_1997 <- filter(vehicles, year == 1997)
#' @end

#' @id ?
#' @msg
#' Arrange the 1997 cars by highway (`hwy`) gas milage.
#' @end
#' @code
cars_1997 <- arrange(cars_1997, hwy)
#' @end

#' @id ?
#' @msg
#' Mutate the 1997 cars data frame to add a column `average` that has the average
#' gas mileage (between city and highway mpg) for each car.
#' @end
#' @code
cars_1997 <- mutate(cars_1997, average = (hwy + cty) / 2)
#' @end

#' @id ?
#' @msg
#' Filter the whole vehicles data set for 2-Wheel Drive vehicles that get more
#' than 20 miles/gallon in the city. Save this new data frame in a variable,
#' named `two_wheel_20_mpg`.
#' @end
#' @code
two_wheel_20_mpg <- filter(vehicles, drive == "2-Wheel Drive", cty > 20)
#' @end

#' @id ?
#' @msg
#' Of the above vehicles, what is the vehicle ID of the vehicle with the worst
#' hwy mpg? (Hint: filter for the worst vehicle, then select its ID.)
#' @end
#' @code
filtered <- filter(two_wheel_20_mpg, hwy == min(hwy))
worst_hwy <- select(filtered, id)
#' @end

#' @id ?
#' @msg
#' Write a function that takes a `year_choice` and a `make_choice` as parameters,
#' and returns the vehicle model that gets the most hwy miles/gallon of vehicles
#' of that make in that year.
#' You'll need to filter more (and do some selecting)!
#' @end
#' @check list(arg1=c("Acura", "Aston Martin", "BMW"), arg2=c(1995, 2012, 1999))
#' @code
make_year_filter <- function(make_choice, year_choice) {
  filtered <- filter(vehicles, make == make_choice, year == year_choice)
  filtered <- filter(filtered, hwy == max(hwy))
  selected <- select(filtered, model)
  selected
}
#' @end

#' @id ?
#' @msg
#' What was the most efficient Honda model of 1995?
#' @end
#' @code
most_efficient <- make_year_filter("Honda", 1995)
#' @end

