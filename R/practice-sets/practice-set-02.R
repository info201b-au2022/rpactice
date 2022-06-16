#----------------------------------------------------------------------------#
# Practice Set Two
#----------------------------------------------------------------------------#

#' Prices of 50,000 round cut diamonds.
#'
#' A dataset containing the prices and other attributes of almost 54,000
#' diamonds.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{price}{price, in US dollars}
#'   \item{carat}{weight of the diamond, in carats}
#'   ...
#' }
#' @source \url{http://www.diamondse.info/}
#' @export
ps02 <- list(

  ## Descriptive info ----
  # Descriptive information about the problem set.
  # Notes: problem_set_id MUST be unique
  ps_id = 2,
  ps_title = "Built-in Mathematical Function ",
  ps_short = "P02",
  ps_descr = "Practice using some key mathematical functions. Know about these functions:\nround(x, digits=n), trunc(x), ceiling(x), floor(x), sqrt(x), log10(x)   ",
  ps_instructions = "",

  ## Initial variables ----
  # A set of pre-initialized variables can be set with a list of expressions.
  # In this way, learner prompts can refer to these variables.
  initial_vars = list(
    "X<<-10"
  ),

  ## Tasks ----
  # Practice set prompts and answers are represented in this structure
  # Tasks have an internal ID, namely their position within the task_list
  task_list = list(
    task = list(
      prompt_id = "a",
      prompt_msg = "What is the square root of 50",
      assignment_var = "t_01",
      expected_answer =   "sqrt(50)",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "b",
      prompt_msg =  "In R, pi is a built-in constant (3.141593). Round pi to two decimal places.",
      assignment_var = "t_02",
      expected_answer =   "round(pi,2)",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "c",
      prompt_msg =  "Functions can be nested. What is the square root of 50, rounded to one decimal place.",
      assignment_var = "t_03",
      expected_answer = "round(sqrt(50),1)",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "d",
      prompt_msg =  "Find the smallest integer that is larger than 5.1. (Hint: Use ceiling(x))",
      assignment_var = "t_04",
      expected_answer = "ceiling(5.1)",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "e",
      prompt_msg =  "Find the largest integer that is smaller than 5.1.",
      assignment_var = "t_05",
      expected_answer = "floor(5.1)",
      learner_answer = "Use the floor(x) function",
      hints = list()
    ),


    task = list(
      prompt_id = "f",
      prompt_msg =  "What is the common logarithm of 10,000?",
      assignment_var = "t_06",
      expected_answer = "log10(10000)",
      learner_answer = "Use the log10(x) function",
      hints = list()
    )
  )
)
