#' @version ps-1
#' @short DS-10-2
#' @title Working with data frames
#' @descr
#' Exercise 10.2 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg
#' Create a vector, named `employees`, of 100 employees ("Employee 1", "Employee
#' 2", ... "Employee 100"). (Hint: Use the `paste()` function and vector recycling.
#' This will allow use to add numbers to the word "Employee."
#' @end
#' @code
employees <- paste("Employee", 1:100)
#' @end

#' @id ?
#' @msg
#' Create a vector, named `salaries_2017`, that has 100 random numbers between
#' $40,000 - $50,000. Round these number to 2 decimal places.
#'
#' Note: The function `runif()` can be used to create random numbers. For
#' example, this statement will create 5 random numbers between 10 and 20:
#       > runif(5, 10, 20) (Variable: salaries_2017)
#' @end
#' @cp-var salaries_2017
#' @code
salaries_2017 <- round(runif(100, 40000, 50000),2)
#' @end

#' @id ?
#' @msg
#' A vector, named `salary_adjustments`, was also been created, with this code:
#'    > salary_adjustments <- round(runif(100, -5000, 10000),2)
#'
#' These salary adjustments range from negative $5,000 to positive $10,000. Try
#' running this code to see that it works:
#'    > round(runif(100, -5000, 10000),2)
#' @end
#' @cp-var salary_adjustments
#' @code
salary_adjustments <- round(runif(100, -5000, 10000),2)
#' @end

#' @id ?
#' @msg
#' Create a data frame, named `salaries`, by combining these three vectors:
#'    1. `employees`
#'    2. `salaries_2017`
#'    3. `salary_adjustments`
#'
#' Remember to set `stringsAsFactors=FALSE`!
#' @end
#' @code
salaries <- data.frame(employees, salaries_2017, salary_adjustments, stringsAsFactors = FALSE)
#' @end

#' @id -
#' @msg
#' Add a column, named `salaries_2018`, to the `salaries` dataframe that
#' represents each person's salary in 2018 (e.g., with the salary adjustment
#' added in).
#' @end
#' @code
salaries$salaries_2018 <- salaries$salaries_2017 + salaries$salary_adjustments
#' @end

#' @id -
#' @msg
#' Add a column to the `salaries` data frame that has a value of `TRUE` if the
#' person got a raise (that is, their salary went up).
#' @end
#' @code
salaries$got_raise <- salaries$salaries_2018 > salaries$salaries_2017
#' @end

#' @id ?
#' @msg
#' To check your work, assign your dataframe `salaries` to the
#' variable `all_done`.
#' @end
#' @code
all_done <- salaries
#' @end

#' @id -
#' @msg
#' Retrieve values from your data frame to answer the following questions Note
#' that you should get the value as specific as possible (e.g., a single cell
#' rather than the whole row!)
#' @end

#' @id ?
#' @msg
#' What was the 2018 salary of Employee 57.
#' @end
#' @code
salary_57 <- salaries[salaries$employees == "Employee 57", "salaries_2018"]
#' @end

#' @id ?
#' @msg
#' How many employees got a raise? Assign the answer to the variable `num_got_raise`.
#' @end
#' @code
num_got_raise <- nrow(salaries[salaries$got_raise == TRUE, ])
#' @end

#' @id ?
#' @msg
#' What was the dollar value of the highest raise?
#' @end
#' @code
highest_raise <- max(salaries$salary_adjustments)
#' @end

#' @id ?
#' @msg
#' What was the `name` of the employee who received the highest raise?
#' @end
#' @code
got_biggest_raise <- salaries[salaries$salary_adjustments == highest_raise, "employees"]
#' @end

#' @id ?
#' @msg
#' What was the largest decrease in salaries between the two years?
#' @end
#' @code
biggest_paycut <- min(salaries$salary_adjustments)
#' @end

#' @id ?
#' @msg
#' What was the name of the employee who received largest decrease in salary?
#' @end
#' @code
got_biggest_paycut <- salaries[salaries$salary_adjustments == biggest_paycut, "employees"]
#' @end

#' @id ?
#' @msg
#' What was the average salary change?
#' @end
#' @code
avg_increase <- mean(salaries$salary_adjustments)
#' @end

#' @id ?
#' @msg
#' For people who did not get a raise, how much money did they lose on average?
#' @end
#' @code
avg_loss <- mean(salaries$salary_adjustments[salaries$got_raise == FALSE])
#' @end

#' @id -
#' @msg
#' Based on how you generated the salaries, do the above averages match what
#' you expected?
#' @end

#' @id -
#' @msg
#' Some final questions and prompts:
#'     i.   What is your "working directory" in R? You can find out with:
#'             > getwd()
#'     ii.  How do you change your working direct in R?
#'             > setwd(dir-path)   # e.g.: "~/Documents/Code/mydata"
#'     iii. Write your `salary` dataframe out to a file in your working
#'          directory, with this command:
#'             > write.csv(salaries,"salaries.csv")
#'     iv.  Check that the `write()` worked. To read your file back into R,
#'          use the `read()` command. For example:
#'             > salary_data <- read.csv("salaries.csv")
#'     v.   Use the View() command to view the salary data. For example:
#'             > View(salary_data)
#'     "csv" refers to "comma separated values." Open the "salaries.csv"
#'     file to confirm.

