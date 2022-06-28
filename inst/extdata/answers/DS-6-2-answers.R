# DS-6-2: Using built-in string functions
#    #' Exercise 6.2 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-6-2", learner="[your name]")

# a: Create a variable `lyric` that contains the text "I like to eat apples and
#    bananas" (lyric)
lyric <- "I like to eat apples and bananas"

# b: Use the `substr()` function to extract the 1st through 13th letters from the
#    `lyric`, and store the result in a variable called `intro`.  (Hint: Use `?substr` to see
#    more about this function.) (intro)
intro <- substr(lyric,1,13)

# c: Use the `substr()` function to extract the 15th through the last letter of the
#    `lyric`, and store the result in a variable called `fruits`. (Hint: use `nchar()` to
#    determine how many total letters there are!) (fruits)
len <- nchar(lyric)
fruits <- substr(lyric,15,len)

# d: Use the `gsub()` function to substitute all the "a"s in `fruits` with "ee".
#    Store the result in a variable called `fruits_e`. (Hint: see
#    http://www.endmemo.com/program/R/sub.php for a simple example or use
#    `?gsub`.) (fruits_e)
fruits_e <- gsub("a","ee", fruits)

# e: Use the `gsub()` function to substitute all the "a"s in `fruits` with "o".
#    Store the result in a variable called `fruits_o`. (fruits_o)
fruits_o <- gsub("a","o", fruits)

# f: Create a new variable `lyric_e` that is the `intro` combined with the new
#    `fruits_e` ending. Print out this variable. (lyric_e)
lyric_e <- paste(intro, fruits_e)

# Note: Without making a new variable, print out the `intro` combined with the new
#    `fruits_o` ending.

practice.check()
