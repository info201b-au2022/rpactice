#' @version ps-1
#' @short T02
#' @title Test cases: Vectors
#' @descr
#' Test statements that return vectors
#' @end
#' @initial-vars
X <- c(1,2,3,4)
#' @end

#' @id ?
#' @msg Create a vector with four elements, 1-4
#' @code
t01 <- c(1,2,3,4)
#' @end

#' @id ?
#' @msg A vector
#' @var t02
#' @code
round(seq(1:15)*pi,1)
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
t03[t03 > 4] #A: c(6 8)
#' @end

#' @id ?
#' @msg Add two vectors (X initialized in problem set)
#' @var t05
#' @code
X + t01 #A: c(2,4,6,8)
#' @end


