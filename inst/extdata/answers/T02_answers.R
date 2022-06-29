# T02: Test cases: Vectors
#    Test statements that return vectors
# ---
practice.begin("T02", learner="[your name]")

# Initial variables
X <- c(1,2,3,4)

# a: Create a vector with four elements, 1-4 (t01)
t01 <- c(1,2,3,4)

# b: A vector (t02)
t02 <- round(seq(1:15)*pi,1)

# c: Multiple vector by 2 (t03)
t03 <- t01 * 2 #A: c(2 4 6 8)

# d: Select items from the vector (t04)
t04 <- t03[t03 > 4] #A: c(6 8)

# e: Add two vectors (X initialized in problem set) (t05)
t05 <- X + t01 #A: c(2,4,6,8)
