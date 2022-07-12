# pinfo201 / ps-1
#
# PS-Example: Example practice set
#    This file illustrates the essentials of specifying a practice set. It
#    show what kinds of prompts can be presented to #' students and what can be
#    tested.

# Practice set info ----
practice.begin("PS-Example", learner="[your name]", email="[your e-mail]")

# Key practice set variables (already initialized) ----
#   library(stats)
#   X <- c(1,2,3)

# Your 7 prompts: (a)-(g) ----

#                                         Note 01.
#    A practice set that illustrates the basics.


# a: Add ten, nine, and eight together. Assign the result to `sum1`. (Variable: sum1)
sum1 <- 10 + 9 + 8

# b: Create a variable `hometown` that stores the city in which you were born. (Variable: hometown)
hometown <- "St. Louis"

# c: Add 10 to each of the elements of vector `X`. (Variable: v1)
v1 <- X + 10

# d: Create 100 random numbers between 40000 and 50000. Round the numbers
#    to two decimal places. (Variable: salaries_2017)
salaries_2017 <- round(runif(100, 40000, 50000),2)

#                                         Note 02.
#    Working with functions.


# e: Write a function, named `what_is_pi`, which returns pi (3.1415). (Variable: what_is_pi)
what_is_pi <- function() {pi}

# f: Write a function, named `squared(x)`, which squares a number. (Variable: squared)
squared <- function(x) {
   t <- x^2
   return(t)
}

# g: Define a function, named `imperial_to_metric`, that takes in two arguments: a
#    number of feet and a number of inches. The function should return the
#    equivalent length in meters. (Variable: imperial_to_metric)
imperial_to_metric <- function(feet, inches) {
   total_inches <- feet * 12 + inches
   meters <- total_inches * 0.0254
   return(meters)
}


