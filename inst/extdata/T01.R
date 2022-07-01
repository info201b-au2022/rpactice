#' @version ps-1
#' @short T01
#' @title Test cases: Assignment
#' @descr
#' Test different forms of assignment statements
#' @end
#' @initial-vars
X <- c(1,2,3)
f <- function(x) {return(x+1)}
meals1 <- list(a="aa", b="bb")
meals2 <- list(a="aa", b="bb")
#' @end

#' @id -
#' @msg Basic expressions

#' @id ?
#' @msg An expression (implicit variable) [t01 <- sqrt((1+2+3)^2)*2  # 12]
#' @code
t01 <- sqrt((1+2+3)^2)*2  # 12
#' @end

#' @id ?
#' @msg
#' A block expression - two lines (explicit variable)
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
#' @msg Semi-colon  (explicit variable)
#' @var
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
t05 <- ((t01 - 12) == 0) # TRUE
#' @end

#' @id ?
#' @msg Using an initial variable (initialized by practice set)
#' @code
t06 <- sum(c(6,12,18) == ((X + X) * 3)) == 3  # TRUE
#' @end
#
#' @id ?
#' @msg Calling a function, f(x), (initialized by the practice set)
#' @code
t07 <- (f(10) == 11) # TRUE
#' @end

#' @id
#' @msg
#' Assign several variables and check the last variable - e.g.,
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

#' @id -
#' @msg
#' Various forms of assignment operations. Curently, only ONE level of nested structure
#' works.  For example, these structures will fail:
#'     t$x$y <- blah
#'     t[[a]][[b]] <- blah
#' @end

#' @id ?
#' @msg
#' Assignment to element of a vector
#'    U <- X
#'    U[1] <- 100
#' @var U
#' @code
U <- X
U[1] <- 100
#' @end

#' @id ?
#' @msg
#' Assignment to two lists
#'    meals <- list(a="aa", b="bb")
#' @code
meals <- list(a="aa", b="bb")
#' @end

#' @id ?
#' @msg
#' Sub-select a list with dollar sign
#'    meals <- list(a="aa", b="bb")
#' @var meals1
#' @code
meals1$a <- "aaaaaaaaa"
#' @end

#' @id ?
#' @msg
#' Sub-select a list with double square brackets ([[]])
#'    meals[[2]] <- 'bbbbbbbbbb'
#' @var meals2
#' @code
meals2[[2]] <- 'bbbbbbbbbb'
#' @end
