#' @version ps-1
#' @short DS-11-3
#' @title Using the pipe operator
#' @descr
#' Exercise 11.3 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
library("dplyr")
library("fueleconomy")
#' @end

#' @id -
#' @msg
#' For this practice set, you will need to install and load the
#' `fueleconomy` package. Here are the commands for doing so:
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
# Which 2015 Acura model has the best hwy MGH? (Use dplyr, but without method
# chaining or pipes--use temporary variables!)
#' @end
#' @code
acuras <- filter(vehicles, make == "Acura", year == 2015)
best_acura <- filter(acuras, hwy == max(hwy))
best_model <- select(best_acura, model)
#' @end

#' @id ?
#' @msg
# Which 2015 Acura model has the best hwy MPG? (Use dplyr, nesting functions)
#' @end
#' @code
best_model <- select(
  filter(
    filter(vehicles, make == "Acura", year == 2015), hwy == max(hwy)
  ), model
)
#' @end

#' @id ?
#' @msg
# Which 2015 Acura model has the best hwy MPG? (Use dplyr and the pipe operator)
#' @end
#' @code
best_model <- filter(vehicles, make == "Acura", year == 2015) %>%
  filter(hwy == max(hwy)) %>%
  select(model)
#' @end

#' @id ?
#' @msg

### Bonus

# Write 3 functions, one for each approach.  Then,
# Test how long it takes to perform each one 1000 times

#' @id ?
#' @msg
# Without chaining
#' @end
#' @code
temp_vars_best_model <- function() {
  acuras <- filter(vehicles, make == "Acura", year == 2015)
  best.acura <- filter(acuras, hwy == max(hwy))
  best.model <- select(best_acura, model)
}
#' @end

#' @id ?
#' @msg
# Nested functions
#' @end
#' @code
nested_best_model <- function() {
  best_model <- select(
    filter(
      filter(vehicles, make == "Acura", year == 2015), hwy == max(hwy)
    ), model
  )
}
#' @end

#' @id ?
#' @msg
# Pipe operator
#' @end
#' @code
pipe_best_model <- function() {
  best_model <- filter(vehicles, make == "Acura", year == 2015) %>%
    filter(hwy == max(hwy)) %>%
    select(model)
}
#' @end

#' @id ?
#' @msg
# Pretty similar results; use which is most readable!
#' @end
#' @code
system.time(for (i in 1:1000) temp_vars_best_model())
system.time(for (i in 1:1000) nested_best_model())
system.time(for (i in 1:1000) pipe_best_model())
#' @end
