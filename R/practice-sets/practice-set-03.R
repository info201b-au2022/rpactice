#----------------------------------------------------------------------------#
# Practice Set Three


get_ps03 <- function() {

ps03 <- list(
  ps_id = 3,
  ps_title = "Built-in Mathematical Function ",
  ps_short = "P03",
  ps_descr = "Practice using some key mathematical functions. Know about these functions:\nround(x, digits=n), trunc(x), ceiling(x), floor(x), sqrt(x), log10(x)   ",
  ps_instructions = "",
  initial_vars = list(
    "X<<-10"
  ),
  task_list = list()
)

ps03 <- create_practice_set(ps03,"practice-set-example.txt")
print("-----")
print(ps03)
print("-----")

return(ps03)
}
