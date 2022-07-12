# pinfo201 / ps-1
#
# DS-10-3: Working with built-in data sets
#    Exercise 10.3 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-10-3", learner="[your name]", email="[your UW NetId]")

# Your 9 prompts: (a)-(i) ----

#                                         Note 01.
#    Load R's "USPersonalExpenditure" data set using the `data()` function. This
#    is the code:
#       > data("USPersonalExpenditure")
data("USPersonalExpenditure")

# a: The variable `USPersonalExpenditure` is now accessible to you. Unfortunately,
#    it's not a dataframe (it's actually a data type called a matrix).
#
#    Using the function `is.data.frame()` check if `USPersonalExpenditure` is a
#    data frame. (Variable: is_var_a_dataframe)
is_var_a_dataframe <- is.data.frame(USPersonalExpenditure)

# b: Luckily, you can pass the USPersonalExpenditure variable as an argument to the
#    `data.frame()` function to convert it a dataframe.
#
#    Do this, storing the result in a new variable, named `us_exp`. (Variable: us_exp)
us_exp <- data.frame(USPersonalExpenditure)

# c: What are the column names of your dataframe? (Variable: c_names)
c_names <- colnames(us_exp)

#                                         Note 02.
#    Print the column names. Consider: Why are they so strange? Think about
#    whether you could use a number like 1940 with dollar notation!


# d: What are the row names of your dataframe? (Variable: r_names)
r_names <- rownames(us_exp)

#                                         Note 03.
#    Add a column, named `category`, to your dataframe, which contains the rownames.
us_exp$category <- rownames(us_exp)

# e: How much money was spent on personal care in 1940? (Variable: care_1940)
care_1940 <- us_exp["Personal Care", "X1940"]

# f: How much money was spent on Food and Tobacco in 1960? (Variable: food_1960)
food_1960 <- us_exp["Food and Tobacco", "X1960"]

# g: What was the highest expenditure category in 1960? (Variable: highest_1960)
highest_1960 <- us_exp$category[us_exp$X1960 == max(us_exp$X1960)]

# h: Define a function `lowest_category` that takes in a year as a parameter, and
#    returns the lowest spending category of that year. (Variable: lowest_category)
lowest_category <- function(year) {
  col <- paste0("X", year)
  us_exp$category[us_exp[, col] == min(us_exp[, col])]
}

# i: Using your function, determine the lowest spending category of each year.
#    Hint: use the `sapply()` function to apply your function to a vector of
#    years (Variable: lowest)
lowest <- sapply(seq(1940, 1960, 5), lowest_category)


