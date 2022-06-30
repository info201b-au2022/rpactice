#' @version ps-1
#' @short DS-10-1
#' @title Creating data frames
#' @descr
#' Exercise 10.1 from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end

#' @id ?
#' @msgs
#' Create a vector, named `points`, of the number of points the Seahawks scored in the first 4 games
#' of the season. For the purpose of testing your code, let's assume that the scores
#' are 12, 3, 37, and 27. (Of course, you could google "Seahawks" for the scores!)
#' @end
#' @code
points <- c(12, 3, 37, 27) # example from 2016 season
#' @end

#' @id ?
#' @msg
#' Create a vector, named `points_allowed`, of the number of points the Seahwaks have allowed to be scored
#' against them in each of the first 4 games of the season. For the purpose of testing
#' your code, let's assume that the scores against are: 10, 9, 18, and 27.
#' @end
#' @code
points_allowed <- c(10, 9, 18, 17)
#' @end

#' @id ?
#' @msg
#' Combine your two vectors into a dataframe called `games`.
#' @end
#' @code
games <- data.frame(points, points_allowed)
#' @end

#' @id ?
#' @msg
#' Create a new column "diff" that is the difference in points between the teams
#' Hint: recall the syntax for assigning new elements to a list! In thise case,
#' `diff` will be a vector.
#' @end
#' @code
games$diff <- games$points - games$points_allowed
#' @end

#' @id ?
#' @msg
#' Create a new column `won`, which is TRUE if the Seahawks won the game.
#' @end
#' @code
games$won <- games$diff > 0
#' @end

#' @id ?
#' @msg
#' Create a vector of the opponent teams corresponding to the games played.
#' For the purpose of testing your code, let's assume that the teams are
#' the Dolphins, Rams, 49ers, and Jets.
#' @end
#' @code
opponents <- c("Dolphins", "Rams", "49ers", "Jets")
#' @end

#' @id ?
#' @msg
#' # Assign your dataframe `rownames` of their opponents.
#' @end
#' @code
rownames(games) <- opponents
#' @end

#' @id -
#' @msg
#' View your data frame to see how it has changed!
#' @end
#' @code
View(games)
#' @end
