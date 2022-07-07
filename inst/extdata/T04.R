#' @version ps-1
#' @short T04
#' @title Test cases: Vectors
#' @descr
#' Test statements that return vectors
#' @end
#' @initial-vars
X <- c(1,2,3,4)
Y <- c(4,3,2,1)
Z <- 1:1000
#' @end

#' #' @id ?
#' @msg Create a vector with four elements, 1-4
#' @code
t00 <- X * 2
#' @end

#' @id ?
#' @msg Create a vector with four elements, 1-4
#' @code
t01 <- c(1,2,3,4) + X + Y
#' @end

#' @id ?
#' @msg A vector
#' @code
t02a <- round(Z*pi,1)
#' @end

#' @id ?
#' @msg A vector
#' @code
t02b <- (sum(round(Z*pi,1) == round((1:1000)*pi,1)) == 1000)
#' @end

#' @id ?
#' @msg Multiple vector by 2
#' @code
t03 <- t01 * 2 #A: c(2 4 6 8)
#' @end

#' @id ?
#' @msg Select items from the vector
#' @var t04
#' @code
t04 <- t03[t03 > 4] #A: c(6 8)
#' @end

#' @id ?
#' @msg Add two vectors (X initialized in problem set)
#' @code
t05 <- X + t01 #A: c(2,4,6,8)
#' @end
