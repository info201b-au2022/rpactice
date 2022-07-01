# DS-6-4: Functions and conditionals
#    Exercise 6.4 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-6-4", learner="Dave H.")

# a: Define a function `is_twice_as_long` that takes in two character strings, and
#    returns whether or not (e.g., a boolean) the length of one argument is greater
#    than or equal to twice the length of the other.
#    Hint: compare the length difference to the length of the smaller string (is_twice_as_long)
is_twice_as_long <- function(str1, str2) {
  diff <- abs(nchar(str1) - nchar(str2))
  min_length <- min(nchar(str1), nchar(str2))
  diff >= min_length # if difference is more than short
}

# Note: Call your `is_twice_as_long` function by passing it different length strings
#    to confirm that it works. Make sure to check when _either_ argument is twice
#    as long, as well as when neither are!

is_twice_as_long("dog", "elephant")
is_twice_as_long("elephant", "dog")
is_twice_as_long("dog", "cat")

# b: Define a function `describe_difference` that takes in two strings. The
#    function should return one of the following sentences as appropriate
#      "Your first string is longer by N characters"
#      "Your second string is longer by N characters"
#      "Your strings are the same length!" (describe_difference)

describe_difference <- function(first, second) {
  diff <- nchar(first) - nchar(second)
  if (diff > 0) {
    sentence <- paste("Your first string is longer by", diff, "characters")
  } else if (diff < 0) {
    sentence <- paste("Your second string is longer by", -diff, "characters")
  } else {
    sentence <- "Your strings are the same length!"
  }
  sentence # return the sentence
}

# Note: Call your `describe_difference` function by passing it different length strings
#    to confirm that it works. Make sure to check all 3 conditions.

describe_difference("dog", "elephant")
describe_difference("elephant", "dog")
describe_difference("dog", "cat")
