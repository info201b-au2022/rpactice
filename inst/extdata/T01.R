#' @version ps-1
#' @short T01
#' @title Test cases: Assignment
#' @descr
#' Test different forms of assignment statements
#' @end
#' @initial-vars
X <- c(1,2,3)
f <- function(x) {return(x+1)}
#' @end

#' @id -
#' @msg Basic expressions

#' @id ?
#' @msg An expression, where t01 is assigned sqrt((1+2+3)^2)*2
#' @code
t01 <- sqrt((1+2+3)^2)*2  # Answer: 12
#' @end

#' @id ?
#' @msg
#' A block expression, where t02 is assigned the following:
#' {
#'    t <- 10
#'    t <- t + 100
#'    (t == 110)
#' }
#' t02 <- {  ... }
#' @end
#' @var t02
#' @code
t02 <- {
  t <- 10
  t <- t + 100
  (t == 110)
}
#' @end

#' @id ?
#' @msg An expression with a semi-colon
#' @code
t03a <- t01 + 100; t03 <- t03a - 100
#' @end

#' @id ?
#' @msg An expression with two lines
#' @code
t04a <- t01 + 100
t04 <- t04a - 100
#' @end

#' @id ?
#' @msg Using a pre-set variable (initialized by practice set)
#' @code
t06 <- sum(c(6,12,18) == ((X + X) * 3)) == 3  # TRUE
#' @end

#' @id ?
#' @msg Calling a pre-set function, f(x), (initialized by the practice set)
#' @code
t07 <- (f(10) == 11) # TRUE
#' @end

#' @id ?
#' @msg
#' Assign several variables and check a particular variable (z)
#'   x <- 1
#'   y <- x + 1
#'   z <- y + 1
#' @end
#' @var z
#' @code
x <- 1
y <- x + 1
z <- y + 1
w <- -10
#' @end
