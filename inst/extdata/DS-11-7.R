#' @version ps-1
#' @short DS-11-7
#' @title Using dplyr on external data
#' @descr
#' Exercise 11.7 adapted from Programming Skills for Data Science by
#' Micheal Freeman and Joel Ross. See:
#' https://github.com/programming-for-data-science/book-exercises
#' @end
#' @initial-vars
library("dplyr")
#' @end

#' @id -
#' @msg
#' To work on this practice set, you need to download the file:
#'    `nba_teams_2016.csv`
#'
#' This file is located in this GitHub directory:
#'    https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-11-exercises/exercise-7/data
#'
#' Save `nba_teams_2016.csv` in your working directory, under the directory
#' `data`. Your working directory should be:
#'    ~/Documents/info201
#'
#' So, you should save the file here:
#'    ~/Documents/info201/data/gates_money.csv
#'
#' Hint: Use a spreadsheet or text editor and double-check that the file
#' is located in this directory. This is always a good practice
#' when downloading a data set.
#'
#' Recall that you can check and set your working directory with
#' RStudio and with these R functions:
#'    > ?getwd()
#'    > ?setwd()
#' @end

#' @id -
#' @msg
#' You will also need to load the `dplyr` library:
#'    > library(dplyr)
#' @end

#' @id ?
#' @msg
#' Assign the path name to your file in the variable `fn_path`. As
#' described in the previous note, your path should look something
#' like this:
#'    fn_path <- "~/Documents/info201/data/nba_teams_2016.csv"
#' @end
#' @cp-var fn_path

#' @id ?
#' @msg
#' Use the `read.csv()` function and your variable, `fn_path`,
#' to read this data set
#'    `data/nba_teams_2016.csv`
#' Assign the data into a variable called `team_data`.
#'
#' Note: Do NOT treat strings as factors.
#' @end
#' @code
team_data <- read.csv(fn_path, stringsAsFactors = FALSE)
#' @end

#' @id -
#' @msg
#' View the data frame you loaded, and get some basic information about the
#' number of rows/columns. Note the "X" preceding some of the column titles as
#' well as the "*" following the names of teams that made it to the playoffs
#' that year.
#'    > View(team_data)
#' @end

#' @id ?
#' @msg
#' Add a column that gives the turnovers to steals ratio (TOV / STL) for each
#' team. Assign this new dataframe to `team_data_new`.
#' @end
#' @code
team_data_new <- mutate(team_data, Ratio = TOV / STL)
#' @end

#' @id ?
#' @msg
#' Sort the teams from lowest turnover/steal ratio to highest. Which team has
#' the lowest turnover/steal ratio?
#' @end
#' @code
which_team <- team_data_new %>%
  filter(Ratio == min(Ratio)) %>%
  select(Team)
#' @end

#' @id ?
#' @msg
#' Using the pipe operator, create a new column of assists per game (AST / G)
#' AND sort the dataframe by this new column in descending order.
#' @end
#' @code
team_data_new2 <- mutate(team_data, ASTGM = AST / G) %>%
  arrange(-ASTGM)
#' @end

#' @id ?
#' @msg
#' Create a data frame called `good_offense` of teams that scored more than
#' 8700 points (PTS) in the season.
#' @end
#' @code
good_offense <- filter(team_data_new2, PTS > 8700)
#' @end

#' @id ?
#' @msg
#' Create a data frame called `good_defense` of teams that had more than
#' 470 blocks (BLK)
#' @end
#' @code
good_defense <- filter(team_data_new2, BLK > 470)
#' @end

#' @id ?
#' @msg
#' Create a data frame called `offense_stats` that only shows offensive rebounds
#' (ORB), field-goal % (FG.), and assists (AST) along with the team name.
#' @end
#' @code
offense_stats <- select(team_data, Team, ORB, FG., AST)
#' @end

#' @id ?
#' @msg
#' Create a data frame called `defense_stats` that only shows defensive
#' rebounds (DRB), steals (STL), and blocks (BLK) along with the team name.
#' @end
#' @code
defense_stats <- select(team_data, Team, DRB, STL, BLK)
#' @end

#' @id ?
#' @msg
#' Create a function called `better_shooters` that takes in two teams and returns
#' a data frame of the team with the better field-goal percentage. Include the
#' team name, field-goal percentage, and total points in your resulting data frame
#' @end
#' @check list(arg1=c("Utah Jazz", "Miami Heat*"), arg2=c("Toronto Raptors*", "Portland Trail Blazers*"))
#' @code
better_shooters <- function(team1, team2) {
  better_team <- filter(team_data, Team %in% c(team1, team2)) %>%
    filter(FG. == max(FG.)) %>%
    select(Team, FG., PTS)

  better_team
}
#' @end

#' @id ?
#' @msg
#' Call the function on two teams to compare them (remember the `*` if needed)
#' @end
#' @code
better.shooter <- BetterShooters("Golden State Warriors*", "Cleveland Cavaliers*")
#' @end
