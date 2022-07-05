# pinfo201 / ps-1
#
# T07: Test cases: files
#    Files

# Practice set info ----
practice.begin("T07", learner="[your name]", uwnetid="[your UW NetId]")

# Your 3 prompts: (a)-(c) ----

#                                         Note 01.
#    Testing the use of the @cp-var tag


# a: Assign your name to the variable my_name (Variable: fn_path)
fn_path <- "~/Documents/_Code2/info201/data/female_names.csv"

# b: Read the df (Variable: df)
df <- read.csv(fn_path)

# c: number of rows (Variable: nr)
nr <- nrow(df)


