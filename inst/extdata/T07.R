#' @version ps-1
#' @short T07
#' @title Test cases: files
#' @descr
#' Files
#' @end
#' @initial-vars
#' @end

#' @id -
#' @msg Testing the use of the @cp-var tag

#' @id ?
#' @msg Assign your name to the variable my_name
#' @cp-var fn_path
#' @code
fn_path <- "~/Documents/_Code2/info201/data/gates_money.csv"
#' @end

#' @id ?
#' @msg
#' Read the df
#' @end
#' @code
df <- read.csv(fn_path)
#' @end
#'
#' @id ?
#' @msg
#' number of rows
#' @end
#' @code
nr <- nrow(df)
#' @end
