# pinfo201 / ps-1
#
# DS-10-1: Creating data frames
#    Exercise 10.1 from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-10-1", learner="[your name]", email="[your email]")

# Your 5 prompts: (a)-(e) ----

# a: Create a vector, named `points`, of the number of points the Seahawks scored
#    in the first 4 games of the season. For the purpose of testing your code,
#    let's assume that the scores are 12, 3, 37, and 27. (Of course, you could
#    Google "Seahawks" for the real scores!) (Variable: points)
points <- c(12, 3, 37, 27) # example from 2016 season

# b: Create a vector, named `points_allowed`, of the number of points the Seahwaks
#    have allowed to be scored against them in each of the first 4 games of the
#    season. For the purpose of testing your code, let's assume that the scores
#    against are: 10, 9, 18, and 27. (Variable: points_allowed)
points_allowed <- c(10, 9, 18, 17)

# c: Combine your two vectors into a dataframe called `games`. (Variable: games)
games <- data.frame(points, points_allowed)

#                                         Note 01.
#    i.   Create a new column, `diff`, which is the difference in points
#         between the teams.
#    ii.  Create a new column, `won`, which is TRUE if the Seahawks won
#         the game.
#    iii. View your dataframe with View():
#            > View(games)
#
#    Hint: Recall the syntax ($ notation) for assigning new elements to a list! In this
#    case, `diff` and `won` will be vectors.
games$diff <- games$points - games$points_allowed
games$won <- games$diff > 0

# d: Create a vector of the opponent teams corresponding to the games played.
#    For the purpose of testing your code, let's assume that the teams are
#    the Dolphins, Rams, 49ers, and Jets. (Variable: opponents)
opponents <- c("Dolphins", "Rams", "49ers", "Jets")

#                                         Note 02.
#    # Assign your dataframe `rownames`  of their opponents.
rownames(games) <- opponents

# e: To test your work, assign your `games` dataframe to the variable.
#    `all_done` (Variable: all_done)
all_done <- games

#                                         Note 03.
#    View your dataframe with the View() command to see how it has changed.



