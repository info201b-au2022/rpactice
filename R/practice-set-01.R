#----------------------------------------------------------------------------#
# Practice Set One Callbacks (for illustration)
#----------------------------------------------------------------------------#

## Callbacks ----
#----------------------------------------------------------------------------#
# These functions are used to check the learner's answers. These callbacks
# are optional. If a callback is not provided, a default function called
# DEFAULT_Check() is called (see "practice-201.R").
#
# If the answer is correct, a "good" message is returned; otherwise, a
# "try again" message, which might (optionally) have a list of hints for
# correcting the code, is returned.
#
# The names of the functions are important. They must begin with the
# name of the expected variable to be assessed.
#----------------------------------------------------------------------------#

# Prompt: "Add ten, nine, and eight together? (t_01)
# This is the most basic callback. All it does is check the answer and
# produce feedback, either a "good" message or an "error" message.
#
# NOTE: There is not reason to implement this callback, since DEFAULT_Check
#       implements this.
t_01_Check <- function(internal_id, learner_val, result) {

  print("Here ...")

  expected_val <- eval(parse(text = ps_get_expected_answer(internal_id)))

  print(expected_val)
  print(learner_val)

  if (learner_val == expected_val) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
  }
  return(result)
}

# Prompt: "What is 111 divided by 9? (t_02)
# This callback shows that hints can be added programmatically within the callback.
num_Check <- function(internal_id, learner_val, result) {

#   print("----- num_Check ------")
#   expected_val <- eval(parse(text = ps_get_expected_answer(internal_id)))
#
#   if (learner_val == expected_val) {
#     result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
#   } else {
#     t <- result_main_message(result_error_msg(internal_id, TRUE))
#     t <- result_sub_message(t, "Do you use the division operator (/) and assignment operator (<-)?")
#     t <- result_sub_message(t, "Is the variable name correct (t_02)?")
#     result <- result_update(result, internal_id, FALSE, t)
#   }
#   return(result)
# }
#
# area_Check <- function(internal_id, learner_val, result) {
#
#   funct1_str <- paste0(".circle_area_f_expected <-", ps_get_expected_answer(internal_id))
#   funct1 <- eval(parse(text=funct1_str))
#
# # Check if the variable, circle_area, is a function
#   if (typeof(area) != "closure") {
#     t <- result_main_message(result_error_msg(internal_id, TRUE))
#     t <- result_sub_message(t, "circle_area should be defined to be a function")
#     result <- result_update(result, internal_id, FALSE, t)
#     return(result)
#   }
#
# # Check if there is one parameter
#   if (length(formals(area)) != 1) {
#     t <- result_main_message(result_error_msg(internal_id, TRUE))
#     t <- result_sub_message(t, "circle_area should take one argument, r")
#     result <- result_update(result, internal_id, FALSE, t)
#     return(result)
#   }
#
# # Check if the function compute the correct results
#   correct <-  do.call(".circle_area_f_expected", list(0)) == do.call("circle_area", list(0)) &&
#               do.call(".circle_area_f_expected", list(1)) == do.call("circle_area", list(1)) &&
#               do.call(".circle_area_f_expected", list(4)) == do.call("circle_area", list(4))
#   if (correct) {
#     result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
#   } else {
#     t <- result_main_message(result_error_msg(internal_id, TRUE))
#     t <- result_sub_message(t, "check the formula for the area of a circle")
#     result <- result_update(result, internal_id, FALSE, t)
#   }
  return(result)
}

# The remaining tasks are handled by the default callback function,
# which is named DEFAULT_Check() (see "practice-201.R")
