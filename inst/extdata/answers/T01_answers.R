# T01: Test cases: Assignment
#    Test different forms of assignment statements
# ---
practice.begin("T01", learner="[your name]")

# Initial variables
X <- c(1,2,3)
f <- function(x) {return(x+1)}
meals1 <- list(a="aa", b="bb")
meals2 <- list(a="aa", b="bb")

# Note: Basic expressions

# a: An expression (implicit variable) [t01 <- sqrt((1+2+3)^2)*2  # 12] (t01)
t01 <- sqrt((1+2+3)^2)*2  # 12

# b: A block expression - two lines (explicit variable)
#    t02 <- {  ... } (t02)
t02 <- {
  t <- 10
  t <- t + 100
  (t == 110)
}

# c: Semi-colon  (explicit variable) (t03)
t03a <- t01 + 100; t03 <- t03a - 100

# d: No braces - two lines (implicit variable) (t04)
t04a <- t01 + 100
t04 <- t04a - 100

# e: Using previous variable (initialized by learner) (t05)
t05 <- ((t01 - 12) == 0) # TRUE

# f: Using an initial variable (initialized by practice set) (t06)
t06 <- sum(c(6,12,18) == ((X + X) * 3)) == 3  # TRUE

# g: Calling a function, f(x), (initialized by the practice set) (t07)
t07 <- (f(10) == 11) # TRUE

# h: Assign several variables and check the last variable - e.g.,
#      x <- 1
#      y <- x + 1
#      z <- y + 1 (z)
x <- 1
y <- x + 1
z <- y + 1
w <- -10

# Note: Various forms of assignment operations. Curently, only ONE level of nested structure
#    works.  For example, these structures will fail:
#        t$x$y <- blah
#        t[[a]][[b]] <- blah

# i: Assignment to element of a vector
#       U <- X
#       U[1] <- 100 (U)
U <- X
U[1] <- 100

# j: Assignment to two lists
#       meals <- list(a="aa", b="bb") (meals)
meals <- list(a="aa", b="bb")

# k: Sub-select a list with dollar sign
#       meals <- list(a="aa", b="bb") (meals1)
meals1$a <- "aaaaaaaaa"

# l: Sub-select a list with double square brackets ([[]])
#       meals[[2]] <- 'bbbbbbbbbb' (meals2)
meals2[[2]] <- 'bbbbbbbbbb'
