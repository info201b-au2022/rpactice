# Problem Set ONE ----
#----------------------------------------------------------------------------#
# Practice Set One
#----------------------------------------------------------------------------#

# This structure is used to represent a practice set. Basically, a practice
# set comprises a set of prompts and corresponding answers.
ps01a <- list(

  ## Descriptive info ----
  # Descriptive information about the problem set.
  # Notes: problem_set_id MUST be unique
  ps_id = 1,
  ps_title = "Practice Set One",
  ps_short = "P1",
  ps_descr = "Practice using basic mathematical operators and functions.",
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
  # Practice set prompts and answers are represented in this structure.
  task_list = list(
    task = list( 
      prompt_id = "A",
      prompt_msg = "Add ten, nine, and eight together?",
      assignment_var = "t_01",
      expected_answer =   "10 + 9 + 8", 
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
      hints = list( 
        "Do you use the division operator (/) and assignment operator (<-)?",
        "Is the variable name correct (t_02)?"
      )
    ),
    
    task = list(
      prompt_id = "C",
      prompt_msg =  "What is the average of 1, 17, 19, and 31?",
      assignment_var = "t_03",
      expected_answer = "(1 + 17 + 19 + 31) / 4", 
      hints = list()
    ),
      
    task = list(
      prompt_id = "D",
      prompt_msg =  "Use the exponent operator (^) to compute 2 to the 20th power.",
      assignment_var = "t_04",
      expected_answer = "2^20", 
      hints = list(
        "Check the exponent. Is it 20?",
        "Check the best number. Is it 2?",
        "Is the variable name correct (t_04)?"
      )
    )
  )
)

## Callbacks ----
#----------------------------------------------------------------------------#
# These functions are callbacks. They are used to check the learner's
# answers.The correct answer is computed from the code that is assigned
# in the expected answer vector (see above).
#
# If the answer is correct, a "good" message is returned; otherwise, a
# "try again" message, which might (optionally) have
# list of hints for correcting the code, is returned.
#
# The names of the functions are important. They must begin with the
# name of the expected variable.
#----------------------------------------------------------------------------#

# Prompt: "Add ten, nine, and eight together? (t_01)
# Callback with hints
t_01_Check <- function(internal_id, val, result) {
  if (val == eval_expr(internal_id)) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    result_error_msg
    t <- result_main_message(result_error_msg(internal_id, TRUE))
    t <- result_sub_message(t, "Do you use the math plus operator (+)?")
    t <- result_sub_message(t, "Do you use the assignment operator (<-)?")
    t <- result_sub_message(t, "Is the variable name correct (t_01)?")
    result <- result_update(result, internal_id, FALSE, t)
  }
  return(result)
}

# Prompt: "What is 111 divided by 9? (t_02)
# Callback with hints
num_Check <- function(internal_id, val, result) {
  if (val == eval_expr(internal_id)) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    t <- result_main_message(result_error_msg(internal_id, TRUE))
    t <- result_sub_message(t, "Do you use the division operator (/) and assignment operator (<-)?")
    t <- result_sub_message(t, "Is the variable name correct (t_02)?")
    result <- result_update(result, internal_id, FALSE, t)
  }
  return(result)
}

# Prompt: "What is the average of 1, 17, 19, and 31? (t_03)"
# Callback without hints
t_03_Check <- function(internal_id, val, result) {
  if (val == eval_expr(internal_id)) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
  }
  return(result)
}
