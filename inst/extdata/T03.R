#' @version ps-1
#' @short T03
#' @title Test cases: Assignment
#' @descr
#' Test different forms of assignment statements
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id -
#' @msg Complex lhs structures and assignments

#' @id -
#' @msg
#' Currently, only ONE level of nested structure. For example, these structures will fail
#' because pinfo201 cannot determine the name of the variable:
#'     t$x$y <- blah
#'     t[[a]][[b]] <- blah
#'     t[[k]]$x <- blah
#' @end

#' @id ?
#' @msg
#' Assignment to element of a vector. This works.
#'    U <- X
#'    U[1] <- 100
#' @var U
#' @code
U <- X
U[1] <- 100
#' @end

#' @id -
#' @msg
#' Assignment to two lists
#'    meals <- list(a="aa", b="bb")
#' @code
meals <- list(breakfaset="toast", lunch="soup", dinner="lentis and rice")
#' @end

#' @id -
#' @msg
#' Sub-select a list with dollar sign ($)
#'    meals$breakfast <- "oatmeal"
#' @code
meals$breakfast <- "oatmeal"
#' @end

#' @id -
#' @msg
#' Sub-select a list with double square brackets ([[]])
#'    meals2[[2]] <- 'cheese sandwich'
#' @code
meals[[2]] <- 'cheese sandwich'
#' @end

#' @id -
#' @msg
#' Check that meals is correct, by assigning `meals` to `meals_done`.
#' @code
meals_done <- meals
#' @end

