#' @version ps-1
#' @short T01
#' @title Test cases: Assignment
#' @descr
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id -
#' @msg Basic expressions

#' @id ?
#' @msg An expression (implicit variable)
#' @code
t01 <- sqrt((1+2+3)^2)*2  # 12
#' @end

#' @id ?
#' @msg A block expression - two lines (explicit variable)
#' @var t02
#' @code
t02 <- {  # TRUE
  t <- 10
  t <- t + 100
  (t == 110)
}
#' @end

#' @id ?
#' @msg Semi-colon  (explicit variable)
#' @var t03
#' @code
t03a <- t01 + 100; t03 <- t03a - 100
#' @end

#' @id ?
#' @msg No braces - two lines (implicit variable)
#' @code
t04a <- t01 + 100
t04 <- t04a - 100
#' @end

#' @id ?
#' @msg Using previous variable (initialized by learner)
#' @code
t06 <- ((t01 - 12) == 0) # TRUE
#' @end

#' @id ?
#' @msg Using an initial variable (initialized by practice set)
#' @code
t04a <- sum(c(6,12,18) == ((X + X) * 3)) == 3 # TRUE
#' @end
#
#' @id ?
#' @msg Calling a function, f(x), (initialized by the practice set)
#' @code
t04b <- (f(10) == 11) # TRUE
#' @end

#' @id ?
#' @msg Update an initial variable
#' @code
X <- 10
#' @end

#' @id ?
#' @msg Is it retrieved correctly?
#' @code
t05 <- (10 == X) #TRUE
#' @end



