#----------------------------------------------------------------------------#
# Practice Set Two
#----------------------------------------------------------------------------#

ps02 <- list(

  ## Descriptive info ----
  # Descriptive information about the problem set.
  # Notes: problem_set_id MUST be unique
  ps_id = 2,
  ps_title = "Basic String Functions",
  ps_short = "P02",
  ps_descr = "Practice some basic string functions.",
  ps_instructions = "",

  ## Initial variables ----
  # A set of pre-initialized variables can be set with a list of expressions.
  # In this way, learner prompts can refer to these variables.
  initial_vars = list(
    "X<<-10",
    "Y<<-c(1,2,3)",
    "Z<<-data.frame(c(1,2,3),c('A','B','C'))"
  ),

  ## Tasks ----
  # Practice set prompts and answers are represented in this structure
  # Tasks have an internal ID, namely their position within the task_list
  task_list = list(
    task = list(
      prompt_id = "A",
      prompt_msg = "Add ten, nine, and eight together?",
      assignment_var = "t_01",
      expected_answer =   "10 + 9 + 8",
      learner_answer = "",
      hints = list(
        "Do you use the math plus operator (+)?",
        "Do you use the assignment operator (<-)?",
        "Is the variable name correct (t_01)?"
      )
    ),

    task = list(
      prompt_id = "B",
      prompt_msg =  "What is 111 divided by 9?",
      assignment_var = "num",
      expected_answer =   "111/9",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "C",
      prompt_msg =  "What is the average of 1, 17, 19, and 31?",
      assignment_var = "t_03",
      expected_answer = "(1 + 17 + 19 + 31) / 4",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "D",
      prompt_msg =  "Use the exponent operator (^) to compute 2 to the 20th power.",
      assignment_var = "t_04",
      expected_answer = "2^20",
      learner_answer = "",
      hints = list(
        "Check the exponent. Is it 20?",
        "Check the best number. Is it 2?",
        "Is the variable name correct (t_04)?"
      )
    )
  )
)
