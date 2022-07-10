#' @version ps-1
#' @short DS-11-1
#' @title Working with data frames
#' @descr
#' Exercise 10.5 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
library("fueleconomy")
#' @end

#' @id -
#' @msg
#' This practice set requires that you install the packages `devtools`
#' `fueleconomy`. To do this, you need to run these need to run these two
#' commands just once:
#'    > install.packages("devtools")
#'    > devtools::install_github("hadley/fueleconomy")
#'
#' The package `devtools` allows you to install packages directly from GitHub.
#' `fueleconomy` is one such package, which is needed for this practice set.
#'
#' Finally, to access the data or functions of a package, you must run the
#' `library()` command:
#'    > library("fueleconomy")
#' @end

library("fueleconomy")

#' @id -
#' @msg
#' You should now have access to the `vehicles` data frame. Use the view command
#' to view the data set:
#'    > View(vehicles)
#'
#' Spend 5 - 10 minutes inspecting the dataframe. What kind of information is
#' found in the dataframe? To find out more, you can read the documentation,
#' with this command:
#'    > ?vehicles
#' @end

#' @id ?
#' @msg
#' Use the `ncol()` function to determine how many columns are in the
#' dataframe `vehicles`?
#' @end
#' @code
num_cols <- ncol(vehicles)
#' @end

#' @id ?
#' @msg
#' Use a function to determine how many rows are in the dataframe `vehicles`?
#' @end
#' #' @code
num_rows <- nrow(vehicles)
#' @end

#' @id ?
#' @msg
#' One piece of data is the `manufacturer of a car model, that is, the column
#' `makes`. Select this column and assign it to the variable, `makes`.
#' @end
#' @code
makes <- vehicles$make
#' @end

#' @id ?
#' @msg
#' Use the `unique()` function to determine how many different car manufacturers
#' are represented by the data set. Assign this number to the variable,
#' `num_makes`.
#' @end
#' @code
num_makes <- length(unique(makes))
#' @end

#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured in 1997. That is, find all
#' cars that were manufactured in 1997.
#' @end
#' @code
cars_1997 <- vehicles[vehicles$year == 1997, ]
#' @end

#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured between 1997 and 2000. (Hint: You
#' will need to use the logical operator `&` (AND) to combine the results of two
#' relational operators (`>=` and `<=`)).
#' @end
#' @code
cars_1997_to_2000 <- vehicles[(vehicles$year >= 1997) & (vehicles$year <= 2000), ]
#' @end
#'

#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured either in 1997 or 2000. (Hint: You
#' will need to use the logical operator `|` (OR) to combine the results of two
#' relational operators (`==` and `==`)).
#' @end
#' @code
cars_1997_or_2000 <- vehicles[(vehicles$year == 1997) | (vehicles$year == 2000), ]
#' @end

#' @id ?
#' @msg
#' In the `vehicles` dataframe, what is the highest highway gas mileage?
#' @end
#' @code
best_mpg_hwy <- max(vehicles$hwy)
#' @end

#' @id ?
#' @msg
#' In the `vehicles` dataframe, what is lowest highway gas mileage?
#' @end
#' @code
poorest_mpg_hwy <- min(vehicles$hwy)
#' @end

#' @id ?
#' @msg
#' In the `vehicles` dataframe, what is the average highway gas mileage? Round the result to two decimal places.
#' @end
#' @code
average_mpg_hwy <- round(mean(vehicles$hwy), 2)
#' @end

#' @id ?
#' @msg
#' Arrange the 1997 cars (`cars_1997`) by their highway gas mileage (`hwy`) . (Hint: use the
#' `order()` function to get a vector of indices in order by value.)
#' See also:
#' https://www.r-bloggers.com/r-sorting-a-data-frame-by-the-contents-of-a-column/
#' @end
#' @code
cars_1997_sorted <- cars_1997[order(cars_1997$hwy), ]
#' @end

#' @id ?
#' @msg
#' Create a new dataframe, `cars_1997_new`, which as all of the columns
#' cars_1997, plus a column `average` that has the average gas mileage (between
#' city and highway mpg) for each car.
#' @end

#' @code
cars_1997_new <- cars_1997
cars_1997_new$average <- (cars_1997$hwy + cars_1997$cty) / 2
#' @end

#' @id ?
#' @msg
#' Filter the whole vehicles data set, `vehicles`, for 2-Wheel Drive vehicles
#' that get more than 20 miles/gallon in the city. Save this new data frame in a
#' variable, `two_wheel_20_mpg`.
#' @end
#' @code
two_wheel_20_mpg <- vehicles[vehicles$drive == "2-Wheel Drive" & vehicles$cty > 20, ]
#' @end

#' @id ?
#' @msg
#' Of the above vehicles, that is, `two_wheel_20_mpg `, what is the vehicle ID of the
#' vehicle with the worst hwy mpg? (Hint: filter for the worst vehicle, then select
#' its ID.)
#' @end
#' @code
worst_hwy <- two_wheel_20_mpg$id[two_wheel_20_mpg$hwy == min(two_wheel_20_mpg$hwy)]
#' @end

#' @id ?
#' @msg
#' Write a function that takes a `year_choice` and a `make_choice` as parameters,
#' and returns the vehicle model that gets the most hwy miles/gallon of vehicles
#' of that make in that year. You'll need to filter more (and do some selecting)!
#' @end
#' @check list(arg1=c("Acura", "Aston Martin", "BMW"), arg2=c(1995, 2012, 1999))
#' @code
make_year_filter <- function(make_choice, year_choice) {
  filtered <- vehicles[vehicles$make == make_choice & vehicles$year == year_choice, ]
  filtered[filtered$hwy == max(filtered$hwy), "model"]
  return(filtered)
}
#' @end

#' @id ?
#' @msg
#' What was the most efficient Honda model of 1995?
#' @end
#' @code
most_efficient <- make_year_filter("Honda", 1995)
#' @end
