# T03: Test cases: Functions
practice.begin("T03")

# a: Call function that is pre-installed (t01)
t01 <- g(10)  #A: 11

# b: Create a function that squares a number (squared)
squared <- function(arg1) {
  s <- arg1^2
  return(s)
}

# c: Use the function (t02)
t02 <- squared(100)

# d: Test a function with a vector of inputs (f)
f <- function(arg1) {
   t <- arg1 + 1
   return(t)
}

# e: Test a function with two arguments - and call a callback function (g)
  h <- function(num, p) {
    t <- round(num + pi, p)
    return(t)
  }

practice.check()
