#' @version ps-1
#' @short DS-11-1
#' @title Working with data frames
#' @descr
#' Exercise 10.5 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end

#' @id -
#' @msg
#' This practice set requires that you install the package
#' `devtools` and the package `fueleconomy`. To do this, you
#' need to run these two commands just one time.
#'    > install.packages("devtools")
#'    > devtools::install_github("hadley/fueleconomy")
#'
#' The package `devtools` allows you to install packages
#' directly from GitHub. `fueleconomy` is one such package,
#' which is needed for this practice set.
#'
#' Finally, to load the package into R you need to run this
#' command:
#'    > library(fueleconomy)
#' @end

#' @id -
#' @msg
#' You should now have access to the `vehicles` data frame. Use the
#' view command to view the data set:
#'    View(vehicles)
#' @end

#' @id ?
#' @msg
#' Select the different manufacturers (makes) of the cars in this data set.
#' Save this vector in a variable, `makes`.
#' @end
#' @code
makes <- vehicles$make
#' @end

#' @id ?
#' @msg
#' Use the `unique()` function to determine how many different car
#' manufacturers are represented by the data set. Assign this
#' number to the variable, `num_makes`.
#' @end
#' @code
num_makes <- length(unique(makes))
#' @end

#' @id ?
#' @msg
#' Filter the data set for vehicles manufactured in 1997.
#' @end
#' @code
cars_1997 <- vehicles[vehicles$year == 1997, ]
#' @end

#' @id ?
#' @msg
#' Arrange the 1997 cars by highway (`hwy`) gas mileage. (Hint: use the
#' `order()` function to get a vector of indices in order by value.)
#' See also:
#' https://www.r-bloggers.com/r-sorting-a-data-frame-by-the-contents-of-a-column/
#' @end
#' @code
cars_1997 <- cars_1997[order(cars_1997$hwy), ]
#' @end

#' @id ?
#' @msg
#' Mutate the 1997 cars data frame to add a column `average` that has the average
#' gas mileage (between city and highway mpg) for each car.
#' @end
#' @code
cars_1997$average <- (cars_1997$hwy + cars_1997$cty) / 2
#' @end

#' @id ?
#' @msg
#' Filter the whole vehicles data set for 2-Wheel Drive vehicles that get more
#' than 20 miles/gallon in the city. Save this new data frame in a variable,
#' `two_wheel_20_mpg`.
#' @end
#' @code
two_wheel_20_mpg <- vehicles[vehicles$drive == "2-Wheel Drive" & vehicles$cty > 20, ]
#' @end

#' @id ?
#' @msg
#' Of the above vehicles, what is the vehicle ID of the vehicle with the worst
#' hwy mpg? (Hint: filter for the worst vehicle, then select its ID.)
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
