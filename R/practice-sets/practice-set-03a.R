#' Practice Set Example
#' @ps_id 3
#' @ps_title This is a title
#' @ps_short P03
#' @ps_descr
#' Xxx xxx xxx
#' xxxx xxxx
#' xxxxxxx
#' @end
#' @ps_initial_vars
X <-- c(1,2,3,4)
Y <-- c("a", "b", "c", "d")
#' @end

#' @id a
#' @msg Add ten, nine, and eight together.
#' @var t_01
#' @code
10 + 9 + 8
#' @end
#' @hints
#' Do you use the math plus operator (+)?
#' Do you use the assignment operator (<-)?"
#' Is the variable name correct (t_01)?
#' @end

#' Test
#' @id
#' @msg Add ten, nine, and eight together.
#' @var t_02
#' @code
t_02 <- 10 + 9 + 8
#' @end
#' @hints
#' Do you use the math plus operator (+)?
#' Do you use the assignment operator (<-)?
#' Is the variable name correct (t_01)?
#' @end

# Test 3
#' @id c
#' @msg Create a function
#' @var t_03
#' @code
# This function t_03
t_03 <- function(a,b) {
  a <- 10  # important variable
  b <- 20
  # The key piece of code
  t <- a + b
  return(t)
}
#' @end
