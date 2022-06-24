# Problem Set ONE ----
#----------------------------------------------------------------------------#
# Practice Set One
#----------------------------------------------------------------------------#

#' @version ps-1
#' @short P01
#' @title Basic Arithmetic Operators
#' @descr
#'Practice using the basic arithmetic operators.
#'     1. You should know how to use these operator: +, -, *, / ,^ , %%, %/%
#'     2. For order of operations, you should know how to use parenthesis:  (, )
#'     3. You should know the meaning of: Inf, -Inf, and NaN
#' @end
#' @initial-vars
X <- 10
Y <- c(1,2,3)
#' @end

#' @id a
#' @msg Add ten, nine, and eight together.
#' @code
t_01 <- 10 + 9 + 8
#' @end
#' @hints
#' Do you use the math plus operator (+)?
#' Do you use the assignment operator (<-)?
#' Is the variable name (t_01) correct?
#' @end

#' @id b
#' @msg What is 111 divided by 9?
#' @code
num <- 111 / 9
#' @end

#' @id c
#' @msg What is the average of 1, 17, 19, and 31?
#' @code
t_03 <- (1 + 17 + 19 + 31) / 4
#' @end

#' @id d
#' @msg What is the average of these Celsius temperatures: -5C, -10C, -12C?
#' @code
t_04 <- (-5 + -10 + -12) / 3
#' @end
#' #' @hints
#' Have you removed the temperature units (C)?
#' Have you include the negative sign for each number?
#' Is the variable name correct (t_04)?
#' @end

#' @id e
#' @msg Use the exponent operator (^ or **) to compute 2 to the 20th power.
#' @code
t_05 <- 2^20
#' @end
#' @hints
#' Check the exponent. Is it 20?
#' Check the base number. Is it 2?
#' Is the variable name correct (t_05)?
#' @end

#' @id f
#' @msg What is 3.4 cubed?
#' @code
t_06 <- 3.4**3
#' @end

#' @id g
#' @msg Compute the reciprocal 2 to 8th power (2^(-8) or 1 / 2^8).
#' @code
t_07 <- 2^-8
#' @end

#' @id h
#' @msg Use the modulus operator (%%) to compute the remainder of 111 divided by 4.
#' @code
t_08 <- 111 %% 4
#' @end

#' @id i
#' @msg Use integer division (%/%) to compute the quotient of 111 divided by 3.
#' @code
t_09 <- 111 %/% 3
#' @end

#' @id j
#' @msg In R, pi is a built-in constant (3.141593). Given a circle with radius 4 (r), what is its area? (Recall: A = pi*r^2)
#' @code
A <- pi * 4^2
#' @end

#' @id -
#' @msg R is able to represent the mathematical concept of infinity. Consider:

#' @id k
#' @msg In R, Inf means 'positive infinity.' What is 7 / 0?
#' @code
t_10 <- 7 /0
#' @end

#' @id l
#' @msg In R, -Inf means 'negative infinity.' What is -7 / 0?
#' @code
t_11 <- -7 / 0
#' @end

#' @id m
#' @msg In R, NaN means 'Not a Number'. What is 0 / 0?
#' @code
t_12 <- 0 / 0
#' @end
