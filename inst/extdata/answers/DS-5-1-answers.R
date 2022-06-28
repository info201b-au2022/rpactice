# FR-05-1: Book: 05: Exercise 1: Practice with basic R syntax
# ---
practice.begin("DS-5-1", learner="[your name]")

# a: Create a variable `hometown` that stores the city in which you were born (hometown)
hometown <- "St. Louis"

# b: Assign your name to the variable `my_name` (my_name)
my_name <- "Mike"

# c: Assign your height (in inches) to a variable `my_height` (my_height)
my_height <- 73.5

# d: Create a variable `puppies` equal to the number of puppies you'd like to have. Let's assume 5 puppies! (puppies)
puppies <- 5

# e: Create a variable `puppy_price`, which is how much a puppy costs. Assume puppies cost $250.00. (puppy_price)
puppy_price <- 250

# f: Create a variable `total_cost` that has the total cost of all of your puppies (total_cost)
total_cost <- puppies * puppy_price

# g: Create a boolean variable `too_expensive`, set to TRUE if the cost is greater than $1,000 (too_expensive)
too_expensive <- total_cost > 1000

# h: Create a variable `max_puppies`, which is the number of puppies you can afford for $1,000 (max_puppies)
max_puppies <- 1000%/%puppy_price

practice.check()

