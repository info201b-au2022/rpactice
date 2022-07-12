# pinfo201 / ps-1
#
# DS-10-2: Working with data frames
#    Exercise 10.2 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-10-2", learner="[your name]", email="[your e-mail]")

# Your 13 prompts: (a)-(m) ----

# a: Create a vector, named `employees`, containing 100 employees ("Employee 1",
#    "Employee 2", ... "Employee 100"). (Hint: Use the `paste()` function and
#    vector recycling. This will allow use to add numbers to the word "Employee." (Variable: employees)
employees <- paste("Employee", 1:100)

# b: Create a vector, named `salaries_2017`, that has 100 random numbers between
#    $40,000 - $50,000. Round these number to 2 decimal places.
#
#    Note: The function `runif()` can be used to create random numbers. For
#    example, this statement will create 5 random numbers between 10 and 20:
#       > runif(5, 10, 20) (Variable: salaries_2017)
salaries_2017 <- round(runif(100, 40000, 50000),2)

# c: In addition, create a vector, named `salary_adjustments`. This vector should contain
#    100 random numbers between -5000 and 10000, with each number representing an
#    adjustment, either positive or negative. (Variable: salary_adjustments)
salary_adjustments <- round(runif(100, -5000, 10000),2)

# d: Create a data frame, named `salaries`, by combining these three vectors:
#       1. `employees`
#       2. `salaries_2017`
#       3. `salary_adjustments`
#
#    Remember to set `stringsAsFactors=FALSE`! (Variable: salaries)
salaries <- data.frame(employees, salaries_2017, salary_adjustments, stringsAsFactors = FALSE)

#                                         Note 01.
#    Add a column, named `salaries_2018`, to the `salaries` dataframe that
#    represents each person's salary in 2018 (e.g., with the salary adjustment
#    added in).
salaries$salaries_2018 <- salaries$salaries_2017 + salaries$salary_adjustments

#                                         Note 02.
#    Add a column to the `salaries` data frame that has a value of `TRUE` if the
#    person got a raise (that is, their salary went up).
salaries$got_raise <- salaries$salaries_2018 > salaries$salaries_2017

# e: To check your work, assign your dataframe `salaries` to the
#    variable `all_done`. (Variable: all_done)
all_done <- salaries

#                                         Note 03.
#    Retrieve values from your data frame to answer the following questions Note
#    that you should get the value as specific as possible (e.g., a single cell
#    rather than the whole row!)


# f: What was the 2018 salary of Employee 57. (Variable: salary_57)
salary_57 <- salaries[salaries$employees == "Employee 57", "salaries_2018"]

# g: How many employees got a raise? Assign the answer to the variable `num_got_raise`. (Variable: num_got_raise)
num_got_raise <- nrow(salaries[salaries$got_raise == TRUE, ])

# h: What was the dollar value of the highest raise? (Variable: highest_raise)
highest_raise <- max(salaries$salary_adjustments)

# i: What was the `name` of the employee who received the highest raise? (Variable: got_biggest_raise)
got_biggest_raise <- salaries[salaries$salary_adjustments == highest_raise, "employees"]

# j: What was the largest decrease in salaries between the two years? (Variable: biggest_paycut)
biggest_paycut <- min(salaries$salary_adjustments)

# k: What was the name of the employee who received largest decrease in salary? (Variable: got_biggest_paycut)
got_biggest_paycut <- salaries[salaries$salary_adjustments == biggest_paycut, "employees"]

# l: What was the average salary change? (Variable: avg_increase)
avg_increase <- mean(salaries$salary_adjustments)

# m: For people who did not get a raise, how much money did they lose on average? (Variable: avg_loss)
avg_loss <- mean(salaries$salary_adjustments[salaries$got_raise == FALSE])

#                                         Note 04.
#    Based on how you generated the salaries, do the above averages match what
#    you expected?


#                                         Note 05.
#    Some final questions and prompts:
#        i.   What is your "working directory" in R? You can find out with:
#                > getwd()
#        ii.  How do you change your working direct in R?
#                > setwd(dir-path)   # e.g.: "~/Documents/Code/mydata"
#        iii. Write your `salary` dataframe out to a file in your working
#             directory, with this command:
#                > write.csv(salaries,"salaries.csv")
#        iv.  Check that the `write()` worked. To read your file back into R,
#             use the `read()` command. For example:
#                > salary_data <- read.csv("salaries.csv")
#        v.   Use the View() command to view the salary data. For example:
#                > View(salary_data)
#        "csv" refers to "comma separated values." Open the "salaries.csv"



