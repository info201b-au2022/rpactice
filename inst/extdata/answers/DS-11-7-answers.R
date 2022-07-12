# pinfo201 / ps-1
#
# DS-11-7: Using dplyr on external data
#    Exercise 11.7 adapted from Programming Skills for Data Science by
#    Micheal Freeman and Joel Ross. See:
#    https://github.com/programming-for-data-science/book-exercises

# Practice set info ----
practice.begin("DS-11-7", learner="[your name]", email="[your e-mail]")

# Key practice set variables (already initialized) ----
#   library("dplyr")

# Your 11 prompts: (a)-(k) ----

#                                         Note 01.
#    To work on this practice set, you need to download the file:
#       `nba_teams_2016.csv`
#
#    This file is located in this GitHub directory:
#       https://github.com/programming-for-data-science/book-exercises/tree/master/chapter-11-exercises/exercise-7/data
#
#    Save `nba_teams_2016.csv` in your working directory, under the directory
#    `data`. Your working directory should be:
#       ~/Documents/info201
#
#    So, you should save the file here:
#       ~/Documents/info201/data/gates_money.csv
#
#    Hint: Use a spreadsheet or text editor and double-check that the file
#    is located in this directory. This is always a good practice
#    when downloading a data set.
#
#    Recall that you can check and set your working directory with
#    RStudio and with these R functions:
#       > ?getwd()
#       > ?setwd()


#                                         Note 02.
#    You will also need to load the `dplyr` library:
#       > library(dplyr)


# a: Assign the path name to your file in the variable `fn_path`. As
#    described in the previous note, your path should look something
#    like this:
fn_path <- "~/Documents/_Code2/info201/data/nba_teams_2016.csv"


# b: Use the `read.csv()` function and your variable, `fn_path`,
#    to read this data set
#       `data/nba_teams_2016.csv`
#    Assign the data into a variable called `team_data`.
#
#    Note: Do NOT treat strings as factors. (Variable: team_data)
team_data <- read.csv(fn_path, stringsAsFactors = FALSE)

#                                         Note 03.
#    View the data frame you loaded, and get some basic information about the
#    number of rows/columns. Note the "X" preceding some of the column titles as
#    well as the "*" following the names of teams that made it to the playoffs
#    that year.
#       > View(team_data)


# c: Add a column that gives the turnovers to steals ratio (TOV / STL) for each
#    team. Assign this new dataframe to `team_data_new`. (Variable: team_data_new)
team_data_new <- mutate(team_data, Ratio = TOV / STL)

# d: Sort the teams from lowest turnover/steal ratio to highest. Which team has
#    the lowest turnover/steal ratio? (Variable: which_team)
which_team <- team_data_new %>%
  filter(Ratio == min(Ratio)) %>%
  select(Team)

# e: Using the pipe operator, create a new column of assists per game (AST / G)
#    AND sort the dataframe by this new column in descending order. (Variable: team_data_new2)
team_data_new2 <- mutate(team_data, ASTGM = AST / G) %>%
  arrange(-ASTGM)

# f: Create a data frame called `good_offense` of teams that scored more than
#    8700 points (PTS) in the season. (Variable: good_offense)
good_offense <- filter(team_data_new2, PTS > 8700)

# g: Create a data frame called `good_defense` of teams that had more than
#    470 blocks (BLK) (Variable: good_defense)
good_defense <- filter(team_data_new2, BLK > 470)

# h: Create a data frame called `offense_stats` that only shows offensive rebounds
#    (ORB), field-goal % (FG.), and assists (AST) along with the team name. (Variable: offense_stats)
offense_stats <- select(team_data, Team, ORB, FG., AST)

# i: Create a data frame called `defense_stats` that only shows defensive
#    rebounds (DRB), steals (STL), and blocks (BLK) along with the team name. (Variable: defense_stats)
defense_stats <- select(team_data, Team, DRB, STL, BLK)

# j: Create a function called `better_shooters` that takes in two teams and returns
#    a data frame of the team with the better field-goal percentage. Include the
#    team name, field-goal percentage, and total points in your resulting data frame (Variable: better_shooters)
better_shooters <- function(team1, team2) {
  better_team <- filter(team_data, Team %in% c(team1, team2)) %>%
    filter(FG. == max(FG.)) %>%
    select(Team, FG., PTS)

  better_team
}

#k: Call the function on two teams to compare them (remember the `*` if needed) (Variable: better.shooter)
better.shooter <- better_shooters("Golden State Warriors*", "Cleveland Cavaliers*")

