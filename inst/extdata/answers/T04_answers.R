# pinfo201 / ps-1
#
# T04: Test cases: Vectors
#    Test statements that return vectors

# Practice set info ----
practice.begin("T04", learner="[your name]", uwnetid="[your UW NetId]")

# Initial variables ----
   X <- c(1,2,3,4)

# Your 5 prompts: (a)-(e) ----

# a: Create a vector with four elements, 1-4 (Variable: t01)
t01 <- c(1,2,3,4)

# b: A vector (Variable: t02)
t02 <- round(seq(1:15)*pi,1)

# c: Multiple vector by 2 (Variable: t03)
t03 <- t01 * 2 #A: c(2 4 6 8)

# d: Select items from the vector (Variable: t04)
t04 <- t03[t03 > 4] #A: c(6 8)

# e: Add two vectors (X initialized in problem set) (Variable: t05)
t05 <- X + t01 #A: c(2,4,6,8)


