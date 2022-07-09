# pinfo201 / ps-1
#
# T04: Test cases: Vectors
#    Test statements that return vectors

# Practice set info ----
practice.begin("T04", learner="[your name]", email="[your UW NetId]")

# Key practice set variables (already initialized) ----
#   X <- c(1,2,3,4)
#   Y <- c(4,3,2,1)
#   Z <- 1:1000

# Your 7 prompts: (a)-(g) ----

# a: Create a vector with four elements, 1-4 (Variable: t00)
t00 <- X * 2

# b: Create a vector with four elements, 1-4 (Variable: t01)
t01 <- c(1,2,3,4) + X + Y

# c: A vector (Variable: t02a)
t02a <- round(Z*pi,1)

# d: A vector (Variable: t02b)
t02b <- (sum(round(Z*pi,1) == round((1:1000)*pi,1)) == 1000)

# e: Multiple vector by 2 (Variable: t03)
t03 <- t01 * 2 #A: c(2 4 6 8)

# f: Select items from the vector (Variable: t04)
t04 <- t03[t03 > 4] #A: c(6 8)

# g: Add two vectors (X initialized in problem set) (Variable: t05)
t05 <- X + t01 #A: c(2,4,6,8)


