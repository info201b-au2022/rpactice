# DS-7-3: Vector practice
#    Exercise 7.3 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-7-3", learner="[your name]")

# a: Create a vector `words` of 6 (or more) words. You can Google for a "random word generator" if you wish! (words)
words <- c("convivial", "love", "excitment", "mountains", "fast", "bicycles", "stars")

# b: Create a vector `words_of_the_day` that is your `words` vector with the string
#    "is the word of the day!" pasted on to the end.
#    BONUS: Surround the word in quotes (e.g., `'data' is the word of the day!`)
#    Note that the results are more obviously correct with single quotes. (words_of_the_day)
words_of_the_day <- paste0("\"", words, "\" is the word of the day!", collpase = "")

# c: Create a vector `a_f_words` which are the elements in `words` that start with
#    "a" through "f"
#    Hint: use a comparison operator to see if the word comes before "f" alphabetically!
#    Tip: make sure all the words are lower-case, and only consider the first letter
#    of the word! (a_f_words)
a_f_words <- words[substring(words, 1, 1) <= "f"]

# d: Create a vector `g_m_words` which are the elements in `words` that start with
#    "g" through "m" (g_m_words)
g_m_words <- words[words >= "g" & substring(words, 1, 1) <= "m"]

# e: Define a function `word_bin` that takes in three arguments: a vector of words,
#    and two letters. The function should return a vector of words that go between
#    those letters alphabetically. (word_bin)
word_bin <- function(words, start, end){
  words[words >= start & substring(words, 1, 1) <= end]
}

# Note: Use your `word_bin` function to determine which of your words start with "e"
#    through "q". Put the result in the variable `word_bin_test1`
word_bin_test <- word_bin(words, "e", "q")


