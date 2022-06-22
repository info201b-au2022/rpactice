#' @version ps-1
#' @short T02
#' @title Test cases: Vectors
#' @descr
#' @end
#' @initial-vars
X <- c(1,2,3,4)
#' @end

#' @id -
#' @msg Vectors

#' @id ?
#' @msg Create a vector with five elements, 1-5
#' @code
t01 <- c(1,2,3,4)
#' @end

#' @id ?
#' @msg Multiple vector by 2
#' @code
t02 <- t01 * 2 #A: c(2 4 6 8)
#' @end

#' @id ?
#' @msg Select items from the vector
#' @var t03
#' @code
t02[t02 > 4] #A: c(6 8)
#' @end

#' @id ?
#' @msg Add two vectors (X initialized in problem set)
#' @var t04
#' @code
t04 <- X + t01 #A: c(2,4,6,8)
#' @end

