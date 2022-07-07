#----------------------------------------------------------------------------#
# Practice Set One Callbacks (for illustration)
#----------------------------------------------------------------------------#

# Callbacks ----
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

# Practice Set P01 ----
#----------------------------------------------------------------------------#
# Examples for Practice Set P01
#----------------------------------------------------------------------------#
# Prompt: "Add ten, nine, and eight together? (t_01)
# This is the most basic callback. All it does is check the answer and
# produce feedback, either a "good" message or an "error" message.
#
# NOTE: There is no reason to implement this callback, since DEFAULT_Check
#       implements this functionality.
#
t_01.P01_Check <- function(var_name, result) {
  internal_id <- ps_var_name_to_id(var_name)

  # Get the learner and expected variable information
  learner_r <- get_global_var_info(var_name)
  expected_r <- get_expected_var_info(var_name)

  # This should never happen, since this callback should only be called when
  # both variables exist
  if (is.null(learner_r) || is.null(expected_r)) {
    stop(paste0("t_01.P01_Check: Internal error: learner_r or expected_r is NULL"))
  }

  # Compare the variables and this function is done
  if (identical(learner_r$info$vval, expected_r$info$vval) == TRUE) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
  }
  return(result)
}

# Prompt: "What is 111 divided by 9? (num)
# This callback shows that hints can be added programmatically within the callback.
#
# NOTE: There is no reason to implement this callback, since DEFAULT_Check
#       implements this functionality.
num.P01_Check <- function(var_name, result) {
  internal_id <- ps_var_name_to_id(var_name)

  # Get the learner and expected variable information
  learner_r <- get_global_var_info(var_name)
  expected_r <- get_expected_var_info(var_name)

  # This should never happen, since this callback should only be called when
  # both variables exist
  if (is.null(learner_r) || is.null(expected_r)) {
    stop(paste0("num.P01_Check: Internal error: learner_r or expected_r is NULL"))
  }

  if (learner_r$info$vval == expected_r$info$vval) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    t <- result_main_message(result_error_msg(internal_id, TRUE))
    t <- result_sub_message(t, "Do you use the division operator (/) and assignment operator (<-)?")
    t <- result_sub_message(t, "Is the variable name correct (num)?")
    result <- result_update(result, internal_id, FALSE, t)
  }
  return(result)
}

# Practice set T03 ----
#----------------------------------------------------------------------------#
# Examples for Practice Set T03
#----------------------------------------------------------------------------#
# NOTE: This illustrates a callback in which the test is more complex -
#       specifically, all combinations are two input arguments are tested
#
#       This capability is NOT currently available in the default callback,
#       but it could be added quite easily:
#          (1) Revise the mark-up to allow two checking variables
#          (2) Update the default call back to handle this case
#
h.T05_Check <- function(var_name, result) {
  internal_id <- ps_var_name_to_id(var_name)

  # Get the learner and expected variable information
  learner_r <- get_global_var_info(var_name)
  expected_r <- get_expected_var_info(var_name)

  # This should never happen, since this callback should only be called when
  # both variables exist
  if (is.null(learner_r) || is.null(expected_r)) {
    stop(paste0("num.P01_Check: Internal error: learner_r or expected_r is NULL"))
  }

  checks_arg1 <- c(10, 20, 30, 0)
  checks_precision <- c(2, 4, 0)

  learner_answers <- c()
  expected_answers <- c()

  if (learner_r$info$vtype == "closure") {
    for (k in 1:length(checks_precision)) {
      t1 <- do.call(learner_r$info$vname, list(checks_arg1, checks_precision[k]), envir=get_envir(1))
      t2 <- do.call(expected_r$info$vname, list(checks_arg1, checks_precision[k]), envir=get_envir(2))

      learner_answers <- append(learner_answers, t1)
      expected_answers <- append(expected_answers, t2)
    }

    if (identical(learner_answers, expected_answers, ignore.environment = TRUE) == TRUE) {
      result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
    } else {
      result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
    }
    return(result)
  }
}

# Practice Set DS-7-3 ----
word_bin.DS_07_3_Check <- function(var_name, result) {
  internal_id <- ps_var_name_to_id(var_name)

  # Get the learner and expected variable information
  learner_r <- get_global_var_info(var_name)
  expected_r <- get_expected_var_info(var_name)

  # This should never happen, since this callback should only be called when
  # both variables exist
  if (is.null(learner_r) || is.null(expected_r)) {
    stop(paste0("word_bin.DS_7_3_Check: Internal error: learner_r or expected_r is NULL"))
  }

  if (learner_r$info$vtype == "closure") {
    checks_arg1 <- c("convivial", "love", "excitment", "mountains", "fast", "bicycles", "stars")
    bound1 <- c("a", "f", "m", "z")
    bound2 <- c("a", "f", "m", "z")

    learner_answers <- c()
    expected_answers <- c()

    num_args <- signature_ok(learner_r$info$vval, expected_r$info$vval)

    # If the number of parameters differ from expected - note error message
    if (num_args < 0) {
      t <- result_main_message(result_error_msg(internal_id, TRUE))
      t <- result_sub_message(t, "Check the number of arguments in your function")
      result <- result_update(result, internal_id, FALSE, t)
      return(result)
    }

    for (j in 1:length(bound1)) {
      for (k in 1:length(bound2)) {
        t1 <- do.call(learner_r$info$vname, list(checks_arg1, bound1[j], bound2[k]), envir=get_envir(1))
        t2 <- do.call(expected_r$info$vname, list(checks_arg1, bound1[j], bound2[k]), envir=get_envir(2))

        learner_answers <- append(learner_answers, t1)
        expected_answers <- append(expected_answers, t2)
      }
    }

    if (identical(learner_answers, expected_answers, ignore.environment = TRUE) == TRUE) {
      result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
    } else {
      result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
    }
    return(result)
  }
}

# #add_pizza.DS-08-1_Check <- function(var_name, result)  {
#   internal_id <- ps_var_name_to_id(var_name)
#
#   # Get the learner and expected variable information
#   learner_r <- get_global_var_info(var_name)
#   expected_r <- get_expected_var_info(var_name)
#
#   # This should never happen, since this callback should only be called when
#   # both variables exist
#   if (is.null(learner_r) || is.null(expected_r)) {
#     stop(paste0("word_bin.DS_7_3_Check: Internal error: learner_r or expected_r is NULL"))
#   }
#
#   if (learner_r$info$vtype == "closure") {
#     checks_arg1 <- c("convivial", "love", "excitment", "mountains", "fast", "bicycles", "stars")
#     bound1 <- c("a", "f", "m", "z")
#     bound2 <- c("a", "f", "m", "z")
#
#     learner_answers <- c()
#     expected_answers <- c()
#
#     num_args <- signature_ok(learner_r$info$vval, expected_r$info$vval)
#
#     # If the number of parameters differ from expected - note error message
#     if (num_args < 0) {
#       t <- result_main_message(result_error_msg(internal_id, TRUE))
#       t <- result_sub_message(t, "Check the number of arguments in your function")
#       result <- result_update(result, internal_id, FALSE, t)
#       return(result)
#     }
#
#     for (j in 1:length(bound1)) {
#       for (k in 1:length(bound2)) {
#         t1 <- do.call(learner_r$info$vname, list(checks_arg1, bound1[j], bound2[k]))
#         t2 <- do.call(expected_r$info$vname, list(checks_arg1, bound1[j], bound2[k]))
#
#         learner_answers <- append(learner_answers, t1)
#         expected_answers <- append(expected_answers, t2)
#       }
#     }
#
#     if (identical(learner_answers, expected_answers, ignore.environment = TRUE) == TRUE) {
#       result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
#     } else {
#       result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
#     }
#     return(result)
#   }
# }

# The remaining tasks are handled by the default callback function,
# which is named DEFAULT_Check() (see "practice-201.R")
