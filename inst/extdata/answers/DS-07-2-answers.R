# DS-7-2: Indexing and filtering vectors
#    Exercise 7.2 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-7-2", learner="[your name]")

# a: Create a vector `first_ten` that has the values 10 through 20 in it (using
#    the : operator). (first_ten)
first_ten <- 10:20

# b: Create a vector `next_ten` that has the values 21 through 30 in it (using the
#    seq() function). (next_ten)
next_ten <- seq(21,30,1)

# c: Create a vector `all_numbers` by combining the previous two vectors. (all_numbers)
all_numbers <- append(first_ten, next_ten)

# d: Create a variable `eleventh` that contains the 11th element in `all_numbers`. (eleventh)
eleventh <- all_numbers[11]

# e: Create a vector `some_numbers` that contains the 2nd through the 5th elements
#    of `all_numbers`. (some_numbers)
some_numbers <- all_numbers[2:5]

# f: Create a vector `even` that holds the even numbers from 1 to 100. (even)
even <- seq(2,100,2)

# g: Using the `all()` function and `%%` (modulo) operator, confirm that all of the
#    numbers in your `even` vector are even. Assign your answer to the
#    variable, `even_check`. (even_check)
even_check <- all(seq(2,100,2) %% 2 == 0)

# h: Create a vector `phone_numbers` that contains the numbers 8, 6, 7, 5, 3, 0, 9. (phone_numbers)
phone_numbers <- c(8,6,7,5,3,0,9)

# i: Create a vector `prefix` that has the first three elements of `phone_numbers`. (prefix)
prefix <- phone_numbers[1:3]

# # j: Create a vector `small` that has the values of `phone_numbers` that are
# #    less than or equal to 5. (small)
small <- phone_numbers[phone_numbers<=5]

# k: Create a vector `large` that has the values of `phone_numbers` that are
#    strictly greater than 5. "Strictly" mean greater than. (large)
large <- phone_numbers[phone_numbers > 5]

# # l: Assign `phone_numbers` to the variable `phone_numbers2`.
# #    Replace the values in `phone_numbers2` that are larger than 5 with the number 5. (phone_numbers2[phone_numbers2 > 5])
# phone_numbers2 <- phone_numbers
# phone_numbers2[phone_numbers2 > 5] <- 5
# phone_numbers2
#
# phone_numbers2a <- phone_numbers
# phone_numbers2a[phone_numbers2a > 5] <- 5
# identical(phone_numbers2, phone_numbers2a)

# # m: Assign `phone_numbers2` to the variable `phone_numbers3`. Replace every odd-numbered
# #    value in `phone_numbers3` with the number 0. (phone_numbers3[phone_numbers3%%2 == 1])
# phone_numbers3 <- phone_numbers
# phone_numbers3[phone_numbers3%%2==1] <- 0
# phone_numbers3

