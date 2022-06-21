#' @version ps-1
#' @short PS-T01
#' @title Test Cases
#' @descr
#' A set of cases for testing the pinfo201 package.
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id -
#' @msg Basic expressions

#' @id ?
#' @msg An expression
#' @code
t01 <- sqrt((1+2+3)^2)*2  # 12
#' @end
#'
#' @id ?
#' @msg Using previous variable (initialized by learner)
#' @code
t02 <- ((t01 - 12) == 0) # TRUE
#' @end
#'
#' @id ?
#' @msg Using an initial variable (initialized by problem set)
#' @code
t03 <- sum(c(6,12,18) == ((X + X) * 3)) == 3 # TRUE
#' @end
#'
#' @id ?
#' @msg Update an initial variable
#' @code
X <- 10
#' @end
#'
#' @id ?
#' @msg Is it retrieved correctly?
#' @code
t04 <- (10 == X) #TRUE
#' @end
#'

#' @id -
#' @msg Vectors

#' @id ?
#' @msg Create a vector with five elements, 1-5
#' @code
t05 <- c(1,2,3,4)
#' @end
#'
#' @id ?
#' @msg Multiple vector by 2
#' @code
t06 <- t05 * 2 # c(2 4 6 8)
#' @end
#' @id ?

#' @msg Select items from the vector
#' @code
t07 <- t06[t06 > 4] # c(6 8)
#' @end

#' @id -
#' @msg Functions

#' @id -
#' @msg Select items from the vector
#' @code
t07 <- t06[t06 > 4] # c(6 8)
#' @end
