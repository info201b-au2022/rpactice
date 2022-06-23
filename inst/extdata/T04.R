#' @version ps-1
#' @short T04
#' @title Test cases: Dataframes
#' @descr
#' Test statements that return dataframes
#' @end
#' @initial-vars
library(dplyr)
cDF <- data.frame(A=c(1,2,3,4), B=c('a','b','c','d'), C=c(T,F,T,T))
#' @end

#' @id ?
#' @msg Get the number of rows
#' @code
number_of_rows <- nrow(cDF)
#' @end

#' @id ?
#' @msg Get the number of columns
#' @code
number_of_cols <- ncol(cDF)
#' @end

#' @id ?
#' @msg The names of the columns
#' @code
col_names <- colnames(cDF)
#' @end

#' @id ?
#' @msg Get the second column
#' @code
col2 <- cDF[,2]
#' @end

#' @id ?
#' @msg Get the first row of the data frame
#' @code
df1 <- cDF[1,]
#' @end

#' @id ?
#' @msg With dplyr::select, get columns A and C
#' @code
df2 <- dplyr::select(cDF,A,C)
#' @end

#' @id ?
#' @msg With dplyr::select, get columns A and C (with a pipe)
#' @code
df3 <- cDF %>% dplyr::select(A,C)
#' @end

#' @id ?
#' @msg Select rows where C==TRUE and show only A and C columns
#' @code
df4 <- cDF %>%
  filter(C==TRUE) %>%
  select(A,C)
#' @end
