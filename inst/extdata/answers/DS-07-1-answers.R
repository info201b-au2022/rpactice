# DS-7-1: Creating and operating on vectors
#    Exercise 7.1 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-07-1", learner="[your name]")

# a: Create a vector `names` that contains the names of three people,
#    namely "Alex," "Drew," and "Jordan." Be sure to print out the vector
#    with the command `print(names)`. (names)
names <- c("Alex", "Drew", "Jordan")

# b: Use the colon operator : to create a vector, named `n`, of numbers from 10 to 49. (n)
n <- 10:49

# c: Use the `length()` function to get the number of elements in `n`.  Assign the length
#    to the variable n_len (n_len)
n_len <- length(n)

# d: Add 1 to each element in `n`. Assign this new vector to `n1`. (n1)
n1 <- n + 1

# e: Create a vector `m` that contains the numbers 10 to 1 (in that order).
#    Hint: use the `seq()` function. (m)
m <- seq(10,1)

# f: Subtract `m` FROM `n`. Assign the new vector to v1. Note the recycling! (v1)
v1 <- n - m

# g: Use the `seq()` function to produce a range of numbers from -5 to 10 in `0.1`
#    increments. Store it in a variable `x_range` (x_range)
x_range <- seq(-5, 10, 0.1)

# h: Create a vector `sin_wave` by calling the `sin()` function on each element
#    in `x_range`. ` (sin_wave)
sin_wave <- sin(x_range)

# i: Create a vector `cos_wave` by calling the `cos()` function on each element
#    in `x_range`. (cos_wave)
cos_wave <- cos(x_range)

# j: Create a vector `wave` by multiplying `sin_wave` and `cos_wave` together, then
#    adding `sin_wave` to the product (wave)
wave <- (sin_wave * cos_wave) + sin_wave

# Note: Use the `plot()` function to plot your `wave`!




