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
cPACKAGE_ENVIR_NAME <- "package:pinfo201"

# Manage Practice Sets ----
#----------------------------------------------------------------------------#
# Functions for setting and accessing practice sets
#----------------------------------------------------------------------------#
# This function is called with the package is loaded. It is used to initialize
# the "built-in" practice sets.
#
# Note: These files are located here, because of the expected structure of
# packages:
#     inst/extdata/
ps_load_internal_ps <- function() {
  # Problem sets
  ps_add(load_ps("P01.R"))
  ps_add(load_ps("P02.R"))

  # Test cases
  ps_add(load_ps("T01.R"))
  ps_add(load_ps("T02.R"))
  ps_add(load_ps("T03.R"))
  ps_add(load_ps("T04.R"))
  ps_add(load_ps("T05.R"))

  # Basic illustrative example (used in documentation)
  ps_add(load_ps("PS_Example.R"))

  ps_set_current(1)
}

# Add a practice set into the running aplication
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

# Return the short ID of the currently active practrice set
ps_get_short <- function() {
  ps <- ps_get_current()
  return(ps$ps_short)
}

# Update the current practice set to a new one
ps_update_current <- function(ps) {
  pkg.globals$gPRACTICE_SETS[[pkg.globals$gPRACTICE_SET_ID]] <- ps
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

get_env_vars <- function(short="") {
  if (short == "") {
    ps <- ps_get_current()
  }
  else {
    ps <- ps_get_by_short(short)
  }
  return(ps$ps_initial_vars)
}

# Expression evaluation ----
#----------------------------------------------------------------------------#
# Functions for evaluating and formatting expressions
#----------------------------------------------------------------------------#
# Evaluates a code string and returns some details about the result
eval_string_details <- function(code) {
  tryCatch(
    expr = {
      val <- eval(parse(text = code), envir = .GlobalEnv)
      t <- typeof(val)
      if (is.data.frame(val)) {
        t <- "dataframe"
      }
      list(ok = TRUE, value = val, type = t, error = NULL, scode = code)
    }, error = function(e) {
      list(ok = FALSE, value = NULL, type = NULL, error = e, scode = code)
    }
  )
}

# This function evaluates some code and formats the result for
# compact presentation. Code can be either a single string
# or a vector of strings. These three expressions all produce
# the same thing - namely "atomic: 3":
#     "t <- 1; x <- t + 1; y <- x + 1"          (string with semi-colons)
#     c("t <- 1", "x <- t + 1", "y <- x + 1")   (vector of strings)
#     t <- 1\n x <- t + 1\n y <- x + 1"         (string with newlines)
#
eval_string_and_format <- function(code) {
  result <- eval_string_details(code)
  if (result$ok == TRUE) {
    # Check for basic type
    if (result$type %in% c("double", "integer", "real", "logical", "complex", "character")) {
      # Atomic types
      if (length(result$value) == 1) {
        return(paste0("atomic: ", as.character(result$value)))

      # Vector type
      } else {
        t <- paste0(result$value, collapse = " ")
        return(paste0("vector: ", t))
      }
      # Check for a function
    } else if (result$type == "closure") {
      args <- names(formals(result$value))
      t <- paste0(args, collapse = ", ")
      t <- paste0("function(", t, ") {...}")
      return(paste0("funct: ", t))

      # Check for dataframe
    } else if (result$type == "dataframe") {
      nr <- nrow(result$value)
      nc <- ncol(result$value)

      df_info_rows <- "0 rows"
      df_info_cols <- "0 columns"
      if (nr == 1) df_info_rows <- "1 row" else df_info_rows <- paste0(nr, " rows")
      if (nc == 1) df_info_cols <- "1 column" else df_info_cols <- paste0(nc, " columns")

      return(paste0("dataframe: [", df_info_rows, " x ", df_info_cols, "]"))

      # A type that is not handled
    } else {
      message("\nType unhandled:", result$type, "\n")
      return(paste0("Type unhandled: ", result$type))
    }
  } else {
    message("\nERROR: eval_string_and_format:\n", result$error)
    e <- str_replace_all(result$error[1], "\n", " ")
    t <- paste0("Error: ", e )
    return(t)
  }
}

# This function formats some code
format_code <- function(code_text, indent = cTAB_IN_SPACES) {
  t <- styler::style_text(code_text)
  t <- paste0(indent, t)
  t <- paste0(t, collapse = "\n")
  return(t)
}

expected_answer <- function(id) {
  code <- ps_get_expected_answer(id)
  return(eval_string_and_format(code))
}

# Checking Callbacks ----
#----------------------------------------------------------------------------#
# Functions related to the callback functions for checking learner's work
#----------------------------------------------------------------------------#

DEFAULT_Check <- function(internal_id, result) {
  cDEBUG <- FALSE
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
    } else if (learner_result$type == "dataframe") {

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
# This function evaluates a learner's answer and collects feedback for each
# of practice prompts.  It does the following:
#   1. From the Global environment, get all the active variables
#   2. For each variable name, call the DEFAULT callback or the
#      implemented callback, which takes this form:
#           <var_name>.<short>_Check(internal_id, practice_result)
#   3. Collect collect all the feedback in practice_result
#
# Callbacks are currently located in the file checks.R
#
# A practice_result takes this structure:
#
# practice_result <- list(
#    user_name = <string>,
#     num_correct = <integer>,
#     num_incorrect = <integer>,
#     message_list = list (
#        message = list (
#           internal_id = <internal integer>,
#           prompt_id = <string from problem set>,
#           correct = <boolean: is the answer correct?>,
#           msg_text = <message for learner>
#        )
#     )
# )
#----------------------------------------------------------------------------#
check_answers <- function() {

  # This structure is used hold feedback on the practice coding prompts.
  practice_result <- list(
    user_name = pkg.globals$gUSER_NAME,
    num_correct = 0,
    num_incorrect = 0,
    message_list = list()
  )

  # Get all of the variable names that need to be checked for correctness
  var_names <- ps_get_live_var_names()

  # No variables initialized - format result and return
  if (length(var_names) == 0) {
    return(practice_result)
  }

  # Get all the answers as code
  # learner_code <- process_script()

  # Call each of the functions that checks if the correct value
  # has been computed. These functions follow this pattern:
  #    <var_name>_Check(val,practice_result)
  for (k in 1:length(var_names)) {
    var <- var_names[k]
    internal_id <- ps_var_name_to_id(var)

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
  return(practice_result)
}

# Create the name for a callback function.  The name follows this template:
#     <var_name>.<short>_Check
#
# var_name  is the name of the variable that is defined in the problem set
# short     is the short name of the problem set (typically P)
#
# Typical examples: t_01.P01_Check | circle_area.P01_Check

get_callback_name <- function(var_name) {
  t <- paste0(var_name, ".", ps_get_short(), "_Check")
  return(t)
}

# Checks if a callback has been implemented for a prompt in a problem set
# Currently, these callbacks are implemented in the file "checks.R"
#
# TODO: Not sure how best to structure callbacks in a package, since
#       all R files need to be located in the the R/ directory.
#       Sub-directories do not seem to be allowed.

is_callback_loaded <- function(var_name) {
  funct_name <- get_callback_name(var_name)
  f_pattern <- paste0("^", funct_name, "$")
  t <- (length(ls(name = cPACKAGE_ENVIR_NAME, pattern = f_pattern)) == 1)
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

ps_var_name_to_id <- function(var_name) {
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
  id <- ps_var_name_to_id(var_name)
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
  # if (pkg.globals$gUSER_NAME != "") {
  #   s <- paste0("# Learner name: ", pkg.globals$gUSER_NAME, "\n")
  # }

  lines_of_code <- paste0(cTAB_IN_SPACES, get_env_vars(), collapse="\n")

  t <- paste0(
    "# ", ps$ps_short, ": ", ps$ps_title, "\n",
    "# ", str_replace_all(ps$ps_descr, "\n", "\n# "), "\n",
    s,
    "# ---\n",
    "practice.begin(\"", ps$ps_short, "\", learner=\"[your name]\")\n",
    "# Initial variables\n",
    lines_of_code, "\n",
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

result_main_message <- function(main_message) {
  return(main_message)
}

result_sub_message <- function(message, sub_message) {
  t <- paste0(message, "\n", cTAB_IN_SPACES, sub_message)
  return(t)
}

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
    list( message = list(
      internal_id = id,
      prompt_id = ps_get_prompt_id(id),
      correct = is_correct,
      msg_text = text)
      )
  )

  return(result)
}

format_result <- function(result) {
  total <- number_of_prompts()
  num_attempted <- result$num_correct + result$num_incorrect
  num_correct <- result$num_correct

  ps <- ps_get_current()

  t <- ""
  t <- paste0(t, "<b>", ps$ps_short, ": ", ps$ps_title, "</b>\n", ps$ps_descr, "\n")
  t <- paste0(t,"Learner name:\n<i>   ", result$user_name, "</i>" )
  t <- paste0(t, "\n")

  lines_of_code <- paste0(cTAB_IN_SPACES, get_env_vars(), collapse="\n")
  t <- paste0(t, paste0("Initial variables:\n", lines_of_code, "\n"))

  t <- paste0(t, "Checking code:\n   ", num_correct, "/", total, " complete.")
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

# A special formatter is needed for instructors and grading
format_grading <- function(results) {
  return(format_result(results))
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
