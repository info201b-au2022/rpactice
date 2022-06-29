# FR-06-1: Book: 06: Exercise 1: Calling built-in functions
#
# ---
practice.begin("DS-6-1", learner="[your name]")

# a: Create a variable `my_name` that contains "Grace Hopper", a brilliant computer scientists. (my_name)
my_name <- "Grace Hopper"

# b: Create a variable `name_length` that holds how many letters (including spaces)
#    are in the variable `my_name` (use the `nchar()` function). (name_length)
name_length <- nchar(my_name)

# Note: Print the number of letters in the variable `my_name`.
# print(name_length)

# c: Create a variable `now_doing` that is the name followed by "is programming!"
#    Use the `paste()` function. (now_doing)
now_doing <- paste(my_name, "is programming!")

# d: Make the `now_doing` variable upper case. (now_doing.a)
now_doing.a <- str_to_upper(now_doing)

# Note: Bonus

# Note: Create two variables - `fav_1` and `fav_2` - and, respectively, assign 51 and 76  to
#    these variables.
fav_1 <- 51
fav_2 <- 76

# Note: Divide each of the variables - `fav_1` and `fav_2` - by the square root of 201 and save
#    the new values in the original variables; that is, reuse the variables.
fav_1 <- fav_1 / sqrt(201)
fav_2 <- fav_2 / sqrt(201)

# e: Create a variable `raw_sum` that is the sum of the two variables. Use the
#    `sum()` function for practice. (raw_sum)
raw_sum <- fav_1 + fav_2

# f: Create a variable `round_sum` that is the `raw_sum` rounded to 1 decimal place.
#    Use the `round()` function. (round_sum)
round_sum <- round(raw_sum,1)

# Note: Create two new variables `round_1` and `round_2` that are your `fav_1` and
#    `fav_2` variables rounded to 1 decimal places.
round_1 <- round(fav_1,1)
round_2 <- round(fav_2,1)

# g: Create a variable `sum_round` that is the sum of the rounded values. (sum_round)
sum_round <- sum(round_1,round_2)

# h: Which is bigger, `round_sum` or `sum_round`? Assign your answer to the variable `bigger`. (You can use the `max()` function!) (bigger)
bigger <- max(sum_round, round_sum)

