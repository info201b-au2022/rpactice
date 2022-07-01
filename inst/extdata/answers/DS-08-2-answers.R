# DS-08-2: Using `*apply()` function
#    Exercise 8.2 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-08-2", learner="[your name]")

# Initial variables
random_nums1 <- c(45.061645, 55.431745, 27.627803, 3.912747, 12.678429, 15.237589, 61.714670, 61.171740, 92.668415, 54.066513)

# a: The variable `random_nums1` contains 10 random numbers between 1 and
#    100. Use the function `as.list()` to convert `random_nums1` into
#    a list. Assign your list to a variable named `nums1`. (nums1)
nums1 <- as.list(random_nums1)

# b: Use `lapply()` to apply the `round()` function to each number, rounding it to
#    the nearest 0.1 (one decimal place). (nums1_rounded)
nums1_rounded <- lapply(nums1, round, 1)

# Note: (1) Create a *list* of 100 random numbers. Use the `runif()` function to make a
#    vector of random numbers, then use `as.list()` to convert that to a list.
#    assign your list to a variable named `nums`.
#
#    (2) Use `lapply()` to apply the `round()` function to each number, rounding it to
#    the nearest 0.1 (one decimal place).



# c: Create a variable, named `sentence`, that contains a sentence of text (something
#    longish). For the purpose of evaluating your code, use this sentence:
#       "I do not like green eggs and ham. I do not like them, Sam-I-Am". (sentence)
sentence <- "I do not like green eggs and ham. I do not like them, Sam-I-Am"

# d: Create a variable, named `sentence_lcase`, that converts the string to all
#    lower case. (sentence_lcase)
sentence_lcase <- tolower("I do not like green eggs and ham. I do not like them, Sam-I-Am")

# e: Use the `strsplit()` function to split the sentence into a vector of letters.
#    Hint: split on `""` to split every character. Note: this will return
#    a _list_ with 1 element (which is the vector of letters). (letters_list)
letters_list <- strsplit(sentence_lcase, "")

# f: Extract the vector of letters from the resulting list (letters)
letters <- letters_list[[1]]

# g: Use the `unique()` function to get a vector of unique letters (letters_unique)
letters_unique <- unique(letters)

# h: Define a function `count_occurrences` that takes in two parameters: a letter
#    and a vector of letters. The function should return how many times that letter
#    occurs in the provided vector.
#    Hint: use a filter operation! (count_occurrences)
count_occurrences <- function(letter, all_letters) {
  # Approach 1:
  #s <- length(all_letters[all_letters == letter])

  # Approach 2:
  t <- all_letters == letter
  s <- sum(t)
  return(s)
}

# i: Call your `count_occurrences()` function to see how many times the letter 'e'
#    is in your sentence. (num_e)
num_e <- count_occurrences("e", letters)

# j: Use `sapply()` to apply your `count_occurrences()` function to each unique
#    letter in the vector to determine their frequencies.
#    Convert the result into a list (using `as.list()`). (frequencies)
frequencies <- as.list(sapply(letters_unique, count_occurrences, letters))
