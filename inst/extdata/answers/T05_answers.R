# pinfo201 / ps-1
#
# T05: Test cases: Functions
#    Test statements that return functions (including the @check tag)

# Practice set info ----
practice.begin("T05", learner="[your name]", email="[your email]")

# Key practice set variables (already initialized) ----
#   g <- function(x) {return(x+1)}
#   X <- c(1,2,3,4,5,6)

# Your 8 prompts: (a)-(h) ----

# a: Call the pre-installed function, g(x), with ten. Does this result make sense? (Variable: t01)
t01 <- g(10)  #A: 11

# b: Write a function, named `what_is_pi()`, which returns pi (3.1415). [f()] (Variable: what_is_pi)
what_is_pi <- function() {
  return(pi)
}

# c: Write a function, named `squared` that takes one numeric argument and squares the number. [f(arg1)] (Variable: squared)
squared <- function(x) {
  t <- x^2
  return(t)
}

# d: Use the function, `squared()`, to test that it works for the number 100. (Variable: t02)
t02 <- squared(100)

# e: A function with two parameters (Variable: f1)
f1 <- function(arg_one, arg_two) {
  return (arg_one == arg_two)
}

# f: Callback: Test a function with two arguments - correctness is tested with a callback (see g.T03_Check()) [f(arg1,arg2)] (Variable: h)
h <- function(arg1, precision) {
  t <- round(arg1 + pi, precision)
  return(t)
}

# g: Update X[3] to 200 (Variable: X)
X[3] <- 200

# h: Update v[3] to 200 with a function, named f_update (Variable: f_update)
f_update <- function(v) {
  v[3] <- 200
  return(v)
}


