# P02: Using vectors and basic functions
#    Check into length() and sum()
# ---
practice.begin("P02", learner="[your name]")

# Initial variables
X <- c(1,2,3,4)

# a: How many elements are in the vector X? (num)3
num <- length(X)

# b: Use a function to compute the sum of the numbers in vector X? (sum_of_X)
sum_of_X <- sum(X)

# c: Create a vector with these three elements: 1, 2, 3. (v1)
v1 <- c(1,2,3)

# d: Add 5 to each element of the vector X. (v2)
v2 <- X + 5

# e: Make a function (f)
f <- function(x) {10 * x}
