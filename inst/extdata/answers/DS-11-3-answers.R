# pinfo201 / ps-1
#
# DS-11-3: Using the pipe operator
#    Exercise 11.3 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-11-3", learner="[your name]", email="[your e-mail]")

# Key practice set variables (already initialized) ----
#   library("dplyr")
#   library("fueleconomy")

# Your 11 prompts: (a)-(k) ----

#                                         Note 01.
#    For this practice set, you will need to install and load the `fueleconomy`
#    package. Here are the commands for doing so:
#       > install.packages("devtools")                      One time only
#       > devtools::install_github("hadley/fueleconomy")    One time only
library(fueleconomy)
#
#    In addition, you will need to install the `dplyr` library. `dplyr` comes with
#    the `tidyverse`, which you should have already installed into your system. In
#    case not, here is the command:
#       install.packages("tidyverse")      One time only
#
#    Finally, to use `dplyr`, you use the `library()` statement, like this:
library("dplyr")


#                                         Note 02.
#    Which 2015 Acura model has the best hwy mileage? To answer this question, use
#    `dplyr` with temporary variables, `acuras`, `best_acura`, and `best_model`,
#    for the following prompts.


# a: Filter for "Acura" and the year 2015 (Variable: acuras)
acuras <- filter(vehicles, make == "Acura", year == 2015)

# b: Filter for 2015 "Acura" with the best hwy mileage. (Variable: best_acura)
best_acura <- filter(acuras, hwy == max(hwy))

# c: Select the model. (Variable: best_model1)
best_model1 <- select(best_acura, model)

# d: Which 2015 Acura model has the best hwy MPG? To answer this prompt, use `dplyr`
#    and nested functions (one statement with nested functions). (Variable: best_model2)
best_model2 <- select(
  filter(
    filter(vehicles, make == "Acura", year == 2015), hwy == max(hwy)
  ), model
)

# e: Which 2015 Acura model has the best hwy MPG? To answer this prompt, use `dplyr`
#    and pipe operators (one statement with pipe operators). (Variable: best_model3)
best_model3 <- filter(vehicles, make == "Acura", year == 2015) %>%
  filter(hwy == max(hwy)) %>%
  select(model)

#                                         Note 03.
#    **Enrichment**. You have computed the same result in three different ways.
#    One question you might ask: Which approach is more efficient? One way to
#    answer this question is to time how long it takes to compute the answers with
#    each of the three above approaches and compare.
#
#    R provides a function, `system.time()`, for doing so. This function
#    takes an expression and reports the  time required to run the expression.
#    If `f()` is simply a function that computes something, here's the code:
#       > system.time(f())
#
#    To see differences, we often repeat the execution of a function 100 to
#    1,000 times. So the general pattern is the following:
#       > system.time(for(k in 1:1000) f())
#
#    This will run a function, `f()` one thousand times and report the length of
#    time that it took.
#
#    In the following prompts, you will create functions for the above three
#    approaches and compare their performance.


# f: Write a function, `temp_vars_best_model`, with variable chaining. (Variable: temp_vars_best_model)
temp_vars_best_model <- function() {
  acuras <- filter(vehicles, make == "Acura", year == 2015)
  best.acura <- filter(acuras, hwy == max(hwy))
  best.model <- select(best_acura, model)
}

# g: Write a function, `nested_best_model`, with nested functions. (Variable: nested_best_model)
nested_best_model <- function() {
  best_model <- select(
    filter(
      filter(vehicles, make == "Acura", year == 2015), hwy == max(hwy)
    ), model
  )
}

# h: Write a function, `pipe_best_model`, with pipe operators. (Variable: pipe_best_model)
pipe_best_model <- function() {
  best_model <- filter(vehicles, make == "Acura", year == 2015) %>%
    filter(hwy == max(hwy)) %>%
    select(model)
}

# i: How long does it take to compute `temp_vars_best_model()` 1000 times? (Variable: time_temp_vars)
time_temp_vars <- system.time(for (i in 1:1000) temp_vars_best_model())

# j: How long does it take to compute `nested_best_model()` 1000 times? (Variable: time_nested)
time_nested <- system.time(for (i in 1:1000) nested_best_model())

# k: How long does it take to compute `pipe_best_model()` 1000 times? (Variable: time_pipes)
time_pipes <- system.time(for (i in 1:1000) pipe_best_model())

#                                         Note 04.
#    Are the times more or less the same?  If so, then you should you use
#    temporary, nested, or piped however you like.  In general, use the approach
#    that is the easiest to understand. The approach you use may vary depending on
#    circumstances. Therefore, it is a good idea to understand each of the
#    approaches.



