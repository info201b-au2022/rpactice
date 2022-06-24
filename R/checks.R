#----------------------------------------------------------------------------#
# Practice Set One Callbacks (for illustration)
#----------------------------------------------------------------------------#

## Callbacks ----
#----------------------------------------------------------------------------#
# These functions are used to check the learner's answers. These callbacks
# are optional. If a callback is not provided, this function is called:
# DEFAULT_Check() (see "practice-201.R").
#
# If the answer is correct, a "good" message is returned; otherwise, a
# "try again" message, which might (optionally) have a list of hints for
# correcting the code, is returned.
#
# The names of the functions are important. They must follow this structure:
#     <var_name>.<short>_Check(internal_id, result)
#
# Examples:
#    t_01.P01_Check
#    num.P01_Check
#----------------------------------------------------------------------------#

#----------------------------------------------------------------------------#
# Examples for Practice Set P01
#----------------------------------------------------------------------------#
# Prompt: "Add ten, nine, and eight together? (t_01)
# This is the most basic callback. All it does is check the answer and
# produce feedback, either a "good" message or an "error" message.
#
# NOTE: There is no reason to implement this callback, since DEFAULT_Check
#       implements this functionality.
t_01.P01_Check <- function(internal_id, result) {
  learner_result <- eval_string_details(ps_get_assignment_var(internal_id))
  expected_result <- eval_string_details(ps_get_expected_answer(internal_id))
  learner_val <- learner_result$value
  expected_val <- expected_result$value

  if (identical(learner_val, expected_val) == TRUE) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
  }
  return(result)
}

# Prompt: "What is 111 divided by 9? (num)
# This callback shows that hints can be added programmatically within the callback.
num.P01_Check <- function(internal_id, result) {
  learner_result <- eval_string_details(ps_get_assignment_var(internal_id))
  expected_result <- eval_string_details(ps_get_expected_answer(internal_id))

  learner_val <- learner_result$value
  expected_val <- expected_result$value

  if (learner_val == expected_val) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    t <- result_main_message(result_error_msg(internal_id, TRUE))
    t <- result_sub_message(t, "Do you use the division operator (/) and assignment operator (<-)?")
    t <- result_sub_message(t, "Is the variable name correct (num)?")
    result <- result_update(result, internal_id, FALSE, t)
  }
  return(result)
}

#----------------------------------------------------------------------------#
# Examples for Practice Set T03
#----------------------------------------------------------------------------#
# Illustrates a function will two arguments
h.T03_Check <- function(internal_id, result) {
  checks_arg1 <- c(10, 20, 30, 0)
  checks_precision <- c(2, 4, 0)

  learner_answers <- c()
  expected_answers <- c()

  learner_result <- eval_string_details(ps_get_assignment_var(internal_id))

  expected_code <- ps_get_expected_answer(internal_id)
  expected_function <- eval(parse(text = paste0(expected_code, collapse = "\n")))

  print(learner_result)

  if (learner_result$type == "closure") {
    print("composite")

    for (k in 1:length(checks_precision)) {
     t1 <- do.call(learner_result$scode, list(checks_arg1,checks_precision[k]))
     t2 <- do.call(expected_function, list(checks_arg1, checks_precision[k]))

     learner_answers <- append(learner_answers,t1)
     expected_answers <- append(expected_answers,t2)
    }

    if (identical(learner_answers, expected_answers, ignore.environment = TRUE) == TRUE) {
      result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
    } else {
      result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
    }
    return(result)
  }
}

# The remaining tasks are handled by the default callback function,
# which is named DEFAULT_Check() (see "practice-201.R")
