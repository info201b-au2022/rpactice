# T01: Test cases: Assignment
#    Test different forms of assignment statements
# ---
practice.begin("T01", learner="[your name]")

# Initial variables
X <- c(1,2,3)

# Note: Basic expressions

# a: An expression (implicit variable) (t01)
t01 <- sqrt((1+2+3)^2)*2  # 12

# b: A block expression - two lines (explicit variable) (t02)
t02 <- {  # TRUE
  t <- 10
  t <- t + 100
  (t == 110)
}

# c: Semi-colon  (explicit variable) (t03)
t03a <- t01 + 100; t03 <- t03a - 100

# d: No braces - two lines (implicit variable) (t04)
t04a <- t01 + 100
t04 <- t04a - 100

# e: Using previous variable (initialized by learner) (t06)
t06 <- ((t01 - 12) == 0) # TRUE

# f: Using an initial variable (initialized by practice set) (t04a)
t07 <- sum(c(6,12,18) == ((X + X) * 3)) == 3 # TRUE

# g: Calling a function, f(x), (initialized by the practice set) (t04b)
t08 <- (f(10) == 11) # TRUE

practice.check()

