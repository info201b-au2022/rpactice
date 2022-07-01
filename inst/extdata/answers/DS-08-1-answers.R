# DS-08-1: Creating and accessing lists
#    Exercise 6.4 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-08-1", learner="[your name]")

# a: Create a vector, named `my_breakfast`, of everything you ate for breakfast. Let's assume, for the purpose of
#    evaluating your code, that you had eggs, toast and tea for breakfast. (my_breakfast)
my_breakfast <- c("toast", "eggs", "tea")

# b: Create a vector `my_lunch` of everything you ate (or will eat) for lunch. Let's assume, for the purpose of
#    evaluating your code, that you plan to have soup and 'pb + j'. (my_lunch)
my_lunch <- c("soup", "pb + j")

# c: Create a list, named `meals`, that contains your breakfast and lunch. The attribute name for `my_breakfast` should
#    be "breakfast" and for `my_lunch` should be "lunch". (meals)
meals <- list(breakfast = my_breakfast, lunch = my_lunch)

# d: Add an attribute, named `dinner`, to your `meals` list. That value of this attribute should be what you plan to eat for dinner. (meals$dinner)
meals$dinner <- c("curry", "rice")

# e: Use dollar notation ($) to extract your `dinner` element from your list
#    and save it in a vector called 'dinner' (dinner)
dinner <- meals$dinner

# f: Use double-bracket notation ([[]]) to extract your `lunch` element from your list
#    and save it in your list as the element at index 5 (no reason beyond practice) (meals[[5]])
meals[[5]] <- meals[["lunch"]]

# g: Use single-bracket notation to extract your breakfast and lunch from your list
#    and save them to a list called `early_meals` (early_meals)
early_meals <- meals[1:2]

# h: Create a list that has the number of items you ate for each meal
#    Hint: use the `lappy()` function to apply the `length()` function to each item (items)
items <- lapply(meals, length)

# i: Write a function `add_pizza` that adds pizza to a given meal vector, and
#    returns the pizza-fied vector (add_pizza)
add_pizza <- function(meal) {
  meal <- c(meal, "pizza")
  meal # return the new vector
}

# j: Create a vector `better_meals` that is all your meals, but with pizza! (better_meals)
better_meals <- lapply(meals, add_pizza)

