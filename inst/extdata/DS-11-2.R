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
#' completed using `dplyr`.  With practice, you will find `dplyr` easier for
#' complex data filtering an manipulation.
#'
#' You will need to install and load the `fueleconomy` package. Here are
#' the commands for doing so:
#'    > install.packages("devtools")                     # One time only
#'    > devtools::install_github("hadley/fueleconomy")   # One time only
#'    > library(fueleconomy)
#'
#' In addition, you will need to install the `dplyr` library. `dplyr` comes with
#' the `tidyverse`, which you should have already installed into your system. In
#' case not, here is the command:
#'    install.packages("tidyverse")     # One time only
#'
#' Then, to use `dplyr`, you use the `library()` statement, like this:
#'    > library("dplyr")
#' @end

#' @id ?
#' @msg
#' Select the different manufacturers (makes) of the cars in this data set.
#' Save this vector in a variable, named `makes`. (DPLYR command: `select()`.)
#' @end
#' @code
makes <- select(vehicles, make)
#' @end

#' @id ?
#' @msg
#' Use the `distinct()` function to determine how many different car
#' manufacturers are represented by the data set. Assign this number
#' to the variable, `num_makes`. (DPLYR command: `distinct()`.)
#' @end
#' @code
num_makes <- nrow(distinct(vehicles, make)) # base: length(unique(makes$make))
#' @end

#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured in 1997.
#' (DPLYR command: `filter()`.)
#' @end
#' @code
cars_1997 <- filter(vehicles, year == 1997)
#' @end

#' @id ?
#' @msg
#' Sort the 1997 cars by highway gas mileage (`hwy`). (DPLYR command: `arrange()`)
#' @end
#' @code
cars_1997_sorted <- arrange(cars_1997, hwy)
#' @end


#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured between 1997 and 2000. (Hint:
#' You will need to use the `filter` DPLYR function, along with the logical
#' operator `&` (AND) to combine the results of two relational operators (`>=`
#' and `<=`)).
#' @end
#' @code
cars_1997_to_2000 <- filter(vehicles, year >= 1997 & year <= 2000)
#' @end
#'

#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured either in 1997 or 2000. (Hint:
#' You will need to use the `filter` DPLYR function, You along with the logical
#' operator `|` (OR) to combine the results of two relational operators (`==`
#' and `==`)).
#' @end
#' @code
cars_1997_or_2000 <- filter(vehicles, year == 1997 | year == 2000)
#' @end

#' @id ?
#' @msg
#' In the `vehicles` dataframe, what is the highest highway gas mileage? (Hint:
#' You will need to use the DPLYR `summarize()` command and the `max` function.)
#' @end
#' @code
best_mpg_hwy <- summarize(vehicles, max(hwy))
#' @end

#' @id ?
#' @msg
#' In the `vehicles` dataframe, what is lowest highway gas mileage? (Hint:
#' You will need to use the DPLYR `summarize()` command and the `min` function.)
#' @end
#' @code
poorest_mpg_hwy <- summarize(vehicles, min(hwy))
#' @end

#' @id ?
#' @msg
#' In the `vehicles` dataframe, what is the average highway gas mileage?
#' @end
#' @code
average_mpg_hwy <- summarize(vehicles, mean(hwy))
#' @end

#' @id ?
#' @msg
#' Mutate the 1997 cars data frame to add a column `average` that has the average
#' gas mileage (between city and highway mpg) for each car.
#' @end
#' @code
cars_1997_new <- mutate(cars_1997, average = (hwy + cty) / 2)
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
#' Of the above vehicles, that is, `two_wheel_20_mpg`, what is the vehicle with the worst
#' hwy gas mileage?  (Hint: Do this in two steps:  for the worst vehicle, then select its ID.)
#' @end
#' @code
filtered <- filter(two_wheel_20_mpg, hwy == min(hwy))
#' @end

#' @id ?
#' @msg
#' Given the previous result, `filtered`, what is the id of the vehicle? (Hint: Use the
#' DYPLR `select()` command and select the `id`.)
#' @end
#' @code
worst_hwy_id <- filter(two_wheel_20_mpg, hwy == min(hwy))
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

