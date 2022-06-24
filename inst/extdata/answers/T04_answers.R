# T04: Answers to Test cases: Dataframes
#
# ---
practice.begin("T04", learner="DGH Testing")
# a: Get the number of rows (number_of_rows)
number_of_rows <- nrow(cDF)

# b: Get the number of columns (number_of_cols)
number_of_cols <- ncol(cDF)

# c: The names of the columns (col_names)
col_names <- colnames(cDF)

# d: Get the second column (col2)
col2 <- cDF[,2]

# e: Get the first row of the data frame (df1)
df1 <- cDF[1,]

# f: With dplyr::select, get columns A and C (df2)
df2 <- dplyr::select(cDF,A,C)

# g: With dplyr::select, get columsn A and C (with a pipe) (df3)
df3 <- cDF %>% dplyr::select(A,C)

# h: Select rows where C==TRUE and show only A and C columns (df4)
df4 <- cDF %>%
  filter(C==TRUE) %>%
  select(A,C)

#i: Write a function of filter rows by column C (which can be either FALSE or TRUE) (df5_f)
df5_f <- function(test) {
  cDF %>%
    filter(C==test) %>%
    select(A,C)
}

practice.check()
