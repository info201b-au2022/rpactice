# T03: Test cases: Functions
#    Test statements that return functions (including the @check tag)
# ---
practice.begin("T03", learner="[your name]")

# Initial variables
g <- function(x) {return(x+1)}

# a: Call the pre-installed function, g(x), with ten. Does this result make sense? (t01)
t01 <- g(10)  #A: 11

# b: Write a function, named `what_is_pi()`, which returns pi (3.1415). [f()] (what_is_pi)
what_is_pi <- function() {
  return(pi)
}
# c: Write a function, named `squared` that takes one numeric argument and squares the number. [f(arg1)] (squared)
squared <- function(arg1) {
  s <- arg1^2
  return(s)
}

# d: Use the function, `squared()`, to test that it works for the number 100. (t02)
t02 <- squared(100)

# e: Test a function with two arguments - correctness is tested with a callback (see g.T03_Check()) [f(arg1,arg2)] (h)
h <- function(num, prec) {
  rounded <- round(num + pi, prec)
  return(rounded)
}

practice.check()

