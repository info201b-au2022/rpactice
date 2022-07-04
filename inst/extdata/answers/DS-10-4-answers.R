# pinfo201 / ps-1
#
# DS-10-4: External data sets: Gates Foundation Educational Grants
#    Exercise 10.4 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-10-4", learner="[your name]", uwnetid="[your UW NetId]")

# Your 7 prompts: (a)-(g) ----

#                                         Note 01.
#    To work on this practice set, you need to download the file:
#       `gates_money.csv`
#
#    The file located in this GitHub directory:
#       https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-10-exercises/exercise-4/data
#
#    Save this file in your working directory, under the directory
#    `data`. Generally, your working directory should be:
#       ~/Documents/info201
#
#    So, the file should be located here:
#       ~/Documents/info201/data/gates_money.csv
#
#    Recall that you can check and set your working directory with
#    RStudio and with these commands:
#       > ?getwd()
#       > ?setwd()


# a: Use the `read.csv()` function to read the data:
#       `data/gates_money.csv`
#    Put the data into a variable called `grants`.
#
#    Notes: (1) Be sure to set your working directory in RStudio; and
#    (2) Do NOT treat strings as factors. (Variable: grants)
grants <- read.csv("~/Documents/_Code2/info201/data/gates_money.csv", stringsAsFactors = FALSE)

#                                         Note 02.
#    Use the View function to look at the loaded data.
View(grants)

# b: Create a variable `organization` that contains the `organization` column of
#    the dataset (Variable: organization)
organization <- grants$organization

# c: Confirm that the "organization" column is a vector using the `is.vector()`
#    function. This is a useful debugging tip if you encounter errors later! (Variable: is_vector)
is_vector <- is.vector(organization)

#                                         Note 03.
#    Now that the data set as been loaded in the variable, `grants`, you can
#    ask some questions.


#                                         Note 04.
#    What was the mean dollar amount of all grants?
mean_spending <- mean(grants$total_amount)

# d: What was the dollar amount of the largest grant? (Variable: highest_amount)
highest_amount <- max(grants$total_amount)

# e: What was the dollar amount of the smallest grant? (Variable: lowest_amount)
lowest_amount <- min(grants$total_amount)

# f: Which organization received the largest grant? (Variable: largest_recipient)
largest_recipient <- organization[grants$total_amount == highest_amount]

# g: Which organization received the smallest grant? (Variable: smallest_recipient)
smallest_recipient <- organization[grants$total_amount == lowest_amount]

#                                         Note 05.
#    How many grants were awarded in 2010?
length(grants$total_amount[grants$start_year == 2010])


