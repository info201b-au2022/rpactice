#' @version ps-1
#' @short T02
#' @title Test cases: Copy variables
#' @descr
#' Sometimes it is helpful to write a practice set based on a learner's
#' data input. This is possible with the @cp-var tag.
#' @end
#' @initial-vars
#' @end

#' @id -
#' @msg Testing the use of the @cp-var tag

#' @id ?
#' @msg Assign your name to the variable my_name
#' @cp-var my_name
#' @code
my_name <- "learner defined varaible"
#' @end

#' @id ?
#' @msg
#' How many characters are in your name?
#' @end
#' @code
num_characters <- nchar(my_name)
#' @end

#' @id ?
#' @msg Assign your an absolute directory path to your csv file.
#' @cp-var fname
#' @code
fname <- "/Users/dhendry/Documents/_Code2/info201/data/gates_money.csv"
#' @end

#' @id ?
#' @msg Read the csv file into the variable, `df`.
#' @code
df <- read.csv(fname)
#' @end

#' @id ?
#' @msg How many rows are in the dataframe, `df`?
#' @code
num_of_rows <- nrow(df)
#' @end


