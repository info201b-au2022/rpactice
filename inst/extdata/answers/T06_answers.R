# pinfo201 / ps-1
#
# T06: Test cases: Dataframes
#    Test statements that return dataframes

# Practice set info ----
practice.begin("T06", learner="[your name]", uwnetid="[your UW NetId]")

# Initial variables ----
   library(dplyr)
   cDF <- data.frame(A=c(1,2,3,4), B=c('a','b','c','d'), C=c(TRUE,FALSE,TRUE,TRUE))

# Your 9 prompts: (a)-(i) ----

# a: Get the number of rows (Variable: number_of_rows)
number_of_rows <- nrow(cDF)

# b: Get the number of columns (Variable: number_of_cols)
number_of_cols <- ncol(cDF)

# c: The names of the columns (Variable: col_names)
col_names <- colnames(cDF)

# d: Get the second column (Variable: col2)
col2 <- cDF[,2]

# e: Get the first row of the data frame (Variable: df1)
df1 <- cDF[1,]

# f: With dplyr::select, get columns A and C (Variable: df2)
df2 <- dplyr::select(cDF,A,C)

# g: With dplyr::select, get columns A and C (with a pipe) (Variable: df3)
df3 <- cDF %>% dplyr::select(A,C)

# h: Select rows where C==TRUE and show only A and C columns (Variable: df4)
df4 <- cDF %>%
  filter(C==TRUE) %>%
  select(A,C)

# i: Write a function of filter rows by column C (which can be either FALSE or TRUE) (Variable: df5_f)
df5_f <- function(f) {
cDF %>%
  filter(C==f) %>%
  select(A,C)
}


