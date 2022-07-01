#' @version ps-1
#' @short DS-08-1
#' @title Creating and accessing lists
#' @descr
#' Exercise 8.1 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
#' @end

#' @id ?
#' @msg
#' Create a vector, named `my_breakfast`, of everything you ate for breakfast. Let's assume, for the purpose of
#' evaluating your code, that you had eggs, toast and tea for breakfast.
#' @end
#' @code
my_breakfast <- c("toast", "eggs", "tea")
#' @end

#' @id ?
#' @msg
#' Create a vector `my_lunch` of everything you ate (or will eat) for lunch. Let's assume, for the purpose of
#' evaluating your code, that you plan to have soup and 'pb + j'.
#' @end
#' @code
my_lunch <- c("soup", "pb + j")
#' @end

#' @id ?
#' @msg
#' Create a list, named `meals`, that contains your breakfast and lunch. The attribute name for `my_breakfast` should
#' be "breakfast" and for `my_lunch` should be "lunch".
#' @end
#' @code
meals <- list(breakfast = my_breakfast, lunch = my_lunch)
#' @end

#' @id ?
#' @msg
#' Add an attribute, named `dinner`, to your `meals` list. That value of this attribute should be what you plan to eat for dinner.
#' @end
#' @var meals
#' @code
meals$dinner <- c("curry", "rice")
#' @end

#' @id ?
#' @msg
#' Use dollar notation ($) to extract your `dinner` element from your list
#' and save it in a vector called 'dinner'
#' @end
#' @code
dinner <- meals$dinner
#' @end

#' @id ?
#' @msg
#' Use double-bracket notation ([[]]) to extract your `lunch` element from your list
#' and save it in your list as the element at index 5 (no reason beyond practice)
#' @end
#' @var meals
#' @code
meals[[5]] <- meals[["lunch"]]
#' @end

#' @id ?
#' @msg
#' Use single-bracket notation to extract your breakfast and lunch from your list
#' and save them to a list called `early_meals`
#' @end
#' @code
early_meals <- meals[1:2]
#' @end


###' Challenge ###

#' @id ?
#' @msg
#' Create a list that has the number of items you ate for each meal
#' Hint: use the `lappy()` function to apply the `length()` function to each item
#' @end
#' @code
items <- lapply(meals, length)
#' @end

#' @id ?
#' @msg
#' Write a function `add_pizza` that adds pizza to a given meal vector, and
#' returns the pizza-fied vector
#' @end
#' @code
add_pizza <- function(meal) {
  meal <- c(meal, "pizza")
  meal # return the new vector
}
#' @end

#' @id ?
#' @msg
#' Create a vector `better_meals` that is all your meals, but with pizza!
#' @end
#' @code
better_meals <- lapply(meals, add_pizza)
#' @end
