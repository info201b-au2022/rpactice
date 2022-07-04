# pinfo201 / ps-1
#
# DS-10-4: External data sets: Gates Foundation Educational Grants
#    Exercise 10.4 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-10-4", learner="[your name]", uwnetid="[your UW NetId]")

# Your 9 prompts: (a)-(i) ----

#                                         Note 01.
#    To work on this practice set, you need to download the file:
#       `gates_money.csv`
#
#    The file is located in this GitHub directory:
#       https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-10-exercises/exercise-4/data
#
#    Save this file in your working directory, under the directory
#    `data`. It is highly recommended that your working directory  be:
#       ~/Documents/info201
#
#    So, you should save the file here, so that it is located here:
#       ~/Documents/info201/data/gates_money.csv
#
#    Use a spreadsheet or text editor and double-check that the file
#    is located in this directory. This is always a good practice
#    when downloading a data set.
#
#    Recall that you can check and set your working directory with
#    RStudio and with these R functions:
#       > ?getwd()
#       > ?setwd()


# a: Assign the path name to your file in the variable `fn_path`. As
#    described in the previous note, your path should look something
#    like this:
fn_path <- "~/Documents/_Code2/info201/data/gates_money.csv"

# b: Use the `read.csv()` and your variable, `fn_path`,
#    read the data:
#       `data/gates_money.csv`
#    Assign the data into a variable called `grants`.
#
#    Note: Do NOT treat strings as factors. (Variable: grants)
grants <- read.csv(fn_path, stringsAsFactors = FALSE)

#                                         Note 02.
#    Use the View function to inspect at the loaded data. From the RStudio
#    console type:
#       View(grants)


# c: Create a variable `organization` that contains the `organization` column of
#    the dataset (Variable: organization)
organization <- grants$organization

# d: Confirm that the "organization" column is a vector using the `is.vector()`
#    function. This is a useful debugging tip if you encounter errors later! (Variable: is_vector)
is_vector <- is.vector(organization)

#                                         Note 03.
#    Now that the data set as been loaded in the variable, `grants`, you can
#    ask some questions.


# e: What was the mean dollar amount of all grants? (Variable: mean_spending)
mean_spending <- mean(grants$total_amount)

# f: What was the dollar amount of the largest grant? (Variable: highest_amount)
highest_amount <- max(grants$total_amount)

# g: What was the dollar amount of the smallest grant? (Variable: lowest_amount)
lowest_amount <- min(grants$total_amount)

# h: Which organization received the largest grant? (Variable: largest_recipient)
largest_recipient <- organization[grants$total_amount == highest_amount]

# i: Which organization received the smallest grant? (Variable: smallest_recipient)
smallest_recipient <- organization[grants$total_amount == lowest_amount]

#                                         Note 04.
#    How many grants were awarded in 2010?
length(grants$total_amount[grants$start_year == 2010])


