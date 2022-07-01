#----------------------------------------------------------------------------#
# Code for implementing the RStudio Addins
#----------------------------------------------------------------------------#

## Global Variables ----
pkg.globals <- new.env()
pkg.globals$gPRACTICE_SET_ID <- 1
pkg.globals$gTO_CONSOLE <- FALSE
pkg.globals$gUSER_NAME <- ""

pkg.expected_env <- new.env()

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
# Note: Because of the expected structure of packages, these file are located
# here, below the root directory for package development:
#     inst/extdata/
ps_load_internal_ps <- function() {
  # Freeman & Ross exercises
  ps_add(load_ps("DS-05-1.R")) # Practice with basic R syntax

  ps_add(load_ps("DS-06-1.R")) # Calling built-in functions
  ps_add(load_ps("DS-06-2.R")) # Using built-in string functions
  ps_add(load_ps("DS-06-3.R")) # Writing and executing functions
  ps_add(load_ps("DS-06-4.R")) # Functions and conditionals

  ps_add(load_ps("DS-07-1.R")) # Creating and operating on vectors
  ps_add(load_ps("DS-07-2.R")) # Indexing and filtering vectors
  ps_add(load_ps("DS-07-3.R")) # Vector practice

  ps_add(load_ps("DS-08-1.R")) # Creating and accessing lists
  ps_add(load_ps("DS-08-2.R")) # Using `*apply()` function

  # ps_add(load_ps("DS-10-1.R")) # Creating data frames
  # ps_add(load_ps("DS-10-2.R")) # Working with data frames
  # ps_add(load_ps("DS-10-3.R")) # Working with built-in data sets
  # ps_add(load_ps("DS-10-4.R")) # External data sets: Gates Foundation Educational Grants
  # ps_add(load_ps("DS-10-5.R")) # Large data sets: Baby Name Popularity Over Time

  # Test cases
  ps_add(load_ps("T00.R")) # Supreme simplicity - helpful for debuggin
  ps_add(load_ps("T01.R")) # Assignment and atomic vectors
  ps_add(load_ps("T02.R")) # Vectors
  ps_add(load_ps("T03.R")) # Functions
  ps_add(load_ps("T04.R")) # Dataframes

  # Problem sets   - Additional examples
  ps_add(load_ps("P01.R"))
  ps_add(load_ps("P02.R"))

  # Basic illustrative example (used in documentation)
  ps_add(load_ps("PS_Example.R"))

  ps_set_current(1)
  clear_viewer_pane()
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

# Get the practice set initial variables
ps_get_env_vars <- function(short = "") {
  if (short == "") {
    ps <- ps_get_current()
  } else {
    ps <- ps_get_by_short(short)
  }
  return(ps$ps_initial_vars)
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



# Expression evaluation ----
#----------------------------------------------------------------------------#
# Functions for evaluating and formatting expressions
#----------------------------------------------------------------------------#
# This function returns a list information about the variables that have
# been initialized in one of two environments (global or expected)
get_all_var_info <- function(envir_id) {
  env_name <- .GlobalEnv
  if (envir_id == 2) {
    env_name <- pkg.expected_env
  }

  all <- ls(envir = env_name)

  var_info <- list()

  for (k in 1:length(all)) {
    var <- all[k]
    val <- get(var, envir = env_name)
    t <- typeof(val)
    s <- format_variable(val)

    new_info <- list(info = list(vname = var, vval = val, vtype = t, vstr = s))
    var_info <- append(var_info, new_info)
  }
  return(var_info)
}

# This function returns runs a block of code in one of either two
# environments. It returns the results as a list of variables and
# basic information for each variable
eval_code <- function(code, envir_id = 1, clear_first = TRUE) {
  env_name <- .GlobalEnv
  if (envir_id == 2) {
    env_name <- pkg.expected_env
  }

  all <- ls(envir = env_name)
  rm(list = all, envir = env_name)

  tryCatch(
    expr = {
      val <- eval(parse(text = code), envir = env_name)
      return(get_all_var_info(envir_id))
    }, error = function(e) {
      return(NULL)
    }
  )
}

get_var_info <- function(var, envir_id = 1) {
  env_name <- .GlobalEnv
  if (envir_id == 2) {
    env_name <- pkg.expected_env
  }
  new_info <- NULL
  if (exists(var, envir = env_name)) {
    val <- get(var, envir = env_name)
    t <- typeof(val)
    s <- format_variable(val)
    new_info <- list(info = list(vname = var, vval = val, vtype = t, vstr = s))
  }
  return(new_info)
}

## Wrapper functions ----
# Wrapper functions for accessing the global (learner) and
# expected environments.
eval_code_global <- function(code, clear_first = TRUE) {
  return(eval_code(code, 1, clear_first))
}
eval_code_expected <- function(code, clear_first = TRUE) {
  return(eval_code(code, 2, clear_first))
}

get_global_var_info <- function(var) {
  return(get_var_info(var, 1))
}
get_expected_var_info <- function(var) {
  return(get_var_info(var, 2))
}

get_all_global_var_info <- function() {
  return(get_var_info(1))
}
get__all_expected_var_info <- function() {
  return(get_var_info(2))
}

## Misc eval functions ----
# Evaluates a block of code and returns some details about the result
eval_string_details <- function(code, run_envir = NULL) {
  if (is.null(run_envir)) {
    run_envir <- .GlobalEnv
  }

  tryCatch(
    expr = {
      val <- eval(parse(text = code), envir = run_envir)
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

  if (result$ok == FALSE) {
    message("\nERROR: eval_string_and_format:\n", result$error)
    e <- str_replace_all(result$error[1], "\n", " ")
    t <- paste0("Error: ", e)
    return(t)
  } else {
    return(format_variable(result$value))
  }
}

format_variable <- function(var_to_format) {
  var_type <- typeof(var_to_format)
  if (is.data.frame(var_to_format)) {
    var_type <- "dataframe"
  }

  # Check for basic type
  if (var_type %in% c("double", "integer", "real", "logical", "complex", "character")) {

    # Atomic types
    if (length(var_to_format) == 1) {
      return(paste0("atomic [1]: ", as.character(var_to_format)))

      # Vector type
    } else {
      len <- length(var_to_format)
      t <- paste0(var_to_format, collapse = " ")
      if (len > 20) {
        t <- paste0(str_sub(t, 1, 20), " ...", sep = "")
      }
      return(paste0("vector [", len, "]: ", t))
    }

    # Check for a function
  } else if (var_type == "closure") {
    args <- names(formals(var_to_format))
    t <- paste0(args, collapse = ", ")
    t <- paste0("function(", t, ") {...}")
    return(paste0("funct: ", t))

    # Check for dataframe
  } else if (var_type == "dataframe") {
    nr <- nrow(var_to_format)
    nc <- ncol(var_to_format)

    df_info_rows <- "0 rows"
    df_info_cols <- "0 columns"
    if (nr == 1) df_info_rows <- "1 row" else df_info_rows <- paste0(nr, " rows")
    if (nc == 1) df_info_cols <- "1 column" else df_info_cols <- paste0(nc, " columns")

    return(paste0("dataframe: [", df_info_rows, " x ", df_info_cols, "]"))

    # List type
  } else if (var_type == "list") {
    len <- length(var_to_format)
    return(paste0("list: [", len, "]"))

    # A type that is not handled
  } else {
    message("\nType unhandled:", var_type, "\n")
    return(paste0("Type unhandled: ", var_type))
  }
}

# Check that two functions have the same number of arguments. If
# not, return -1. Otherwise, return the number of arguments.
signature_ok <- function(check_function, expected_function) {
  check_formals <- names(formals(check_function))
  expected_formals <- names(formals(expected_function))

  # Check that the function signatures have the same number of
  # arguments
  signature_ok <- TRUE
  if (is.null(check_formals) && !is.null(expected_formals)) {
    signature_ok <- FALSE
  }
  if (signature_ok) {
    if (length(check_formals) != length(expected_formals)) {
      signature_ok <- FALSE
    }
  }

  num_args <- -1
  if (signature_ok) {
    num_args <- length(check_formals)
  }

  return(num_args)
}


# This function formats a code block
# TODO: Make improvements
format_code <- function(code_text, indent = cTAB_IN_SPACES) {
  t <- styler::style_text(code_text)
  t <- paste0(indent, t)
  t <- paste0(t, collapse = "\n")
  return(t)
}

# This function for an expected answer to a problem set
# Note: id is the "internal id" (not the prompt id)
expected_answer <- function(id) {
  code <- ps_get_expected_answer(id)
  return(eval_string_and_format(code))
}

# Code checking ----
#----------------------------------------------------------------------------#
# Functions related to the callback functions for checking learner's work
#----------------------------------------------------------------------------#
DEFAULT_Check <- function(var_name, result) {
  cDEBUG <- TRUE

  internal_id <- ps_var_name_to_id(var_name)
  learner_r <- get_global_var_info(var_name)
  expected_r <- get_expected_var_info(var_name)

  # This should never happen. The variable, var_name, should lead to
  # results in both the learner and expected environments.
  if (is.null(learner_r) || is.null(expected_r)) {
    t <- ""
    if (is.null(Li)) {
      t <- paste0(t, "[learner variable is null]")
    }
    if (is.null(Ei)) {
      t <- paste0(t, "[expected variable is null]")
    }
    t <- result_prompt_error(internal_id, paste0("Check: Internal error: ", t))
    result <- result_update(result, internal_id, FALSE, t)
    stop(paste0("Check: Internal error:", t))
    return(result)
  }

  Li <- learner_r$info
  Ei <- expected_r$info

  if (cDEBUG) {
    ps <- ps_get_current()
    cat("--- DEFAULT_Check\n")
    cat(paste0("ps short:       ", ps$ps_short), "\n")
    cat(paste0("var name:       ", var_name), "\n")
    cat(paste0("internal id:    ", internal_id), "\n")
    cat(paste0("prompt id:      ", ps_get_prompt_id(internal_id)), "\n")
    cat("---\n")

    cat("...---...\n")
    print(Li)
    cat("...---...\n")
    print(Ei)

    cat(sprintf("Learner: %-20s %-10s %-60s\n", Li$vname, Li$vtype, Li$vstr))
    cat(sprintf("Expected: %-20s %-10s %-60s\n", Ei$vname, Ei$vtype, Ei$vstr))
    print("...---...\n")
  }

  if (Li$vtype %in% c("double", "integer", "real", "logical", "complex", "character")) {

    # Atomic values
    if (length(Li$vval) == 1) {
      if (cDEBUG) {
        cat(">> Atomic\n")
      }

      # Check for a regular expression
      re <- ps_get_re_checks(internal_id)
      good <- FALSE
      if (re != "") {
        good <- str_detect(Li$vval, re)
      } else {
        good <- identical(Li$vval, Ei$vval, ignore.environment = TRUE)
      }

      if (good == TRUE) {
        result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
      } else {
        result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
      }

      # Vector values
    } else {
      if (cDEBUG) {
        cat(">> Vector\n")
      }

      if (identical(Li$vval, Ei$vval, ignore.environment = TRUE) == TRUE) {
        result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
      } else {
        result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
      }
    }

    # Check for dataframe
  } else if (Li$vtype == "dataframe") {
    if (cDEBUG) {
      cat(">> Dataframe\n")
    }
    if (identical(Li$vval, Ei$vval, ignore.environment = TRUE) == TRUE) {
      result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
    } else {
      result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
    }

    # list
  } else if (Li$vtype == "list") {
    if (cDEBUG) {
      cat(">> List\n")
    }
    if (identical(Li$vval, Ei$vval, ignore.environment = TRUE) == TRUE) {
      result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
    } else {
      result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
    }

    # Functions
  } else if (Li$vtype == "closure") {
    if (cDEBUG) {
      cat(">> Closure\n")
    }

    num_args <- signature_ok(Li$vval, Ei$vval)

    # If the number of parameters differ from expected - note error message
    if (num_args < 0) {
      t <- result_main_message(result_error_msg(internal_id, TRUE))
      t <- result_sub_message(t, "Check the number of arguments in your function")
      result <- result_update(result, internal_id, FALSE, t)
      return(result)
    }

    # A function with ZERO parameters
    if (num_args == 0) {
      learner_f_answers <- do.call(Li$vname, list())
      expected_f_answers <- do.call(Ei$vname, list())

      if (identical(learner_f_answers, expected_f_answers, ignore.environment = TRUE) == TRUE) {
        result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
      } else {
        result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
      }
      return(result)

      # A function with ONE parameter
    } else if (num_args == 1) {
      learner_answers <- c()
      expected_answers <- c()

      checks <- ps_get_arg1_checks(internal_id)

      for (k in 1:length(checks)) {
        t1 <- do.call(Li$vname, list(checks[k]))
        t2 <- do.call(Ei$vname, list(checks[k]))
        learner_answers <- append(learner_answers, t1)
        expected_answers <- append(expected_answers, t2)
      }

      if (identical(learner_answers, expected_answers, ignore.environment = TRUE) == TRUE) {
        result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
      } else {
        result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
      }
      return(result)

      # A function with TWO parameters
    } else if (num_args == 2) {
      learner_answers <- c()
      expected_answers <- c()

      checks_arg1 <- ps_get_arg1_checks(internal_id)
      checks_arg2 <- ps_get_arg2_checks(internal_id)

      for (j in 1:length(checks_arg1)) {
        for (k in 1:length(checks_arg2)) {
          t1 <- do.call(Li$vname, list(checks_arg1[j], checks_arg2[k]))
          t2 <- do.call(Ei$vname, list(checks_arg1[j], checks_arg2[k]))
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

      # A function with more than TWO parameters
    } else {
      t <- result_prompt_error(internal_id, "Practice Set Error: To many function parameters.")
      result <- result_update(result, internal_id, FALSE, t)
      return(result)
    }

    # Type is not handled
  } else {
    if (cDEBUG) {
      print(">> Type not handled")
    }
    t <- result_prompt_error(internal_id, "Type not handled.")
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
#     general_msg = <string>,
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
check_answers <- function(learner_code) {
  practice_result <- list(
    user_name = pkg.globals$gUSER_NAME,
    general_msg = "",
    num_correct = 0,
    num_incorrect = 0,
    message_list = list()
  )

  # Evaluate the learner's code and the expected code in two different
  # environments (global and expected)
  learner_vars <- eval_code_global(learner_code)
  if (is.null(learner_vars)) {
    t <- result_prompt_error(-1, "Syntax Error: Check code and try again.")
    practice_result <- result_update(practice_result, -1, FALSE, t)
    return(practice_result)
  }
  expected_vars <- eval_code_expected(ps_get_expected_code())
  if (is.null(expected_vars)) {
    stop("check_answers: expected_vars: Internal Error: Likely R syntax error in expected code.")
  }

  # Parse the learner's code and extract all variables and assignment
  # operators
  tryCatch(
    expr = {
      learner_assign_ops <- ast_get_assignments(parse(text = learner_code))
    },
    error = function(e) {
      # This error should not happen -- since, the code has been evaluated above to get
      # the learner variables
      t <- result_prompt_error(-1, "Likely a Syntax Error: Check code and try again.")
      practice_result <- result_update(practice_result, -1, FALSE, t)
      return(practice_result)
    }
  )

  # Get the learner's variables and code - NOTE: Why flatten here?
  for (k in 1:length(learner_assign_ops)) {
    t <- learner_assign_ops[[k]]
    flatten <- paste0(t$rhs, collapse = "\n")
    ps_update_learner_answer(t$lhs, paste0(t$lhs, "<-", flatten))
  }

  # Get all of the variable names that need to be checked for correctness
  # var_names <- ps_get_live_var_names()
  var_names <- ps_get_all_assignment_vars()

  # No variables initialized - so we are done
  if (length(var_names) == 0) {
    return(practice_result)
  }

  # Call each of the functions that checks if the correct value has been computed.
  for (k in 1:length(var_names)) {
    var <- var_names[k]
    if (!is.null(get_global_var_info(var))) {
      if (is_callback_loaded(var)) {
        practice_result <- do.call(get_callback_name(var), list(var, practice_result))
      } else {
        practice_result <- DEFAULT_Check(var, practice_result)
      }
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
  t <- ps_get_short()
  t <- str_replace_all(t, "-", "_")
  t <- paste0(var_name, ".", t, "_Check")
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

# UI ----

# This function clears the viewer pane
clear_viewer_pane <- function() {
  dir <- tempfile()
  dir.create(dir)
  TextFile <- file.path(dir, "blank.html")
  writeLines("", con = TextFile)
  rstudioapi::viewer(TextFile)
}

# This function gives access to the learner's code in RStudio
check_answers_from_ui <- function() {
  t <- rstudioapi::getSourceEditorContext()
  if (t$path == "") {
    showDialog("Check", "Please save your .R file. It must be saved before checking your practice set.")
    return(NULL)
  } else {
    rstudioapi::documentSave(t$id)
    learner_code <- readLines(rstudioapi::documentPath(t$id))
    return(check_answers(learner_code))
  }
}

# Check sample data ----
#----------------------------------------------------------------------------#
# Functions for accessing information about the practice set
# Note: id is an internal index
#----------------------------------------------------------------------------#

# The a vector that contains values to check a function with
# See @checks tag
ps_get_checks <- function(id) {
  v <- c()
  ps <- ps_get_current()
  checks <- ps$task_list[[id]]$checks_for_f
  if (checks != "") {
    tryCatch(
      expr = {
        v <- eval(parse(text = checks))
      },
      error = function(e) {
        v <- c()
      }
    )
  }
  return(v)
}

# Try to get the Regular Expression for checking
ps_get_re_checks <- function(id) {
  t <- ps_get_checks(id)
  if (length(t) == 1) {
    if (cDEBUG) {
      print(paste0("re: ", t$re))
    }
    if (is.null(t$re)) {
      return("")
    } else {
      return(t$re)
    }
  }
  return("")
}

# Try to get the list of function input tests
ps_get_arg1_checks <- function(id) {
  t <- ps_get_checks(id)
  if (length(t) > 0) {
    if (cDEBUG) {
      print(paste0("f_checks (arg1): ", t$arg1))
    }
    if (is.null(t$arg1)) {
      return(c())
    } else {
      return(t$arg1)
    }
  }
  return(c())
}

# Try to get the list of function input tests
ps_get_arg2_checks <- function(id) {
  t <- ps_get_checks(id)
  if (length(t) == 2) {
    if (cDEBUG) {
      print(paste0("f_checks (arg2): ", t$arg2))
    }
    if (is.null(t$arg2)) {
      return(c())
    } else {
      return(t$arg2)
    }
  }
  return(c())
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

# This function returns all the expected variables - learners write code
# to assign values to these variables
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

# Variable names are mapped to internal ids in the practice sets
ps_var_name_to_id <- function(var_name) {
  if (is.null(var_name)) {
    return(-1)
  }
  if (var_name == "") {
    return(-1)
  }
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
  return(a)
}

ps_get_expected_code <- function() {
  ps <- ps_get_current()
  code <- c()

  for (k in 1:length(ps$ps_initial_vars)) {
    code <- append(code, ps$ps_initial_vars[k])
  }
  for (task in ps$task_list) {
    code <- append(code, task$expected_answer)
  }
  results <- eval_code_expected(t)

  return(code)
}

# Hints -----
#----------------------------------------------------------------------------#
# Functions for handling hints
#----------------------------------------------------------------------------#
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
#----------------------------------------------------------------------------#
# Functions setting and getting learner's answers
#----------------------------------------------------------------------------#
ps_update_learner_answer <- function(var_name, answer) {
  ps_id <- pkg.globals$gPRACTICE_SET_ID
  ps <- pkg.globals$gPRACTICE_SETS[[ps_id]]

  id <- ps_var_name_to_id(var_name)
  if (id > 0) {
    ps$task_list[[id]]$learner_answer <- answer
    pkg.globals$gPRACTICE_SETS[[ps_id]] <- ps
  }

  return(TRUE)
}

ps_get_learner_answer_by_id <- function(id) {
  ps <- ps_get_current()
  t <- ps$task_list[[id]]$learner_answer
  return(t)
}

ps_get_learner_answer <- function(var_name) {
  id <- ps_var_name_to_id(var_name)
  return(ps_get_learner_answer_by_id(id))
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

# This function is used to create a template script - learners can start
# here and write code for each of the prompts
format_practice_script <- function(show_answers = FALSE) {
  ps <- ps_get_current()

  t <- ""
  for (task in ps$task_list) {
    msg <- str_replace_all(task$prompt_msg, "\n", "\n#   ")
    if (task$is_note_msg == TRUE) {
      t <- paste0(t, "# Note: ", msg, "\n\n")
    } else {
      t <- paste0(t, "# ", task$prompt_id, ": ", msg, " (", task$assignment_var, ")", "\n")
    }

    # This will show the answers -- Useful to generating answer files
    if (show_answers == TRUE) {
      s <- paste0(task$expected_answer, collapse = "\n")
      t <- paste0(t, s, "\n\n")
    } else {
      t <- paste0(t, "\n")
    }
  }

  s <- ""

  lines_of_code <- str_trim(paste0(cTAB_IN_SPACES, ps_get_env_vars(), collapse = "\n"))
  t_lines_of_code <- ""
  if (lines_of_code != "") {
    t_lines_of_code <- paste0(
      "# Initial variables\n",
      lines_of_code, "\n\n"
    )
  }

  t <- paste0(
    "# ", ps$ps_short, ": ", ps$ps_title, "\n",
    "#   ", str_replace_all(ps$ps_descr, "\n", "\n#   "), "\n", "",
    s,
    "# ---\n",
    "practice.begin(\"", ps$ps_short, "\", learner=\"[your name]\")\n\n",
    t_lines_of_code,
    t,
    "\n"
  )
  return(t)
}

# Present the prompts in the viewer
# TODO: Consider showing only the prompts that are incorrect
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
  learner <- ps_get_learner_answer_by_id(id)
  # print(learner)
  answer <- expected_answer(id)
  t <- answer
  t <- paste0(
    "<span style='color:green'>&#10004;",
    " ", t, "</span>\n",
    "     <i>Your code</i>:",
    "\n    ", format_code(learner),
    "\n", "     <i>Expected</i>:",
    "\n    ", format_code(expected)
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
  if (id == -1) {
    t <- paste0("General practice set error: ", msg)
  } else {
  t <- paste0("Prompt error: \"", ps_get_prompt(id), "\"\n")
  t <- paste0(t, msg)
}
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
  if (id == -1) {
    result$general_msg <- text
    return (result)
  }

  if (is_correct == TRUE) {
    result$num_correct <- result$num_correct + 1
    result$correct_v <- append(result$correct_v, id)
  } else {
    result$num_incorrect <- result$num_incorrect + 1
    result$incorrect_v <- append(result$incorrect_v, id)
  }

  result$message_list <- append(
    result$message_list,
    list(message = list(
      internal_id = id,
      prompt_id = ps_get_prompt_id(id),
      correct = is_correct,
      msg_text = text
    ))
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
  t <- paste0(t, "Learner name:\n<i>   ", result$user_name, "</i>")
  t <- paste0(t, "\n")

  if(result$general_msg != "") {
    t <- paste0(t, ">>> Note: ", result$general_msg, "\n\n")
  }

  lines_of_code <- paste0(cTAB_IN_SPACES, ps_get_env_vars(), collapse = "\n")
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

# A special format for instructors and grading
# TODO - Need to process the results and show teach the key info
format_grading <- function(results) {
  t <- format_for_html_file(format_result(results))
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

format_for_html_file <- function(text) {
  t <- "<head></head><body><pre>"
  t <- paste0(t, text)
  t <- paste0(t, "</pre></body>")
  return(t)
}

print_to_viewer <- function(text, fn) {
  dir <- tempfile()
  dir.create(dir)
  html_file <- file.path(dir, paste0(fn, ".html"))

  t <- format_for_html_file(text)

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
