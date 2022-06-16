# library("stringr")
# library("rstudioapi")
# library(shiny)
# library(miniUI)
#
# source("./R/ui.R")
# source("./R/code_analysis.R")
#

# Imports ----
#----------------------------------------------------------------------------#
# TODO: Import selected functions from these libraries
#----------------------------------------------------------------------------#
#' @import miniUI
NULL

#' @import stringr
NULL

#' @import shiny
NULL

#' @import rstudioapi
NULL

# Problem Set Definitions ----
#----------------------------------------------------------------------------#
# The prompts and answers are specified in these files
#----------------------------------------------------------------------------#
source("./R/practice-sets/practice-set-01.R")
source("./R/practice-sets/practice-set-02.R")

# Global Variables ----
pkg.globals <- new.env()
pkg.globals$gPRACTICE_SETS <- list(ps01, ps02)
pkg.globals$gPRACTICE_SET_ID <- 1
pkg.globals$gTO_CONSOLE <- FALSE

# Constants ----
cDEBUG <- FALSE
cTAB_IN_SPACES <- "   "

# Manage Practice Sets ----
#----------------------------------------------------------------------------#
# Functions for setting and accessing practice sets
#----------------------------------------------------------------------------#
ps_set_current <- function(id) {
  if (is.null(pkg.globals$gPRACTICE_SETS)) {
    stop("practice-info-201.R: Practice sets are not set.")
  }
  if (id <= 0 || id > length(pkg.globals$gPRACTICE_SETS)) {
    stop(paste0("practice_inof-201.R: Practice Set ID must be between 1 and ", length(pkg.globals$gPRACTICE_SETS), "."))
  }

  pkg.globals$gPRACTICE_SET_ID <- id
}

ps_get_current <- function(id = NULL) {
  if (is.null(id)) {
    id <- pkg.globals$gPRACTICE_SET_ID
  }
  ps <- pkg.globals$gPRACTICE_SETS[[id]]

  return(ps)
}

ps_update_current <- function(ps) {
  pkg.globals$gPRACTICE_SETS[[pkg.globals$gPRACTICE_SET_ID]] <- ps
}

ps_test_current <- function() {
  # TBD
  return(TRUE)
}

ps_get_id_by_short <- function(short_id) {
  for (ps in pkg.globals$gPRACTICE_SETS) {
    if (ps$ps_short == short_id) {
      return(ps$ps_id)
    }
  }
  return(NULL)
}

# This returns a list of practice set titles and ids, suited
# to a Shinny selectInput widget.  The list has this structure:
#    list("P01: <title>" = "P1", "P2: <title>" = "P02")
ps_ui_get_titles <- function() {
  if (is.null(pkg.globals$gPRACTICE_SETS)) {
    stop("practice-info-201.R: Practice sets are not set.")
  }

  items <- c()
  ids <- c()

  for (ps in pkg.globals$gPRACTICE_SETS) {
    s <- paste0(ps$ps_short, ": ", ps$ps_title)
    items <- append(items, s)
    ids <- append(ids, ps$ps_short)
  }
  t <- as.list(stats::setNames(ids, items))
  # t <- list("P01: xxx" = "P01", "P02: xxx" = "P02")
  return(t)
}

# Variables ----
#----------------------------------------------------------------------------#
# Functions for setting up the initial variables on which the practice
# prompts can depend
#----------------------------------------------------------------------------#
set_initial_vars_doit <- function(expr) {
  eval(parse(text = expr))
}

set_env_vars <- function() {
  ps <- ps_get_current()
  t <- lapply(ps$initial_vars, set_initial_vars_doit)
}

# Checking Callbacks ----
#----------------------------------------------------------------------------#
# Functions related to the callback functions for checking learner's work
#----------------------------------------------------------------------------#

# The default callback, which checks for correctness - yes or no
# NOTE: Investigate identical()
DEFAULT_Check <- function(internal_id, val, result) {
  if (cDEBUG) {
    print("--- DEFAULT_Check")
    print(paste0("internal id:    ", internal_id))
    print(paste0("prompt id:      ", ps_get_prompt_id(internal_id)))
    print(paste0("var name:       ", ps_get_assignment_var(internal_id)))
    print(paste0("expected:       ", ps_get_expected_answer(internal_id)))
    print(paste0("learner answer: ", ps_get_learner_answer(internal_id)))
    print(paste0("answer val:     ", val))
    print("---")
  }

  if (is.nan(val) && is.nan(eval_expr(internal_id))) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else if (val == eval_expr(internal_id)) {
    result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
  } else {
    result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
  }

  return(result)
}

# Checks if a callback function for checking a learner's answer
# has been implemented
is_callback_loaded <- function(funct_name) {
  f_pattern <- paste0("^", funct_name, "$")
  t <- (length(ls(envir = globalenv(), pattern = f_pattern)) == 1)
  return(t)
}

# Prompts ----
#----------------------------------------------------------------------------#
# Functions for accessing information about the practice set
# Note: id is an internal index
#----------------------------------------------------------------------------#
ps_get_prompt_id <- function(id) {
  ps <- ps_get_current()
  return(ps$task_list[[id]]$prompt_id)
}

practice_get_all_assignment_vars <- function() {
  ps <- ps_get_current()
  vars <- c()
  for (t in ps$task_list) {
    vars <- append(vars, t$assignment_var)
  }
  return(vars)
}

# Determine the assignment variables that a learner has initialized
# var_names <- ls(envir = globalenv(), pattern = "^t_..$")
get_var_names <- function() {
  expected <- practice_get_all_assignment_vars()
  all <- ls(envir = globalenv())
  var_names <- expected[expected %in% all]
  return(var_names)
}

ps_get_assignment_var <- function(id) {
  ps <- ps_get_current()
  return(ps$task_list[[id]]$assignment_var)
}

ps_get_internal_id_from_var_name <- function(var_name) {
  ps <- ps_get_current()
  id <- which(practice_get_all_assignment_vars() == var_name)
  return(id)
}

ps_get_internal_id_from_prompt_id <- function(prompt_id) {
  ps <- ps_get_current()
  prompt_ids <- c()
  for (t in ps$task_list) {
    prompt_ids <- append(prompt_ids, t$prompt_id)
  }
  id <- which(prompt_ids == prompt_id)
  return(id)
}

ps_get_prompt <- function(id) {
  ps <- ps_get_current()
  t <- paste0(ps$task_list[[id]]$prompt_msg, " (", ps$task_list[[id]]$assignment_var, ")")
  return(t)
}

ps_get_expected_answer_rs <- function(id) {
  ps <- ps_get_current()
  t <- ps$task_list[[id]]$expected_answer
  return(t)
}

ps_get_expected_answer <- function(id) {
  ps <- ps_get_current()
  t <- paste0(ps_get_assignment_var(id), " <- ", ps$task_list[[id]]$expected_answer)
  return(t)
}

#' Evaluate an R expression
#'
#' To test a learner's answer, call this function. This function accesses
#' the learner's code, which is stored in the practice set data structure.
#'
#' @param id the internal ID for the prompt
#' @return returns the result of the evaluation. If the learner's code produces
#' a function (that is, a "closure") a text string summarizing the function is
#' returned
#' @export
eval_expr <- function(id) {
  answer <- ps_get_expected_answer(id)
  t <- eval(parse(text = answer))
  if (typeof(t) == "closure") {
    args <- formals(t)
    v <- names(args)
    t <- paste0(v, collapse = ", ")
    t <- paste0("function(", t, ") {...}")
  }
  return(t)
}

ps_num_hints <- function(id) {
  ps <- ps_get_current()
  hints <- ps$task_list[[id]]$hints
  return(length(hints))
}

ps_get_formatted_hints <- function(id) {
  ps <- ps_get_current()
  hints <- ps$task_list[[id]]$hints
  t <- ""
  for (h in hints) {
    t <- paste0(t, "\n", cTAB_IN_SPACES, h)
  }
  return(t)
}

ps_update_learner_answer <- function(ps, var_name, answer) {
  id <- ps_get_internal_id_from_var_name(var_name)
  ps$task_list[[id]]$learner_answer <- answer
  return(ps)
}

ps_get_learner_answer <- function(id) {
  ps <- ps_get_current()
  t <- ps$task_list[[id]]$learner_answer
  return(t)
}

# Prompts ----
#----------------------------------------------------------------------------#
# Functions for presenting the prompts
#----------------------------------------------------------------------------#
number_of_prompts <- function() {
  ps <- ps_get_current()
  t <- length(ps$task_list)
  return(t)
}

# Format the practice set as an R script
format_practice_script <- function(short) {
  ps <- ps_get_current(ps_get_id_by_short(short))

  t <- ""
  for (task in ps$task_list) {
    msg <- str_replace_all(task$prompt_msg, "\n", "\n#   ")
    t <- paste0(t, "# ", task$prompt_id, ": ", msg, " (", task$assignment_var, ")", "\n\n")
  }

  t <- paste0(
    "# ", ps$ps_title, "(", ps$ps_short, ")\n",
    "# ", str_replace_all(ps$ps_descr, "\n", "\n# "), "\n",
    "# --------\n",
    "practice.begin(\"", ps$ps_short, "\")\n",
    t,
    "practice.check()\n"
  )
  return(t)
}

format_prompts <- function(do_not_show = NULL) {
  ps <- ps_get_current()
  t <- ""
  id <- 0
  for (task in ps$task_list) {
    id <- id + 1
    if (is.null(do_not_show)) {
      t <- paste0(t, ps$ps_short, ".", task$prompt_id, ": ", task$prompt_msg, " (", task$assignment_var, ")", "\n")
    } else {
      if ((id %in% do_not_show) == FALSE) {
        t <- paste0(t, ps$ps_short, ".", task$prompt_id, ": ", task$prompt_msg, " (", task$assignment_var, ")", "\n")
      }
    }
  }

  t <- paste0(
    ps$ps_title, "(", ps$ps_short, ")\n",
    ps$ps_descr, "\n",
    "--------\n",
    t
  )

  return(t)
}

# Answers ----
#----------------------------------------------------------------------------#
# Functions for presenting answers
# styler::style_text("t <-function(a) {return (a+1)}")
#----------------------------------------------------------------------------#
format_answers <- function() {
  ps <- ps_get_current()
  short <- ps$ps_short
  t <- ""
  for (task in ps$task_list) {
    t <- paste0(t, task$prompt_id, ": ", task$prompt_msg, " (", task$assignment_var, ")", "\n")

    expected <- format_code(paste0(task$assignment_var, " <- ", task$expected_answer))
    expected_t <- paste0(expected, "\n", collapse = "")

    t <- paste0(t, expected_t)

    task_id <- ps_get_internal_id_from_prompt_id(task$prompt_id)
    t <- paste0(t, cTAB_IN_SPACES, "<span style='color:purple'>> ", eval_expr(task_id), "</span>\n")
  }
  return(t)
}

#----------------------------------------------------------------------------#
# This function checks if the practice prompts are correct or incorrect and
# collects student feedback for each of the practice prompts. It does the
# following:
#   1. Get all the variable names that need to be checked
#   2. For each variable name, call the corresponding callback:
#           <var_name>_Check(internal_id, val, practice_result)
#   3. Collect collect all the feedback.
#----------------------------------------------------------------------------#
check_answers <- function() {

  # This structure is used hold feedback on the practice coding prompts.
  practice_result <- list(
    num_correct = 0,
    num_incorrect = 0,
    message_list = list()
    # The message_list comprises a list of messages, as follows:
    #      message = list(
    #        prompt_id = <from_practice_set>,
    #        msg_text =  <feedback from the callback>)
  )

  # Get all of the variable names that need to be checked for correctness
  var_names <- get_var_names()

  # No variables initialized - format result and return
  if (length(var_names) == 0) {
    t <- format_result(practice_result)
    return(t)
  }

  # Get all the answers as code
  learner_code <- process_script()

  # Call each of the functions that checks if the correct value
  # has been computed. These functions follow this pattern:
  #    <var_name>_Check(val,practice_result)
  for (k in 1:length(var_names)) {
    var <- var_names[k]
    val <- eval(parse(text = var))

    # Update the practice set data structure to include code used to
    # answer each of the tasks
    answer_code <- get_answer(learner_code, var)
    ps <- ps_get_current()
    ps <- ps_update_learner_answer(ps, var, answer_code)
    ps_update_current(ps)

    internal_id <- ps_get_internal_id_from_var_name(var)
    funct_callback <- paste0(var, "_Check") # Construct callback function name

    if (is_callback_loaded(funct_callback) == TRUE) {
      practice_result <- do.call(funct_callback, list(internal_id, val, practice_result))
    } else {
      practice_result <- DEFAULT_Check(internal_id, val, practice_result)
    }
  }
  t <- format_result(practice_result)
  return(t)
}


# Formatting results ----
#----------------------------------------------------------------------------#
# Functions for formatting and outputting feedback on practice sets
#----------------------------------------------------------------------------#
format_code <- function(code_text, indent = cTAB_IN_SPACES) {
  t <- styler::style_text(code_text)
  t <- paste0(indent, t)
  t <- paste0(t, collapse = "\n")
  return(t)
}

#' Formats a "good" message
#'
#' This should be called when a learner's answer is correct.
#'
#' @param id the internal ID for the prompt
#' @return a formatted string that can be concatenated to a full output string
#' @export
result_good_msg <- function(id) {
  expected <- ps_get_expected_answer(id)
  answer <- eval_expr(id)
  t <- answer
  t <- paste0(
    "<span style='color:green'>&#10004;</span> Expected: \n",
    "", format_code(expected),
    "\n<span style='color:purple'>   > ", t,
    "</span>"
  )
  return(t)
}

#' Formats a "try again" message
#'
#' This should be called when a learner's answer is incorrect.
#'
#' @param id the internal ID for the prompt
#' @param show_hints to show or not show the hints for incorrect answers
#' @return a formatted string that can be concatenated to a full output string
#' @export
result_error_msg <- function(id, show_hints = TRUE) {
  t <- paste0("Try again. Prompt: \"", ps_get_prompt(id), "\"")
  if (ps_num_hints(id) > 0) {
    t <- paste0(t, "\nCheck:")
    t <- paste0(t, ps_get_formatted_hints(id))
  }
  return(t)
}

#' Formats a message
#'
#' Currently, no formatting is done.
#'
#' @param main_message the text of the message
#' @return a formatted string that can be concatenated to a full output string
#' @export
result_main_message <- function(main_message) {
  return(main_message)
}

#' Format a sub-message
#'
#' Currently, sub-messages are simply intended
#'
#' @param message the formatted text of the current message
#' @param sub_message the sub-message to be added
#' @return a formatted string that can be concatenated to a full output string
#' @export
result_sub_message <- function(message, sub_message) {
  t <- paste0(message, "\n", cTAB_IN_SPACES, sub_message)
  return(t)
}

#' Updates a result data structure
#'
#' When implementing checks to prompts in callbacks (\code{<var_name>_CHECK}), this
#' function is called to update the learner's results. For an example, see
#' \code{\link{DEFAULT_Check}}.
#'
#' @param result a list that holds data related to the correctness of the learners work
#' @param id the internal ID of a specific prompt
#' @param is_correct indicating whether the learner's answer is correct or not
#' @param text a message for the learner about their answer
#' @return result the updated data structure
#' @export
result_update <- function(result, id, is_correct, text) {
  if (is_correct == TRUE) {
    result$num_correct <- result$num_correct + 1
    result$correct_v <- append(result$correct_v, id)
  } else {
    result$num_incorrect <- result$num_incorrect + 1
    result$incorrect_v <- append(result$incorrect_v, id)
  }

  result$message_list <- append(
    result$message_list,
    list(message = list(prompt_id = ps_get_prompt_id(id), msg_text = text))
  )
  return(result)
}

format_result <- function(result) {
  total <- number_of_prompts()
  num_attempted <- result$num_correct + result$num_incorrect
  num_correct <- result$num_correct

  if (cDEBUG) {
    print("--- begin: format_result --- ")
    print(result)
    print("--- end: format_result ---")
  }

  ps <- ps_get_current()

  t <- ""
  t <- paste0(t, ps$ps_title, "\n", ps$ps_descr, "\n")
  t <- paste0(t, "Checking code: ", num_correct, "/", total, " complete.")
  if (total == num_correct) {
    t <- paste0(t, " Good work!\n")
  } else {
    t <- paste0(t, " More work to do.\n")
  }

  for (m in result$message_list) {
    t <- paste0(t, m$prompt_id, ": ", m$msg_text, "\n")
  }

  correct_list <- paste0(result$correct_v, collapse = " - ")
  incorrect_list <- paste0(result$incorrect_v, collapse = " - ")

  t <- paste0(t, "\n Correct: ", correct_list)
  t <- paste0(t, "\n Incorrect: ", incorrect_list)

  return(t)
}

# Output ----
#----------------------------------------------------------------------------#
# Functions for sending output to Console or Viewer
#----------------------------------------------------------------------------#
print_to_console <- function(text) {
  t <- text
  if (cDEBUG == FALSE) {
    t <- paste0("\014", t) # Clear the console
  }
  cat(t)
}

print_to_viewer <- function(text, fn) {
  dir <- tempfile()
  dir.create(dir)
  html_file <- file.path(dir, paste0(fn, ".html"))

  t <- "<head></head><body><pre>"
  t <- paste0(t, text)
  t <- paste0(t, "</pre></body>")

  write(t, html_file)
  rstudioapi::viewer(html_file, height = 400)
}

print_output <- function(text, fn) {
  if (pkg.globals$gTO_CONSOLE) {
    print_to_console(text)
  } else {
    print_to_viewer(text, fn)
  }
}

# Addins ----
#----------------------------------------------------------------------------#
# The add-in functions for controlling the presentation of the practice
# sets
#----------------------------------------------------------------------------#

#' Begin a practice set. Call this function to install a specific practice
#' set and to set things up. Currently, there are two practice sets -
#' "P01" and "P02".
#'
#' @param short The short ID for this practice set.
#' @return `TRUE` if all goes well; otherwise, this function will stop with an message.
#' @seealso \code{\link{practice.questions}}
#' @export
practice.begin <- function(short = "P01") {
  id <- ps_get_id_by_short(short)
  if (is.null(id)) {
    stop("practice.begin: Can't find practice set named", short)
  }

  # Set the current practice set ID
  ps_set_current(id)

  # Clear all variables in the R global environment
  var_names <- get_var_names()
  rm(list = var_names, envir = globalenv())

  # Check the basic integrity of the practice set
  ps_test_current()

  # Practice sets can set some initital variables in the R global
  # environment, allowing practice prompts to refer to these variables
  set_env_vars()

  return(TRUE)
}

#' Show all the questions for a practice set.
#'
#' @return `TRUE` if all goes well.
#' @seealso [practice.questions]
#' @export
practice.questions <- function(do_not_show=NULL) {
  ps <- ps_get_current()
  t <- format_prompts(do_not_show)
  print_output(t, "questions")
  return(TRUE)
}

#' Check the practice set answers.
#'
#' @return `TRUE` if all goes well; otherwise, this function will stop with an message.
#' @seealso \code{\link{practice.questions}}
#' @export
practice.check <- function() {
  t <- check_answers()
  print_output(t, "check")
  return(TRUE)
}

#' Show all the answers for the practice set
#'
#' @return `TRUE` if all goes well.
#' @seealso \code{\link{practice.questions}}
#' @export
practice.answers <- function() {
  ps <- ps_get_current()
  t <- format_answers()

  t <- paste0(
    ps$ps_title, ": Answers\n",
    ps$ps_descr, "\n",
    "--------\n",
    t
  )
  print_output(t, "anwers")
  return(TRUE)
}
