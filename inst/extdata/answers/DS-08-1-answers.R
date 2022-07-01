# DS-08-1: Creating and accessing lists
#    Exercise 8.1 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-08-1", learner="[your name]")

# Note: For the purposes of this practice set, please assume:
#       For breakfast, you will have toast, eggs, and tea
#       For lunch, you will have soup and "pb + j" (peanut butter and jam)
#       For dinner, you will have curry and rice.

# a: Create a vector, named `my_breakfast`, of everything you ate for breakfast. (my_breakfast)
my_breakfast <- c("toast", "eggs", "tea")

# b: Create a vector `my_lunch` of everything you ate (or will eat) for lunch. (my_lunch)
my_lunch <- c("soup", "pb + j")

# Note: Create a list, named `meals`, that contains your breakfast and lunch. The
#    attribute name for `my_breakfast` should be "breakfast" and for `my_lunch`
#    should be "lunch".

meals <- list(breakfast = my_breakfast, lunch = my_lunch)

# Note: Add an attribute, named `dinner`, to your `meals` list, which includes
#    everything you ate (or will eat) for dinner

meals$dinner <- c("curry", "rice")

# c: Use dollar notation ($) to extract your `dinner` element from your list
#    and save it in a vector called 'd' (d)
d <- meals$dinner

# d: Use double-bracket notation ([[]]) to extract your `lunch` element from your
#    list and save it to the variable `l` (l)
l <- meals[["lunch"]]

# Note: Use double-bracket notation ([[]]) to extract your `lunch` element from your
#    list and add it at element 5 of `meals` (there is no good reason to do this
#    -- but making these kinds of assignments will come in handy later)

meals[[5]] <- meals[["lunch"]]

# e: Use single-bracket notation to extract your breakfast and lunch from your list
#    and save them to a list called `early_meals` (early_meals)
early_meals <- meals[1:2]

# Note: ### Challenge ###


# f: Create a list that has the number of items you ate for each meal. Hint: use
#    the `lapply()` function to apply the `length()` function to each item. (items)
items <- lapply(meals, length)

# g: Write a function `add_pizza` that adds pizza to a given `meal` vector, and
#    returns the pizza-filled vector (add_pizza)
add_pizza <- function(meal) {
  meal <- c(meal, "pizza")
  return(meal)
}

# h: Create a vector `better_meals` that is all your meals, but with pizza! (better_meals)
better_meals <- lapply(meals, add_pizza)
