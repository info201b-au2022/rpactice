# pinfo201 / ps-1
#
# T01: Test cases: Assignment
#    Test different forms of assignment statements

# Practice set info ----
practice.begin("T01", learner="[your name]", uwnetid="[your UW NetId]")

# Initial variables ----
   X <- c(1,2,3)
   f <- function(x) {return(x+1)}

# Your 8 prompts: (a)-(h) ----

#                                         Note 01.
#    Basic expressions


# a: An expression (implicit variable) [t01 <- sqrt((1+2+3)^2)*2  # 12] (Variable: t01)
t01 <- sqrt((1+2+3)^2)*2  # 12

# b: A block expression - two lines (explicit variable)
#    t02 <- {  ... } (Variable: t02)
t02 <- {
  t <- 10
  t <- t + 100
  (t == 110)
}

# c: Semi-colon  (explicit variable) (Variable: t03)
t03a <- t01 + 100; t03 <- t03a - 100

# d: No braces - two lines (implicit variable) (Variable: t04)
t04a <- t01 + 100
t04 <- t04a - 100

# e: Using previous variable (initialized by learner) (Variable: t05)
t05 <- ((t01 - 12) == 0) # TRUE

# f: Using an initial variable (initialized by practice set) (Variable: t06)
t06 <- sum(c(6,12,18) == ((X + X) * 3)) == 3  # TRUE

# g: Calling a function, f(x), (initialized by the practice set) (Variable: t07)
t07 <- (f(10) == 11) # TRUE

# h: Assign several variables and check a particular variable (z)
#      x <- 1
#      y <- x + 1
#      z <- y + 1 (Variable: z)
x <- 1
y <- x + 1
z <- y + 1
w <- -10


