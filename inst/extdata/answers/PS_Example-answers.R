# PS-Example: Example practice set
#    An example that illustrates the essentials of practice sets.
# ---
practice.begin("PS-Example", learner="Dave H.")

# Initial variables
library(dplyr)
   X <- c(1,2,3)
   cDF <- data.frame(A=c(1,2,3,4), B=c('a','b','c','d'), C=c(T,F,T,T))

# a: Add ten, nine, and eight together. (sum1)
   sum1 <- 10 + 9 + 8

# b: Add 10 to each of the elements of vector X. (v1)
   v1 <- X + 10

# Note: Working with functions

# c: Write a function, named `what_is_pi` which returns pi (3.1415). (what_is_pi)
   what_is_pi <- function() {
     return(pi)
   }

# d: Create a function that squares a number. (squared)
   squared <- function(x) {
     return(x^2)
   }

# e: Define a function, named `imperial_to_metric`, that takes in two arguments: a
#    number of feet and a number of inches. The function should return the
#    equivalent length in meters. (imperial_to_metric)
   imperial_to_metric <- function(feet, inches) {
     total_inches <- feet * 12 + inches
     meters <- total_inches * 0.0254
     meters
   }

# Note: Working with dataframes

# f: Select rows from cDF, where C==TRUE. Show only A and C columns. (df4)
   df4 <- cDF %>%
     filter(C==TRUE) %>%
     select(A,C)
