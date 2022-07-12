# pinfo201 / ps-1
#
# DS-10-5: Large data sets: Baby Name Popularity Over Time
#    Exercise 10.5 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-10-5", learner="[your name]", email="[your email]")

# Your 8 prompts: (a)-(h) ----

#                                         Note 01.
#    To work on this practice set, you need to download the file:
#       `female_names.csv`
#
#    This is file located in this GitHub directory:
#       https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-10-exercises/exercise-5/data
#
#    Save `female_names.cvs` in your working directory, under the directory
#    `data`. Your working directory should be:
#       ~/Documents/info201
#
#    So, the file should be located here:
#       ~/Documents/info201/data/data/female_names.csv
#
#    Hint: Use a spreadsheet or text editor and double-check that the file
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
fn_path <- "~/Documents/_Code2/info201/data/female_names.csv"


# b: Read in the female baby names data file found in the `data` folder into a
#    variable called `names`. Remember to NOT treat the strings as factors! (Variable: names)
names <- read.csv(fn_path, stringsAsFactors = FALSE, nrows=1000)

#                                         Note 02.
#    Use the View function to inspect at the loaded data. From the RStudio
#    console type:
#       View(names)
#
#    Now you are ready to ask some questions of the data!


# c: How many rows are in the dataframe `names`? (Variable: num_rows)
num_rows <- nrow(names)

# d: Create a data frame `names_2013` that contains only the rows for the
#    year 2013. (Variable: names_2013)
names_2013 <- names[names$year == 2013, ]

# e: What was the most popular female name in 2013? (Variable: most_popular_name_2013)
most_popular_name_2013 <- names_2013[names_2013$prop == max(names_2013$prop), "name"]

# f: Write a function `most_popular_in_year` that takes in a year as a value and
#    returns the most popular name in that year. (Variable: most_popular_in_year)
most_popular_in_year <- function(year) {
  names_year <- names[names$year == year, ]
  most_popular <- names_year[names_year$prop == max(names_year$prop), "name"]
  return(most_popular) # return most popular
}

# g: What was the most popular female name in 1994? (Variable: most_popular_1994)
most_popular_1994 <- most_popular_in_year(1994)

# h: Write a function `number_in_million` that takes in a name and a year, and
#    returns statistically how many babies out of 1 million born that year have
#    that name. (Hint: Get the popularity percentage, and take that percentage
#    out of 1 million.) (Variable: laura_answer)
number_in_million <- function(name, year) {
  name_popularity <- names[names$year == year & names$name == name, "prop"]
  round(name_popularity * 1000000, 1)
}
#' @end

#' @id ?
#' @msg
#' How many babies out of 1 million had the name 'Laura' in 1995?
laura_answer <- number_in_million("Laura", 1995)

#                                         Note 03.
#    How many babies out of 1 million had your name in the year you were born?


#                                         Note 04.
#    ## Consider: What does this tell you about how easy it is to identify you with



