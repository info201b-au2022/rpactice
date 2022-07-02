#' @version ps-1
#' @short T10
#' @title Interpretation issues / errors
#' @descr
#' For debugging
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id -
#' @msg Create a list, L, with three elements a, b, and c
#' @code
L <- list(a="a" , b="b", c="c")
#' @end

#' @id -
#' @msg
#' Change the value of a to "aaa"
#' @end
#' @code
L$a <- "aaaa"
#' @end

#' @id -
#' @msg
#' Change the value of b to "bbb"
#' @end
#' @code
L$b <- "aaaa"
#' @end

#' @id ?
#' @msg
#' Check ...
#' @end
#' @code
all_done <- L
#' @end


#' @id -
#' @msg
#' 1. Create a list, L, with three elements a, b, and c
#' 2. Change the value of a to "aaa"
#' 3. Change the value of b to "bbb"
#' @end
#' @code
L <- list(a="a" , b="b", c="c")
L$a <- "aaaa"
L$b <- "aaaa"
#' @end

#' @id ?
#' @msg
#' Check ...
#' @end
#' @code
all_done2 <- L
#' @end
#'
#'
