#' @version ps-1
#' @short PS-T01
#' @title Test cases
#' @descr
#' A practice script for testing evaluation. Suggested use:
#'    (1) Use ps::ps_load_internal_ps() to load this practice set.
#'    (2) Use admin.prompts() to run through the evaluations
#' @end
#' @initial-vars
X <- c(1,2,3)
f <- function(a) {a <- a + 1}
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
#' @msg A block expression - two lines
#' @code
{
  t01a <- TRUE
  t01b <- (((t01 - 100) == -88) == t01a)
}
#' @end

#' @id ?
#' @msg Semi-colon
#' @code
t01c <- t01 + 100; t01d <- t01 - 100
#' @end

#' @id ?
#' @msg No braces - two lines
#' @code
t01d <- t01 + 100
t01e <- t01 - 100
#' @end

#' @id ?
#' @msg Using previous variable (initialized by learner)
#' @code
t02 <- ((t01 - 12) == 0) # TRUE
#' @end

#' @id ?
#' @msg Using an initial variable (initialized by practice set)
#' @code
t03a <- sum(c(6,12,18) == ((X + X) * 3)) == 3 # TRUE
#' @end
#
#' @id ?
#' @msg Calling a function, f(x), (initialized by the practice set)
#' @code
t03b <- (f(10) == 11) # TRUE
#' @end

#' @id ?
#' @msg Update an initial variable
#' @code
X <- 10
#' @end

#' @id ?
#' @msg Is it retrieved correctly?
#' @code
t04 <- (10 == X) #TRUE
#' @end

#' @id -
#' @msg Vectors

#' @id ?
#' @msg Create a vector with five elements, 1-5
#' @code
t05 <- c(1,2,3,4)
#' @end

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
#'
#' #' @id ?
#' @msg Select items from the vector
#' @code
t08 <- t06[t06 > 4] # c(6 8)
#' @end
