#----------------------------------------------------------------------------#
# Code for implementing the RStudio Addins
#----------------------------------------------------------------------------#

## Global Variables ----
pkg.globals <- new.env()
pkg.globals$gPRACTICE_SET_ID <- 1
pkg.globals$gTO_CONSOLE <- FALSE
pkg.globals$gUSER_NAME <- ""

## Constants ----
cDEBUG <- FALSE
cTAB_IN_SPACES <- "   "

# Manage Practice Sets ----
#----------------------------------------------------------------------------#
# Functions for setting and accessing practice sets
#----------------------------------------------------------------------------#
# This function is called with the package is loaded. It is used to initialize
# the "built-in" practice sets.
ps_load_internal_ps <- function() {
  ps_add(load_ps("practice-set-01-spec.R"))
  ps_add(load_ps("practice-set-03-spec.R"))

  ps_add(load_ps("T01.R"))
  ps_add(load_ps("T02.R"))
  ps_add(load_ps("T03.R"))

  ps_add(load_ps("PS-Example.R"))

  ps_set_current(1)
}

# Add a practice set into the running package
ps_add <- function(ps) {
  new_k <- length(pkg.globals$gPRACTICE_SETS) + 1
  pkg.globals$gPRACTICE_SETS[[new_k]] <- ps
}

# Only one practice set is active at a time - A global variable is used
# to keep track of the currently active practice set
ps_set_current <- function(id) {
  if (is.null(pkg.globals$gPRACTICE_SETS)) {
    stop("Error: Practice sets are not set.")
  }
  if (id <= 0 || id > length(pkg.globals$gPRACTICE_SETS)) {
    stop(paste0("Error: Practice Set ID must be between 1 and ", length(pkg.globals$gPRACTICE_SETS), "."))
  }

  pkg.globals$gPRACTICE_SET_ID <- as.numeric(id)
}

# Return the currently active practice set
ps_get_current <- function() {
  id <- pkg.globals$gPRACTICE_SET_ID
  if (is.null(id) == TRUE || id < 1 || id > length(pkg.globals$gPRACTICE_SETS)) {
    stop("Error: Bad gPRACTICE_SET_ID")
  }
  ps <- pkg.globals$gPRACTICE_SETS[[id]]

  return(ps)
}

# Update the current practice set to a new one
ps_update_current <- function(ps) {
  pkg.globals$gPRACTICE_SETS[[pkg.globals$gPRACTICE_SET_ID]] <- ps
}

# Check the integrity of the current practice set
ps_test_current <- function() {
  # TBD
  return(TRUE)
}

# Get the internal id of a practice set by its short id
# NOTE: Practice sets are assumed to have UNIQUE short ids
ps_get_id_by_short <- function(short_id) {
  k <- 1
  for (ps in pkg.globals$gPRACTICE_SETS) {
    if (ps$ps_short == short_id) {
      return(k)
    }
    k <- k + 1
  }
  return(-1)
}

# Get the practice set by its short id
ps_get_by_short <- function(short_id) {
  id <- ps_get_id_by_short(short_id)
  if (id == -1) {
    return(NULL)
  } else {
    return(pkg.globals$gPRACTICE_SETS[[id]])
  }
}

# Get a vector of all of the practice set short ids
ps_get_all <- function() {
  v <- c()
  for (ps in pkg.globals$gPRACTICE_SETS) {
    v <- append(v, ps$ps_short)
  }
  return(v)
}

# Return a list of practice set titles and ids, suited
# to a Shinny selectInput widget.  The list has this structure:
#    list("P01: <title>" = "P01", "P2: <title>" = "P02")
# where "P01", "P02", and so on are the short ids for the practice sets
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
  print(t)
  return(t)
}

# Variables ----
#----------------------------------------------------------------------------#
# Functions for setting up the initial variables on which the practice
# prompts can depend
#----------------------------------------------------------------------------#
set_initial_vars_doit <- function(expr) {
  eval(parse(text = expr), envir = .GlobalEnv)
}

set_env_vars <- function() {
  ps <- ps_get_current()
  t <- lapply(ps$ps_initial_vars, set_initial_vars_doit)
}

get_env_vars <- function(short) {
  ps <- ps_get_by_short(short)
  return(ps$ps_initial_vars)
}


# Expression evaluation ----
#----------------------------------------------------------------------------#
# Functions for evaluating and formatting expressions
#----------------------------------------------------------------------------#
# Evaluates string and returns some details about the result
eval_string_details <- function(code) {
  tryCatch(
    expr = {
      val <- eval(parse(text = code), envir = .GlobalEnv)
      t <- typeof(val)
      list(ok = TRUE, value = val, type = t, error = NULL, scode = code)
    }, error = function(e) {
      list(ok = FALSE, value = NULL, type = NULL, error = e, scode = code)
    }
  )
}

eval_string <- function(code) {
  result <- eval_string_details(code)
  if (result$ok == TRUE) {
    return(result$value)
  } else {
    return(NULL)
  }
}

eval_string_and_format <- function(code) {
  result <- eval_string_details(code)
  if (result$ok == TRUE) {
    if (result$type %in% c("double", "integer", "real", "logical", "complex", "character")) {
      # Atomic types
      if (length(result$value) == 1) {
        return(paste0("atomic: ", as.character(result$value)))

        # Vector types
      } else {
        t <- paste0(result$value, collapse = " ")
        return(paste0("vector: ", t))
      }
      # A function
    } else if (result$type == "closure") {
      args <- names(formals(result$value))
      t <- paste0(args, collapse = ", ")
      t <- paste0("function(", t, ") {...}")
      return(paste0("funct: ", t))

      # A type that is not handled
    } else {
      return("type not formatted")
    }
  } else {
    return("syntax error")
  }
}

format_code2 <- function(code) {
  # Collapse everything to a long string
  t <- paste0(code, collapse = "\n")
  # Styler might produce multiple strings ( s<-1; t<-2)
  t <- styler::style_text(t)
  # Collapse it again
  t <- paste0(code, collapse = "\n")
  # if (length(code) > 1) {
  #   t <- paste0("\n", t)
  # }
  return(t)
}

expected_answer <- function(id) {
  code <- ps_get_expected_answer(id)
  r <- eval_string_details(code)
  if (r$ok == FALSE) {
    return("<error-something-broken>")
  } else {

    # Check for a function
    if (r$type == "closure") {
      args <- formals(r$value)
      v <- names(args)
      t <- paste0(v, collapse = ", ")
      t <- paste0("function(", t, ") {...}")
    } else if (r$type %in% c("double", "integer", "real", "logical", "complex", "character")) {
      if (length(r$value) == 1) {
        # Check for atomic
        t <- paste0("atomic: ", r$scode)
      } else {
        # Check for vector > 1
        t <- paste0(r$value, collapse = " ")
        t <- paste0("vector: ", t)
      }
    # Check for dataframe
    } else if (is.dataframe(r$type)) {
      nr <- nrow(r$value)
      nc <- ncol(r$value)
      t <- paste0("df: [", nr, "x", ncol, "]")

    # Everything else
    } else {
      t <- paste0("everything else: ", r$scode)
    }
  }
  return(t)
}

# Checking Callbacks ----
#----------------------------------------------------------------------------#
# Functions related to the callback functions for checking learner's work
#----------------------------------------------------------------------------#

# The default callback, which checks for correctness - yes or no
# NOTE: Investigate identical()

#' Default function for checking learner's code
#'
#' @param internal_id the internal ID of the prompt from the practice set
#' @param result the result, which grows upon each call to a <var>_Check function
#'
DEFAULT_Check <- function(internal_id, result) {
  cDEBUG <- TRUE
  if (cDEBUG) {
    print("--- DEFAULT_Check")
    print(paste0("internal id:    ", internal_id))
    print(paste0("prompt id:      ", ps_get_prompt_id(internal_id)))
    print(paste0("var name:       ", ps_get_assignment_var(internal_id)))
    print(paste0("expected:       ", ps_get_expected_answer(internal_id)))
    print(paste0("learner answer: ", ps_get_learner_answer(internal_id)))
    print("---")
  }

  learner_result <- eval_string_details(ps_get_assignment_var(internal_id))

  if (cDEBUG) {
    print("...---...")
    print(learner_result)
    print("...---...")
  }

  if (learner_result$ok == TRUE) {
    if (cDEBUG) {
      print(">> Okay")
    }

    # # Check for not a number
    # if (is.nan(learner_val) && is.nan(expected_val)) {
    #   result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))

    if (learner_result$type %in% c("double", "integer", "real", "logical", "complex", "character")) {
      if (cDEBUG) {
        print(">> double, integer, etc.")
      }

      learner_val <- learner_result$value

      expected_result <- eval_string_details(ps_get_expected_answer(internal_id))
      expected_val <- expected_result$value

      # Atomic values
      if (length(learner_result$value) == 1) {
        if (cDEBUG) {
          print(">> Atomic")
        }

        if (identical(learner_val, expected_val, ignore.environment = TRUE) == TRUE) {
          result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
        } else {
          result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
        }

        # Vector values
      } else {
        if (cDEBUG) {
          print(">> Vector")
        }

        if (identical(learner_val, expected_val, ignore.environment = TRUE) == TRUE) {
          result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
        } else {
          result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
        }
      }

      # Functions
    } else if (learner_result$type == "closure") {
      if (cDEBUG) {
        print(">> Closure")
      }

      # Get the values that will be used to check the function
      checks <- ps_get_checks(internal_id)

      if (cDEBUG) {
        if (length(checks) == 0) {
          print("No checks")
        } else {
          t <- paste0(checks, collapse = " ")
          print(paste0("Checks: ", t))
        }
      }

      # Call the learner's function on each of the checks
      learner_f_answers <- do.call(learner_result$scode, list(checks))

      expected_code <- ps_get_expected_answer(internal_id)
      expected_function <- eval(parse(text = paste0(expected_code, collapse = "\n")))
      expected_f_answers <- do.call(expected_function, list(checks))

      if (identical(learner_f_answers, expected_f_answers, ignore.environment = TRUE) == TRUE) {
        result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
      } else {
        result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
      }

    # Check for dataframe
    } else if (is.dataframe(learner_result$type)) {

      learner_val <- learner_result$value

      expected_result <- eval_string_details(ps_get_expected_answer(internal_id))
      expected_val <- expected_result$value

      if (identical(learner_val, expected_val, ignore.environment = TRUE) == TRUE) {
        result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
      } else {
        result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
      }

    } else {
      if (cDEBUG) {
        print(">> Type not handled")
      }
      t <- result_prompt_error(internal_id, "Type not handled.")
      result <- result_update(result, internal_id, FALSE, t)
    }
  } else {
    if (cDEBUG) {
      print(">> Syntax error")
    }
    t <- result_prompt_error(internal_id, "Syntax error")
    result <- result_update(result, internal_id, FALSE, t)
  }

  return(result)
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
    user_name = pkg.globals$gUSER_NAME,
    num_correct = 0,
    num_incorrect = 0,
    message_list = list()
    # The message_list comprises a list of messages, as follows:
    #      message = list(
    #        prompt_id = <from_practice_set>,
    #        msg_text =  <feedback from the callback>)
  )

  # Get all of the variable names that need to be checked for correctness
  var_names <- ps_get_live_var_names()

  # No variables initialized - format result and return
  if (length(var_names) == 0) {
    t <- format_result(practice_result)
    return(t)
  }

  # Get all the answers as code
  # learner_code <- process_script()

  # Call each of the functions that checks if the correct value
  # has been computed. These functions follow this pattern:
  #    <var_name>_Check(val,practice_result)
  for (k in 1:length(var_names)) {
    var <- var_names[k]
    internal_id <- ps_get_internal_id_from_var_name(var)

    # Update the practice set data structure to include code used to
    # answer each of the tasks
    # answer_code <- get_answer(learner_code, var)
    # ps <- ps_get_current()
    # ps <- ps_update_learner_answer(ps, var, answer_code)
    # ps_update_current(ps)

    if (is_callback_loaded(var) == TRUE) {
      practice_result <- do.call(get_callback_name(var), list(internal_id, practice_result))
    } else {
      practice_result <- DEFAULT_Check(internal_id, practice_result)
    }
  }
  t <- format_result(practice_result)
  return(t)
}

# Checks if a callback function for checking a learner's answer
# has been implemented load
get_callback_name <- function(var_name) {
  return(paste0(var_name, "_Check"))
}

is_callback_loaded <- function(var_name) {
  funct_name <- get_callback_name(var_name)
  f_pattern <- paste0("^", funct_name, "$")
  t <- (length(ls(name = "package:pinfo201", pattern = f_pattern)) == 1)
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

ps_get_all_assignment_vars <- function() {
  ps <- ps_get_current()
  vars <- c()
  for (t in ps$task_list) {
    if (t$assignment_var != "") {
      vars <- append(vars, t$assignment_var)
    }
  }
  return(vars)
}

ps_get_checks <- function(id) {
  v <- c()
  ps <- ps_get_current()
  checks <- ps$task_list[[id]]$checks_for_f
  if (checks != "") {
    v <- eval(parse(text = checks))
  }
  return(v)
}



# Determine the assignment variables that a learner has initialized
# var_names <- ls(envir = globalenv(), pattern = "^t_..$")
ps_get_live_var_names <- function() {
  expected <- ps_get_all_assignment_vars()
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
  for (k in 1:length(ps$task_list)) {
    if (ps$task_list[[k]]$assignment_var == var_name) {
      return(k)
    }
  }
  return(-1)
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

#' Get the expected answer
#'
#' Xxx xxx xxx
#'
#' @param id the internal ID for the prompt
#' @return formatted code
#' @export
ps_get_expected_answer <- function(id) {
  ps <- ps_get_current()

  if (id < 1 || id > length(ps$task_list)) {
    stop(paste0("id is out of bounds (id=", id, ")"))
  }

  a <- ps$task_list[[id]]$expected_answer
  if (length(a) == 1) {
    if (str_detect(a, "<-") == TRUE) {
      t <- a
    } else {
      t <- paste0(ps_get_assignment_var(id), " <- ", a)
    }
  } else {
    t <- a
  }
  return(t)
}

# Hints -----

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

# Answer code ----

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
  num <- 0
  for (task in ps$task_list) {
    if (task$is_note_msg == FALSE) {
      num <- num + 1
    }
  }
  return(num)
}

format_practice_script <- function(id) {
  ps <- ps_get_current()

  t <- ""
  for (task in ps$task_list) {
    msg <- str_replace_all(task$prompt_msg, "\n", "\n#   ")
    if (task$is_note_msg == TRUE) {
      t <- paste0(t, "# Note: ", msg, "\n\n")
    } else {
      t <- paste0(t, "# ", task$prompt_id, ": ", msg, " (", task$assignment_var, ")", "\n\n")
    }
  }

  s <- ""
  if (pkg.globals$gUSER_NAME != "") {
    s <- paste0("# Learner name: ", pkg.globals$gUSER_NAME, "\n")
  }

  t <- paste0(
    "# ", ps$ps_short, ": ", ps$ps_title, "\n",
    "# ", str_replace_all(ps$ps_descr, "\n", "\n# "), "\n",
    s,
    "# ---\n",
    "practice.begin(\"", ps$ps_short, "\", learner=\"<your name>\")\n",
    t,
    "practice.check()\n"
  )
  return(t)
}

format_prompts <- function(do_not_show = NULL) {
  ps <- ps_get_current()
  t_out <- ""

  if (is.null(do_not_show)) {
    for (task in ps$task_list) {
      m <- task$prompt_msg

      if (task$prompt_id == "-") {
        # t_out <- paste0(t_out, "   <span style='color:blue'><b>Note</b>: ", m, "</span>")
        # t_out <- paste0(t_out, "\n     Note:\n")
        t_out <- paste0(t_out, "\n   <b>Note</b>: ", m, "\n")
      } else {
        t_out <- paste0(
          t_out, task$prompt_id, ": ",
          m,
          " (", task$assignment_var, ")", "\n"
        )
      }
    }
  }

  #   else {
  #       if ((id %in% do_not_show) == FALSE) {
  #         t <- paste0(
  #           t, ps$task[[k]]$prompt_id, ": ",
  #           ps$task[[k]]$prompt_msg,
  #           " (", ps$task[[k]]$assignment_var, ")", "\n"
  #         )
  #       }
  #     }
  #   }
  # }


  # for (k in 1: length(ps$task_list)) {
  #
  #   print(ps$task_list[[k]]$prompt_id)
  #   print(ps$task_list[[k]]$is_note_msg)
  #
  #   if (ps$task_list[[k]]$is_note_msg == TRUE) {
  #     print("Here")
  #     t <- paste0("\nNote:", t, ps$task_list[[k]]$prompt_msg, "\n")
  #   } else {
  #     if (is.null(do_not_show)) {
  #       t <- paste0(t, ps$task_list[[k]]$prompt_id, ": ",
  #                   ps$task_list[[k]]$prompt_msg,
  #                   " (", ps$task_list[[k]]$assignment_var, ")", "\n")
  #     } else {
  #       if ((id %in% do_not_show) == FALSE) {
  #         t <- paste0(t, ps$task_list[[k]]$prompt_id, ": ",
  #                     ps$task_list[[k]]$prompt_msg,
  #                     " (", ps$task_list[[k]]$assignment_var, ")", "\n")
  #       }
  #     }
  #   }
  # }

  t_out <- paste0(
    "<b>", ps$ps_short, ": ", ps$ps_title, "</b>\n",
    ps$ps_descr, "\n",
    "---\n",
    t_out
  )

  return(t_out)
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
  id <- 0
  for (task in ps$task_list) {
    if (task$is_note_msg == FALSE) {
      id <- ps_get_internal_id_from_prompt_id(task$prompt_id)
      t <- paste0(t, task$prompt_id, ": ", ps_get_prompt(id), "\n")

      expected <- format_code(ps_get_expected_answer(id))
      expected_t <- paste0("<span style='color:purple'>", expected, "</span>\n", collapse = "")

      t <- paste0(t, expected_t)
      t <- paste0(t, cTAB_IN_SPACES, expected_answer(id), "\n")
    }
  }
  return(t)
}

# Formatting results ----
#----------------------------------------------------------------------------#
# Functions for formatting and outputting feedback on practice sets
#----------------------------------------------------------------------------#
format_code <- function(code_text, indent = cTAB_IN_SPACES) {
  print(code_text)
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
  answer <- expected_answer(id)
  t <- answer
  t <- paste0(
    "<span style='color:green'>&#10004;</span> Expected: \n",
    "", format_code(expected),
    "\n<span style='color:green'>   ", t,
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

result_prompt_error <- function(id, msg) {
  t <- paste0("Prompt error: \"", ps_get_prompt(id), "\"\n")
  t <- paste0(t, msg)
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
  t <- paste0(t, "<b>", ps$ps_short, ": ", ps$ps_title, "</b>\n", ps$ps_descr, "\n")
  t <- paste0(t, "---\n")
  t <- paste0(t,"<i>Learner name: ", result$user_name, "</i>\n" )
  t <- paste0(t, "---\n")
  t <- paste0(t, "Checking code: ", num_correct, "/", total, " complete.")
  if (total == num_correct) {
    t <- paste0(t, " Good work! &#128512;\n")
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
practice.begin <- function(short = "P01", learner="Anonymous") {
  id <- ps_get_id_by_short(short)
  if (id == -1) {
    stop("practice.begin: Can't find practice set named ", short)
  }

  # Currently, no session information, so just a global variable
  pkg.globals$gUSER_NAME <- learner

  # Set the current practice set ID
  ps_set_current(id)

  # Clear all variables in the R global environment
  var_names <- ps_get_live_var_names()
  rm(list = var_names, envir = globalenv())

  # Check the basic integrity of the practice set
  ps_test_current()

  # Practice sets can set some initial variables in the R global
  # environment, allowing practice prompts to refer to these variables
  set_env_vars()

  return(TRUE)
}

#' Show all the questions for a practice set.
#'
#' @param do_not_show optional list of internal IDs of questions to not show
#' @return `TRUE` if all goes well.
#' @seealso [practice.questions]
#' @export
practice.questions <- function(do_not_show = NULL) {
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
    "<b>", ps$ps_short, ": ", ps$ps_title, ": Answers</b>\n",
    ps$ps_descr, "\n",
    "---\n",
    t
  )
  print_output(t, "anwers")
  return(TRUE)
}

#' Read a practice set
#'
#' @param fn filename
#' @export
practice.load_url <- function(fn = paste0(
                                "https://raw.githubusercontent.com/",
                                "info201B-2022-Autumn/practice-sets/main/",
                                "PS-T10.R"
                              )) {
  ps <- create_ps_from_url(fn)
  ps_add(ps)
}
