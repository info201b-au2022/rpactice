# pinfo201 / ps-1
#
# T03: Test cases: Assignment
#    Test different forms of assignment statements

# Practice set info ----
practice.begin("T03", learner="[your name]", uwnetid="[your UW NetId]")

# Initial variables ----
   X <- c(1,2,3)

# Your 1 prompts: (a)-(a) ----

#                                         Note 01.
#    Complex lhs structures and assignments


#                                         Note 02.
#    Currently, only ONE level of nested structure. For example, these structures will fail
#    because pinfo201 cannot determine the name of the variable:
#        t$x$y <- blah
#        t[[a]][[b]] <- blah
#        t[[k]]$x <- blah


# a: Assignment to element of a vector. This works.
#       U <- X
#       U[1] <- 100 (Variable: U)
U <- X
U[1] <- 100

#                                         Note 03.
#    Assignment to two lists
#       meals <- list(a="aa", b="bb")
meals <- list(breakfaset="toast", lunch="soup", dinner="lentis and rice")

#                                         Note 04.
#    Sub-select a list with dollar sign ($)
#       meals$breakfast <- "oatmeal"
meals$breakfast <- "oatmeal"

#                                         Note 05.
#    Sub-select a list with double square brackets ([[]])
#       meals2[[2]] <- 'cheese sandwich'
meals[[2]] <- 'cheese sandwich'

#                                         Note 06.
#    Check that meals is correct, by assigning `meals` to `meals_done`.
meals_done <- meals


