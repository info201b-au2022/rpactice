#' @version ps-1
#' @short DS-10-2
#' @title Working with data frames
#' @descr
#' Exercise 10.2 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end

#' @id ?
#' @msg
#' Create a vector, named `employees`, of 100 employees ("Employee 1", "Employee 2", ... "Employee 100")
#' Hint: use the `paste()` function and vector recycling to add a number to the word
#' "Employee"
#' @end
#' @code
employees <- paste("Employee", 1:100)
#' @end

#' @id ?
#' @msg
#' Create a vector, named `salaries_2017`, of 100 random salaries for the year 2017.
#' Use the `runif()` function to pick random numbers between 40000 and 50000
#' @end
#' @code
salaries_2017 <- runif(100, 40000, 50000)
#' @end

#' @id ?
#' @msg
#' Create a vector, named `salary_adjustments`, of 100 annual salary adjustments between -5000 and 10000.
#' (A negative number represents a salary decrease due to corporate greed.)
#' Again use the `runif()` function to pick 100 random numbers in that range.
#' @end
#' @code
salary_adjustments <- runif(100, -5000, 10000)
#' @end

#' @id ?
#' @msg
#' Create a data frame, named `salaries`, by combining the 3 vectors you just made
#' Remember to set `stringsAsFactors=FALSE`!
#' @end
#' @code
salaries <- data.frame(employees, salaries_2017, salary_adjustments, stringsAsFactors = FALSE)
#' @end

#' @id ?
#' @msg
#' Add a column, named `salaries_2018`, to the `salaries` data frame that represents each person's
#' salary in 2018 (e.g., with the salary adjustment added in).
#' @end
#' @code
salaries$salaries_2018 <- salaries$salaries_2017 + salaries$salary_adjustments
#' @end

#' @id ?
#' @msg
#' Add a column to the `salaries` data frame that has a value of `TRUE` if the
#' person got a raise (their salary went up)
#' @end
#' @code
salaries$got_raise <- salaries$salaries_2018 > salaries$salaries_2017
#' @end

#' @id ?
#' @msg
#' Retrieve values from your data frame to answer the following questions
#' Note that you should get the value as specific as possible (e.g., a single
#' cell rather than the whole row!)
#' @end

#' @id ?
#' @msg
#' What was the 2018 salary of Employee 57
#' @end
#' @code
salary_57 <- salaries[salaries$employees == "Employee 57", "salaries_2018"]
#' @end

#' @id ?
#' @msg
#' How many employees got a raise?
#' @end
#' @code
nrow(salaries[salaries$got_raise == TRUE, ])
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
#' Consider: do the above averages match what you expected them to be based on
#' how you generated the salaries?
#' @end

#' @id -
#' @msg
#' Write a .csv file of your salary data to your working directory
#' @end
#' @code
write.csv(salaries, "salaries.csv")
#' @end
