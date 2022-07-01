# DS-6-3: Writing and executing functions
#    Exercise 6.3 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises
# ---
practice.begin("DS-06-3", learner="[your name]")

# a: Define a function `add_three` that takes a single argument and
#    returns a value 3 greater than the input. (add_three)
add_three <- function(n) {
  return(n+3)
}

# b: Create a variable `ten` that is the result of passing 7 to your `add_three` function. (ten)
ten <- add_three(7)

# c: Define a function `imperial_to_metric` that takes in two arguments: a number
#    of feet and a number of inches. The function should return the equivalent
#    length in meters. (imperial_to_metric)
imperial_to_metric <- function(f, i) {
  total_inches <- f * 12 + i
  meters <- total_inches * 0.0254
  meters
}

# d: Create a variable `height_in_meters` by passing your height in imperial to the
#    `imperial_to_metric` function. For testing, assuming you are 5 feet 8 inches tall. (height_in_meters)
height_in_meters <- imperial_to_metric(5,8)

