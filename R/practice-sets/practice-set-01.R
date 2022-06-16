# Problem Set ONE ----
#----------------------------------------------------------------------------#
# Practice Set One
#----------------------------------------------------------------------------#

# This structure is used to represent a practice set. Basically, a practice
# set comprises a set of prompts and corresponding answers.

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
ps01 <- list(

  ## Descriptive info ----
  # Descriptive information about the problem set.
  # Notes: problem_set_id MUST be unique
  ps_id = 1,
  ps_title = "Basic Arithmatic Operators",
  ps_short = "P01",
  ps_descr = "Practice using basic mathematical operators: +, -, */ ,^, (, ), %%, %/%.\nKnow the meaning of Inf, -Inf, and NaN.",
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
      prompt_id = "a",
      prompt_msg = "Add ten, nine, and eight together?",
      assignment_var = "t_01",
      expected_answer = "10 + 9 + 8",
      learner_answer = "",
      hints = list(
        "Do you use the math plus operator (+)?",
        "Do you use the assignment operator (<-)?",
        "Is the variable name correct (t_01)?"
      )
    ),

    task = list(
      prompt_id = "b",
      prompt_msg = "What is 111 divided by 9?",
      assignment_var = "num",
      expected_answer = "111/9",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "c",
      prompt_msg = "What is the average of 1, 17, 19, and 31?",
      assignment_var = "t_03",
      expected_answer = "(1 + 17 + 19 + 31) / 4",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "d",
      prompt_msg = "What is the average of these Celcius temperatures: -5C, -10C, -12C",
      assignment_var = "t_04",
      expected_answer = "(-5 + -10 + -12) / 3",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "e",
      prompt_msg = "Use the exponent operator (^ or **) to compute 2 to the 20th power.",
      assignment_var = "t_05",
      expected_answer = "2^20",
      learner_answer = "",
      hints = list(
        "Check the exponent. Is it 20?",
        "Check the base number. Is it 2?",
        "Is the variable name correct (t_04)?"
      )
    ),

    task = list(
      prompt_id = "f",
      prompt_msg = "What is 3.4 cubed?",
      assignment_var = "t_06",
      expected_answer = "3.4**3",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "g",
      prompt_msg = "Compute the reciprocal 2 to 8th power (2^(-8) or 1 / 2^8).",
      assignment_var = "t_07",
      expected_answer = "2 ** -8",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "h",
      prompt_msg = "Use the modulus operator (%%) to compute the remainder of 111 divided by 4.",
      assignment_var = "t_08",
      expected_answer = "111%%4",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "i",
      prompt_msg = "Use integer division (%/%) to compute the quotient of 111 divided by 3.",
      assignment_var = "t_09",
      expected_answer = "111%/%3",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "j",
      prompt_msg = "In R, pi is a built-in constant (3.141593). Given a circle with radius 4 (r),\n what is its area? (Recall: A = pi*r^2)",
      assignment_var = "A",
      expected_answer = "pi*4^2",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "k",
      prompt_msg = "In R, Inf means 'positive infinity.' What is 7 / 0?",
      assignment_var = "t_10",
      expected_answer = "7/0",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "l",
      prompt_msg = "In R, -Inf means 'negative infinity.' What is -7 / 0?",
      assignment_var = "t_11",
      expected_answer = "-7/0",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "m",
      prompt_msg = "In R, NaN means 'Not a Number'. What is 0 / 0?",
      assignment_var = "t_12",
      expected_answer = "0/0",
      learner_answer = "",
      hints = list()
    ),

    task = list(
      prompt_id = "n",
      prompt_msg = "Write a function that takes one parameter, r for radius, and computes the\n the area of a circle. (Recall: A = pi*r^2)",
      assignment_var = "circle_area",
      expected_answer = "function(r) {
  area <- pi*r^2
  return (area)
}",
      learner_answer = "",
      hints = list()
    )

    # Task list -- end
  )

  # Practice set -- end
)

## Callbacks ----
#----------------------------------------------------------------------------#
# These functions are used to check the learner's answers. These callbacks
# are optional. If a callback is not provided, a default function called
# DEFAULT_Check() is called (see "practice-201.R").
#
# If the answer is correct, a "good" message is returned; otherwise, a
# "try again" message, which might (optionally) have list of hints for
# correcting the code, is returned.
#
# The names of the functions are important. They must begin with the
# name of the expected variable to be assessed.
#----------------------------------------------------------------------------#

# Prompt: "Add ten, nine, and eight together? (t_01)
# This is the most basic callback. All it does is check the answer and
# produce feedback, either a "good" message or an "error" message.
t_01_Check <- function(internal_id, val, result) {
  if (val == eval_expr(internal_id)) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
  }
  return(result)
}

# Prompt: "What is 111 divided by 9? (t_02)
# This callback shows that hints can be added programmatically within the callback.
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

circle_area_Check <- function(internal_id, val, result) {

  funct1_str <- paste0(".circle_area_f_expected <-", ps_get_expected_answer_rs(internal_id))
  funct1 <- eval(parse(text=funct1_str))

# Check if the variable, circle_area, is a function
  if (typeof(circle_area) != "closure") {
    t <- result_main_message(result_error_msg(internal_id, TRUE))
    t <- result_sub_message(t, "circle_area should be defined to be a function")
    result <- result_update(result, internal_id, FALSE, t)
    return(result)
  }

# Check if there is one parameter
  if (length(formals(circle_area)) != 1) {
    t <- result_main_message(result_error_msg(internal_id, TRUE))
    t <- result_sub_message(t, "circle_area should take one argument, r")
    result <- result_update(result, internal_id, FALSE, t)
    return(result)
  }

# Check if the function compute the correct results
  correct <-  do.call(".circle_area_f_expected", list(0)) == do.call("circle_area", list(0)) &&
              do.call(".circle_area_f_expected", list(1)) == do.call("circle_area", list(1)) &&
              do.call(".circle_area_f_expected", list(4)) == do.call("circle_area", list(4))
  if (correct) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    t <- result_main_message(result_error_msg(internal_id, TRUE))
    t <- result_sub_message(t, "check the formula for the area of a circle")
    result <- result_update(result, internal_id, FALSE, t)
  }
  return(result)
}

# The remaining tasks are handled by the default callback function,
# which is named DEFAULT_Check() (see "practice-201.R")
