# pinfo201 / ps-1
#
# DS-10-2: Working with data frames
#    Exercise 10.2 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-10-2", learner="[your name]", uwnetid="[your UW NetId]")

# Initial variables ----
   # salaries_2017 <-
   #    c(43034.1,47229.6,45288.65,47345.44,41039.17,41789.99,41715.14,48760.96,47079.51,
   #    45324.84,43893.83,43368.03,49943.96,48594.13,47735.36,45263.67,41387.08,47785.48,
   #    46965.71,47813.62,44333.59,48459.73,48242.36,43732.48,44360.15,40022.78,45460.62,
   #    46995.8,40794.29,41916.98,49038.64,45421.03,48467.7,41970.87,45166.4,44417.03,
   #    48544.76,48112,45529.65,44812.19,49128.43,43156.4,47342.39,48775.51,41720.93,40613.97,
   #    45109.17,48358.81,41282.07,45091.9,46472.02,47449.5,42012.08,47878.44,40526.01,49413.14,
   #    40824.49,44955.52,46194.63,45193.94,43686.12,49934.47,46944.82,46650.81,44098.25,42440.96,
   #    45814.02,49167.9,49927.23,49836.16,41044.91,47578.35,40426.36,46465.24,41521.41,43346.05,
   #    48432.81,42212.98,46478.08,41372.43,44119.75,42651,45829.74,40187.8,46495.76,44625.38,
   #    47392.98,44782.89,46569.56,42240.97,40246.57,44902.18,47786.94,43231.94,49618.67,42954.5,
   #    46632.55,42911.58,46374.09,45329.64)
   #
   # salary_adjustments <-
   #    c(7484.01,9046.01,4426.35,3593.08,6636.28,-1448.29,1070.13,6171.97,9931.5,-458.89,9013.33,
   #    8629.09,8798.42,9210.66,956.92,-4951.89,2428.03,1365.11,-4035.96,9368.31,-1293.71,6857.13,
   #    6153.55,4778.48,3170.33,228.96,-4076.44,7205.54,-1634.62,8082.07,-73.82,-1291,-3785.63,8479.32,
   #    8683.27,5293.32,1967.16,-2895.5,4565.26,-796.11,-383.68,5012.61,6686.93,2242.55,8107.35,9420.9,
   #    9716,6019.69,7780.6,971.93,4477.75,-4688.07,1334.24,7561.39,-1433.21,-1689.83,1045.52,-1064.4,
   #    7611.45,-664.02,4499.91,-1723.88,-4734.84,9456.76,-3525.87,2634.57,-3909.73,7751.29,8511.87,-134.6,
   #    1878.11,635.21,-427.49,6346.29,4664.02,7163.18,-644.78,-3335.38,6108.34,1564.14,3383.77,1229.85,
   #    8348.04,1351.2,8042.33,-1241.93,5357.47,5578.66,-1676.97,-2366.32,5244.89,-801.25,9142.3,9832.61,
   #    9395.29,1229.82,-2523.74,-2877.53,3791.19,-3522.04)

# Your 11 prompts: (a)-(k) ----

# a: Create a vector, named `employees`, of 100 employees ("Employee 1", "Employee
#    2", ... "Employee 100"). (Hint: Use the `paste()` function and vector recycling.
#    This will allow use to add numbers to the word "Employee." (Variable: employees)
employees <- paste("Employee", 1:100)

#                                         Note 01.
#    A vector, named `salaries_2017`, has been created with with this code:
#       > salaries_2017 <- round(runif(100, 40000, 50000),2)
#
#    The function `runif()` was used to create 100 random numbers between
#    $40,000 and $50,000. The function `round()` was used to round the numbers
#    to two decimal places. Try running this code to see that it works:
#       > round(runif(100, 40000, 50000),2)


#                                         Note 02.
#    A vector, named `salary_adjustments`, was also been created, with this code:
#       > salary_adjustments <- round(runif(100, -5000, 10000),2)
#
#    These salary adjustments range from negative $5,000 to positive $10,000. Try
#    running this code to see that it works:
#       > round(runif(100, -5000, 10000),2)


# b: Create a data frame, named `salaries`, by combining these three vectors:
#       1. `employees`
#       2. `salaries_2017`
#       3. `salary_adjustments`
#
#    Remember to set `stringsAsFactors=FALSE`! (Variable: salaries)
salaries <- data.frame(employees, salaries_2017, salary_adjustments, stringsAsFactors = FALSE)

#                                         Note 03.
#    Add a column, named `salaries_2018`, to the `salaries` dataframe that
#    represents each person's salary in 2018 (e.g., with the salary adjustment
#    added in).
salaries$salaries_2018 <- salaries$salaries_2017 + salaries$salary_adjustments

#                                         Note 04.
#    Add a column to the `salaries` data frame that has a value of `TRUE` if the
#    person got a raise (that is, their salary went up).
salaries$got_raise <- salaries$salaries_2018 > salaries$salaries_2017

# c: To check your work, assign your dataframe `salaries` to the
#    variable `all_done`. (Variable: all_done)
all_done <- salaries

#                                         Note 05.
#    Retrieve values from your data frame to answer the following questions Note
#    that you should get the value as specific as possible (e.g., a single cell
#    rather than the whole row!)


# d: What was the 2018 salary of Employee 57. (Variable: salary_57)
salary_57 <- salaries[salaries$employees == "Employee 57", "salaries_2018"]

# e: How many employees got a raise? Assign the answer to the variable `num_got_raise`. (Variable: num_got_raise)
num_got_raise <- nrow(salaries[salaries$got_raise == TRUE, ])

# f: What was the dollar value of the highest raise? (Variable: highest_raise)
highest_raise <- max(salaries$salary_adjustments)

# g: What was the `name` of the employee who received the highest raise? (Variable: got_biggest_raise)
got_biggest_raise <- salaries[salaries$salary_adjustments == highest_raise, "employees"]

# h: What was the largest decrease in salaries between the two years? (Variable: biggest_paycut)
biggest_paycut <- min(salaries$salary_adjustments)

# i: What was the name of the employee who received largest decrease in salary? (Variable: got_biggest_paycut)
got_biggest_paycut <- salaries[salaries$salary_adjustments == biggest_paycut, "employees"]

# j: What was the average salary change? (Variable: avg_increase)
avg_increase <- mean(salaries$salary_adjustments)

# k: For people who did not get a raise, how much money did they lose on average? (Variable: avg_loss)
avg_loss <- mean(salaries$salary_adjustments[salaries$got_raise == FALSE])

#                                         Note 06.
#    Based on how you generated the salaries, do the above averages match what
#    you expected?


#                                         Note 07.
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



