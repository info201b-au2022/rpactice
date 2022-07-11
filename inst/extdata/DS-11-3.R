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
#' For this practice set, you will need to install and load the `fueleconomy`
#' package. Here are the commands for doing so:
#'    > install.packages("devtools")                     #' One time only
#'    > devtools::install_github("hadley/fueleconomy")   #' One time only
#'    > library(fueleconomy)
#'
#' In addition, you will need to install the `dplyr` library. `dplyr` comes with
#' the `tidyverse`, which you should have already installed into your system. In
#' case not, here is the command:
#'    install.packages("tidyverse")     #' One time only
#'
#' Finally, to use `dplyr`, you use the `library()` statement, like this:
#'    > library("dplyr")
#' @end

#' @id -
#' @msg
#' Which 2015 Acura model has the best hwy mileage? To answer this question, use
#' `dplyr` with temporary variables, `acuras`, `best_acura`, and `best_model`,
#' for the following prompts.
#' @end

#' @id ?
#' @msg
#' Filter for "Acura" and the year 2015
#' @end
#' @code
acuras <- filter(vehicles, make == "Acura", year == 2015)
#' @end

#' @id ?
#' @msg
#' Filter for 2015 "Acura" with the best hwy mileage.
#' @end
#' @code
best_acura <- filter(acuras, hwy == max(hwy))
#' @end

#' @id ?
#' @msg
#' Select the model.
#' @end
#' @code
best_model1 <- select(best_acura, model)
#' @end

#' @id ?
#' @msg
#' Which 2015 Acura model has the best hwy MPG? To answer this prompt, use `dplyr`
#' and nested functions (one statement with nested functions).
#' @end
#' @code
best_model2 <- select(
  filter(
    filter(vehicles, make == "Acura", year == 2015), hwy == max(hwy)
  ), model
)
#' @end

#' @id ?
#' @msg
#' Which 2015 Acura model has the best hwy MPG? To answer this prompt, use `dplyr`
#' and pipe operators (one statement with pipe operators).
#' @end
#' @code
best_model3 <- filter(vehicles, make == "Acura", year == 2015) %>%
  filter(hwy == max(hwy)) %>%
  select(model)
#' @end

#' @id -
#' @msg
#' **Enrichment**. You have computed the same result in three different ways.
#' One question you might ask: Which approach is more efficient? One way to
#' answer this question is to time how long it takes to compute the answers with
#' each of the three above approaches and compare.
#'
#' R provides a function, `system.time()`, for doing so. This function
#' takes an expression and reports the  time required to run the expression.
#' If `f()` is simply a function that computes something, here's the code:
#'    > system.time(f())
#'
#' To see differences, we often repeat the execution of a function 100 to
#' 1,000 times. So the general pattern is the following:
#'    > system.time(for(k in 1:1000) f())
#'
#' This will run a function, `f()` one thousand times and report the length of
#' time that it took.
#'
#' In the following prompts, you will create functions for the above three
#' approaches and compare their performance.
#' @end

#' @id ?
#' @msg
#' Write a function, `temp_vars_best_model`, with variable chaining.
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
#' Write a function, `nested_best_model`, with nested functions.
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
#' Write a function, `pipe_best_model`, with pipe operators.
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
#' How long does it take to compute `temp_vars_best_model()` 1000 times?
#' @end
#' @code
time_temp_vars <- system.time(for (i in 1:1000) temp_vars_best_model())
#' @end

#' @id ?
#' @msg
#' How long does it take to compute `nested_best_model()` 1000 times?
#' @end
#' @code
time_nested <- system.time(for (i in 1:1000) nested_best_model())
#' @end

#' @id ?
#' @msg
#' How long does it take to compute `pipe_best_model()` 1000 times?
#' @end
#' @code
time_pipes <- system.time(for (i in 1:1000) pipe_best_model())
#' @end

#' @id -
#' @msg
#' Are the times more or less the same?  If so, then you should you use
#' temporary, nested, or piped however you like.  In general, use the approach
#' that is the easiest to understand. The approach you use may vary depending on
#' circumstances. Therefore, it is a good idea to understand each of the
#' approaches.
#' @end
