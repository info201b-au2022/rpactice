# pinfo201 / ps-1
#
# T02: Test cases: Copy variables
#    Sometimes it is helpful to write a practice set based on a learner's
#    data input. This is possible with the @cp-var tag.

# Practice set info ----
practice.begin("T02", learner="[your name]", email="[your UW NetId]")

# Your 5 prompts: (a)-(e) ----

#                                         Note 01.
#    Testing the use of the @cp-var tag


# a: Assign your name to the variable my_name (Variable: my_name)
my_name <- "learner defined varaible"

# b: How many characters are in your name? (Variable: num_characters)
num_characters <- nchar(my_name)

# c: Assign your an absolute directory path to your csv file. (Variable: fname)
fname <- "/Users/dhendry/Documents/_Code2/info201/data/gates_money.csv"

# d: Read the csv file into the variable, `df`. (Variable: df)
df <- read.csv(fname)

# e: How many rows are in the dataframe, `df`? (Variable: num_of_rows)
num_of_rows <- nrow(df)


