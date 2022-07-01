#' @version ps-1
#' @short T00
#' @title Super basic test for debugging
#' @descr
#' For debugging - this practice set contains almost nothing!
#' @end
#' @initial-vars
X <- c(1,2,3)
L <- list(a="aa", b="bb")
#' @end

#' @id ?
#' @msg What is 1 + 1
#' @code
t <- 2
#' @end

#' @id -
#' @msg
#' Change the attributes for the list, L, so that a is "aaaa" and b is "bbbb"
#' @end
#' @code
L$a <- "aaaa"
L[[2]] <- "bbbb"
#' @end

#' @id ?
#' @msg
#' To check the result, assign L to L1
#' @end
#' @var L1
#' @code
L1 <- L
#' @end
