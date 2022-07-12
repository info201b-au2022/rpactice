#----------------------------------------------------------------------------#
# Code for implementing the RStudio Addins
#----------------------------------------------------------------------------#
## Global variables ----
pinfo201.globals <- new.env()
pinfo201.globals$gPRACTICE_SET_ID <- 1

# Two variables for modeling the learner
pinfo201.globals$gLEARNER_NAME <- ""
pinfo201.globals$gLEARNER_EMAIL <- ""

# This environment is used to hold and run the learner's code
cLEARNER_ENV_ID <- 1
pinfo201.learner_env <- new.env()

# This environment is used for the expected code
cEXPECTED_ENV_ID <- 2
pinfo201.expected_env <- new.env()

# This constant is used to map to the .GlobalEnv environment
# .GlobalEnv is the parent of the learner_env and expected_env
cGLOBAL_ENV_ID <- 3

## Constants ----
cDEBUG <- FALSE
cTAB_IN_SPACES <- "   "
cPACKAGE_ENVIR_NAME <- "package:pinfo201"

# Manage Practice Sets ----
#----------------------------------------------------------------------------#
# Functions for setting and accessing practice sets
#----------------------------------------------------------------------------#
# This function is called when the package is loaded. It is used to initialize
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

  ps_add(load_ps("DS-10-1.R")) # Creating data frames
  ps_add(load_ps("DS-10-2.R")) # Working with data frames
  ps_add(load_ps("DS-10-3.R")) # Working with built-in data sets
  ps_add(load_ps("DS-10-4.R")) # External data sets: Gates Foundation Educational Grants
  ps_add(load_ps("DS-10-5.R")) # Large data sets: Baby Name Popularity Over Time

  ps_add(load_ps("DS-11-1.R")) # Working with data frames
  ps_add(load_ps("DS-11-2.R")) # Working with `dplyr`
  ps_add(load_ps("DS-11-3.R")) # Using the pipe operator
  ps_add(load_ps("DS-11-4.R")) # Practicing with dplyr
  ps_add(load_ps("DS-11-5.R")) # dplyr grouped operations
  ps_add(load_ps("DS-11-6.R")) # dplyr join operations
  ps_add(load_ps("DS-11-7.R")) # Using dplyr on external data
  ps_add(load_ps("DS-11-8.R")) # Exploring data sets

  # Test cases
  ps_add(load_ps("T00.R")) # Most simple - helpful for debugging
  ps_add(load_ps("T01.R")) # Assignment
  ps_add(load_ps("T02.R")) # Assignment: Copy variables
  ps_add(load_ps("T03.R")) # Assignment: Structures
  ps_add(load_ps("T04.R")) # Vectors
  ps_add(load_ps("T05.R")) # Functions
  ps_add(load_ps("T06.R")) # Dataframes
  ps_add(load_ps("T07.R")) # Files
  # ps_add(load_ps("T10.R")) # Issues, bugs, etc.

  # Problem sets   - Additional examples
  # ps_add(load_ps("P01.R"))
  # ps_add(load_ps("P02.R"))

  # Basic illustrative example (used in documentation)
  ps_add(load_ps("PS_Example.R"))



  # Set the current practice set to 1
  ps_set_current(1)
}

# Add a practice set into the running application
ps_add <- function(ps) {
  new_k <- length(pinfo201.globals$gPRACTICE_SETS) + 1
  pinfo201.globals$gPRACTICE_SETS[[new_k]] <- ps
}

# Only one practice set is active at a time - A global variable is used
# to keep track of the currently active practice set
ps_set_current <- function(id) {
  if (is.null(pinfo201.globals$gPRACTICE_SETS)) {
    stop("Error: Practice sets are not set.")
  }
  if (id <= 0 || id > length(pinfo201.globals$gPRACTICE_SETS)) {
    stop(paste0("Error: Practice Set ID must be between 1 and ", length(pinfo201.globals$gPRACTICE_SETS), "."))
  }

  pinfo201.globals$gPRACTICE_SET_ID <- as.numeric(id)
}

# Return the currently active practice set
ps_get_current <- function() {
  id <- pinfo201.globals$gPRACTICE_SET_ID
  if (is.null(id) == TRUE || id < 1 || id > length(pinfo201.globals$gPRACTICE_SETS)) {
    stop("Error: Bad gPRACTICE_SET_ID")
  }
  ps <- pinfo201.globals$gPRACTICE_SETS[[id]]

  return(ps)
}

# Return the short ID of the currently active practrice set
ps_get_short <- function() {
  ps <- ps_get_current()
  return(ps$ps_short)
}

# Update the current practice set to a new one
ps_update_current <- function(ps) {
  pinfo201.globals$gPRACTICE_SETS[[pinfo201.globals$gPRACTICE_SET_ID]] <- ps
}

# Get the internal id of a practice set by its short id
# NOTE: Practice sets are assumed to have UNIQUE short ids
ps_get_id_by_short <- function(short_id) {
  k <- 1
  for (ps in pinfo201.globals$gPRACTICE_SETS) {
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
    return(pinfo201.globals$gPRACTICE_SETS[[id]])
  }
}

# Get a vector of all of the practice set short ids
ps_get_all <- function() {
  v <- c()
  for (ps in pinfo201.globals$gPRACTICE_SETS) {
    v <- append(v, ps$ps_short)
  }
  return(v)
}

# Get the practice set initial variables
ps_get_env_vars <- function() {
  ps <- ps_get_current()
  t <- ps$ps_initial_vars
  return(t)
}

# Return a list of practice set titles and ids, suited
# to a Shinny selectInput widget.  The list has this structure:
#    list("P01: <title>" = "P01", "P2: <title>" = "P02")
# where "P01", "P02", and so on are the short ids for the practice sets
ps_ui_get_titles <- function() {
  if (is.null(pinfo201.globals$gPRACTICE_SETS)) {
    stop("practice-info-201.R: Practice sets are not set.")
  }

  items <- c()
  ids <- c()

  for (ps in pinfo201.globals$gPRACTICE_SETS) {
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

get_envir <- function(id) {
  # The learner variable space
  if (id == cLEARNER_ENV_ID) {
    return(pinfo201.learner_env)
  }
  # The expected variable space
  else if (id == cEXPECTED_ENV_ID) {
    return(pinfo201.expected_env)
  }
  # The global variable space (parent for pinfo201.learner_env and pinfo201.expected_env)
  else if (id == cGLOBAL_ENV_ID) {
    return(.GlobalEnv)
  } else {
    stop("Internal error: get_envir(id): Erroneous id")
  }
}


# Remove the variables from all three environments
clear_all_envirs <- function() {
  rm(list = names(get_envir(cLEARNER_ENV_ID)), envir = get_envir(cLEARNER_ENV_ID))
  rm(list = names(get_envir(cEXPECTED_ENV_ID)), envir = get_envir(cEXPECTED_ENV_ID))
  rm(list = names(get_envir(cGLOBAL_ENV_ID)), envir = get_envir(cGLOBAL_ENV_ID))
}

print_all_envirs <- function() {
  t <- names(get_envir(cLEARNER_ENV_ID))
  if (length(t) == 0) {
    cat("learner envir: no variables.\n")
  } else {
    cat("learner envir: ")
    cat(paste0(t), collapse = " - ")
    cat("\n")
  }

  t <- names(get_envir(cEXPECTED_ENV_ID))
  if (length(t) == 0) {
    cat("expected envir: no variables.\n")
  } else {
    cat("expected envir: ")
    cat(paste0(t), collapse = " - ")
    cat("\n")
  }

  t <- names(get_envir(cGLOBAL_ENV_ID))
  if (length(t) == 0) {
    cat(".GlobalEnv envir: no variables.\n")
  } else {
    cat(".GlobalEnv envir: ")
    cat(paste0(t), collapse = " - ")
    cat("\n")
  }
}

# This function returns a list information about the variables that have
# been initialized in one of two environments (global or expected)
get_all_var_info <- function(envir_id) {
  env_name <- get_envir(envir_id)

  var_list <- list()

  e1 <- names(env_name)
  if (length(e1) > 0) {
    for (v in e1) {
      var_list <- append(var_list, get_var_info(v, envir_id))
    }
  }

  e2 <- names(.GlobalEnv)
  if (length(e2) > 0) {
    for (v in e2) {
      var_list <- append(var_list, get_var_info(v, cGLOBAL_ENV_ID))
    }
  }

  return(var_list)
}

# This function runs a block of code in one of either two environments.
# It returns the results as a list of variables and basic information
# for each variable
eval_code <- function(code, envir_id, clear_first = TRUE) {
  env_name <- get_envir(envir_id)

  if (clear_first == TRUE) {
    rm(list = ls(envir = env_name), envir = env_name)
  }

  tryCatch(
    expr = {
      val <- eval(parse(text = code), envir = env_name)
      return(get_all_var_info(envir_id))
    }, error = function(e) {
      message(e)
      return(e)
    }
  )
}

# This function looks for a variable in one of two environments,
# global or expected, and returns basic information about that
# variable.
get_var_info <- function(var, envir_id) {
  env_name <- get_envir(envir_id)

  # Try to find the variable
  val <- NULL
  if (exists(var, envir = env_name)) {
    val <- get(var, envir = env_name)
  } else if (exists(var, envir = .GlobalEnv)) {
    val <- get(var, envir = .GlobalEnv)
  }

  # If the variable was found, return basic information
  if (!is.null(val)) {
    t <- typeof(val)
    if (is.data.frame(val)) {
      t <- "dataframe"
    }
    s <- format_variable(val)
    new_info <- list(info = list(vname = var, vval = val, vtype = t, vstr = s))
    return(new_info)
  } else {
    return(NULL)
  }
}

cp_var_to_envir <- function(var_name, value) {
  pinfo201.expected_env[[var_name]] <- value
}

initialize_static_vars <- function() {
  lines_of_code <- paste0(ps_get_env_vars(), collapse = "\n")
  return(eval_code(lines_of_code, cGLOBAL_ENV_ID, FALSE))
}


## Wrapper functions ----
# Wrapper functions for accessing the global (learner) and
# expected environments.
eval_code_global <- function(code, clear_first = FALSE) {
  return(eval_code(code, cLEARNER_ENV_ID, clear_first))
}
eval_code_expected <- function(code, clear_first = FALSE) {
  return(eval_code(code, cEXPECTED_ENV_ID, clear_first))
}

get_global_var_info <- function(var) {
  return(get_var_info(var, cLEARNER_ENV_ID))
}
get_expected_var_info <- function(var) {
  return(get_var_info(var, cEXPECTED_ENV_ID))
}

get_all_global_var_info <- function() {
  return(get_var_info(cLEARNER_ENV_ID))
}
get__all_expected_var_info <- function() {
  return(get_var_info(cEXPECTED_ENV_ID))
}

## Misc eval functions ----
# Evaluates a block of code and returns some details about the result
eval_string_details <- function(code, run_envir = NULL) {
  if (is.null(run_envir)) {
    # run_envir <- .GlobalEnv
    run_envir <- pinfo201.expected_env
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
  t <- styler::style_text(code_text, base_indention = nchar(indent))
  t <- paste0(t, collapse = "\n")
  return(t)
}

# This function for an expected answer to a problem set
# Note: id is the "internal id" (not the prompt id)
ps_get_expected_answer <- function(id) {
  var <- ps_get_assignment_var(id)
  return(eval_string_and_format(var))
}

# Code checking ----
#----------------------------------------------------------------------------#
# Functions related to the callback functions for checking learner's work
#----------------------------------------------------------------------------#
DEFAULT_Check <- function(var_name, result) {
  cDEBUG <- TRUE

  internal_id <- ps_var_name_to_id(var_name)
  L <- get_global_var_info(var_name)
  X <- get_expected_var_info(var_name)

  # This should never happen. The variable, var_name, should have an
  # internal id; if not, something is truly messed up.
  if (internal_id == -1 || internal_id == 0) {
    t <- result_prompt_error(internal_id, paste0("DEFAULT_Check: Internal error: internal_id: ", internal_id))
    result <- result_update(result, -1, FALSE, t)
    stop(t)
    # return(result)
  }

  # This should never happen. The variable, var_name, should lead to
  # results in both the learner and expected environments.
  if (is.null(L) || is.null(X)) {
    t <- ""
    if (is.null(L)) {
      t <- paste0(t, "[learner variable is null]")
    }
    if (is.null(X)) {
      t <- paste0(t, "[expected variable is null]")
    }
    t <- result_prompt_error(internal_id, paste0("Check: Internal error: ", t, sep = ""))
    result <- result_update(result, -1, FALSE, t)
    stop(paste0("Check: Internal error:", t))
    # return(result)
  }

  if (cDEBUG) {
    ps <- ps_get_current()
    cat("--- DEFAULT_Check\n")
    cat(paste0("ps short:       ", ps$ps_short), "\n")
    cat(paste0("var name:       ", var_name), "\n")
    cat(paste0("internal id:    ", internal_id), "\n")
    cat(paste0("prompt id:      ", ps_get_prompt_id(internal_id)), "\n")
    cat("---\n")

    cat("...---...\n")
    print(L$info)
    cat("...---...\n")
    print(X$info)

    cat(sprintf("Learner: %-20s %-10s %-60s\n", L$info$vname, L$info$vtype, L$info$vstr))
    cat(sprintf("Expected: %-20s %-10s %-60s\n", X$info$vname, X$info$vtype, X$info$vstr))
    print("...---...\n")
  }

  if (L$info$vtype %in% c("double", "integer", "real", "logical", "complex", "character")) {

    # Atomic values
    if (length(L$info$vval) == 1) {
      if (cDEBUG) {
        cat(">> Atomic\n")
      }

      # Check for a regular expression
      re <- ps_get_re_checks(internal_id)
      good <- FALSE
      if (re != "") {
        good <- str_detect(L$info$vval, re)
      } else {
        good <- identical(L$info$vval, X$info$vval, ignore.environment = TRUE)
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

      if (identical(L$info$vval, X$info$vval, ignore.environment = TRUE) == TRUE) {
        result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
      } else {
        result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
      }
    }

    # Check for dataframe
  } else if (L$info$vtype == "dataframe") {
    if (cDEBUG) {
      cat(">> Dataframe\n")
    }
    if (identical(L$info$vval, X$info$vval, ignore.environment = TRUE) == TRUE) {
      result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
    } else {
      result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
    }

    # list
  } else if (L$info$vtype == "list") {
    if (cDEBUG) {
      cat(">> List\n")
    }
    if (identical(L$info$vval, X$info$vval, ignore.environment = TRUE) == TRUE) {
      result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
    } else {
      result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
    }

    # Functions
  } else if (L$info$vtype == "closure") {
    if (cDEBUG) {
      cat(">> Closure\n")
    }

    num_args <- signature_ok(L$info$vval, X$info$vval)

    # If the number of parameters differ from expected - note error message
    if (num_args < 0) {
      t <- result_main_message(result_error_msg(internal_id, TRUE))
      t <- result_sub_message(t, "Check the number of arguments in your function")
      result <- result_update(result, internal_id, FALSE, t)
      return(result)
    }

    # A function with ZERO parameters
    if (num_args == 0) {
      learner_f_answers <- do.call(L$info$vname, list(), envir = get_envir(1))
      expected_f_answers <- do.call(X$info$vname, list(), envir = get_envir(2))

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
      if (length(checks) == 0) {
        t <- result_prompt_error(internal_id, paste0("DEFAULT_Check: One paramter function: Missing checks: ", internal_id))
        result <- result_update(result, -1, FALSE, t)
        return(result)
      }

      for (k in 1:length(checks)) {
        t1 <- do.call(L$info$vname, list(checks[k]), envir = get_envir(1))
        t2 <- do.call(X$info$vname, list(checks[k]), envir = get_envir(2))
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
      if (length(checks_arg1) == 0) {
        t <- result_prompt_error(internal_id, paste0("DEFAULT_Check: Two paramter function: Missing checks: ", internal_id))
        result <- result_update(result, -1, FALSE, t)
        return(result)
      }

      checks_arg2 <- ps_get_arg2_checks(internal_id)
      if (length(checks_arg2) == 0) {
        t <- result_prompt_error(internal_id, paste0("DEFAULT_Check: Two paramter function: Missing checks: ", internal_id))
        result <- result_update(result, -1, FALSE, t)
        return(result)
      }

      for (j in 1:length(checks_arg1)) {
        for (k in 1:length(checks_arg2)) {
          t1 <- do.call(L$info$vname, list(checks_arg1[j], checks_arg2[k]), envir = get_envir(1))
          t2 <- do.call(X$info$vname, list(checks_arg1[j], checks_arg2[k]), envir = get_envir(2))
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
#        learner_name = "",
#        learner_email = "",
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
check_answers <- function(learner_code, clear_all = TRUE) {

  practice_result <- list(
    learner_name = "",
    learner_email = "",
    general_msg = "",
    num_correct = 0,
    num_incorrect = 0,
    correct_v = c(),
    incorrect_v = c(),
    message_list = list()
  )

  # Step 1
  # Clear all pre-set variables. When grading a set of assignments
  # it will likely be substantially more efficient to not clear the
  # variables.
  if (clear_all == TRUE) {
    clear_all_envirs()
  }

  # Step 2
  # Try to parse the learners code. If there is an error return
  # immediately with a reasonable error message.
  tryCatch(
    expr = {
      learner_expression <- parse(text=learner_code)
    },
    error = function(e) {
      t <- result_prompt_error(-1, "Likely a Syntax Error: Run and test code. Try again.")
      practice_result <- result_update(practice_result, -1, FALSE, t)
      return(practice_result)
    }
  )

  # Step 3
  # Find the practice.begin() function and evaluate it. practice.begin() sets the
  # practice set ID  and basic learner information (name and email), currently
  # represented awkwardly as global variables.
  # Step 3a - get the practice.begin() statement from the student's code
  begin_expr <- ast_get_begin2(learner_expression)
  if (is.null(begin_expr)) {
    t <- result_prompt_error(-1, "The practice set must have a begin statement.")
    practice_result <- result_update(practice_result, -1, FALSE, t)
    return(practice_result)
  }

  # Step 3b - evaluate practice.begin()
  tryCatch(
    expr = {
       eval(begin_expr)
       practice_result$learner_name <- pinfo201.globals$gLEARNER_NAME
       practice_result$learner_email <- pinfo201.globals$gLEARNER_EMAIL
    },
    error = function(e) {
      t <- result_prompt_error(-1, "practice.begin() failed.")
      practice_result <- result_update(practice_result, -1, FALSE, t)
      return(practice_result)
    }
  )

  # STEP 4
  # Inspect the practice set, and initialize the pre-set variables
  initialize_static_vars()

  print_all_envirs()
  cat("Step 0 done.\n")

  # STEP 4
  # Evaluate the learner's code and the expected code in two different
  # environments (learner and expected environments)
  # TODO: Deal with errors ...
  learner_vars <- eval_code_global(learner_code)
  if (is.null(learner_vars)) {
    t <- result_prompt_error(-1, "Syntax Error: Check code and try again.")
    practice_result <- result_update(practice_result, -1, FALSE, t)
    return(practice_result)
  }

  # Step 4a
  # If the learner has done nothing (no learner variables), we are done
  if (length(learner_vars) == 0) {
    t <- result_prompt_error(-1, "Currently nothing to evaluate!")
    practice_result <- result_update(practice_result, -1, FALSE, t)
    return(practice_result)
  }

  # STEP 5
  # Are there variables in the the learners environment that need to be
  # copied into the expected environment?  If so, copy those variables.
  cp_vars <- ps_get_all_cp_vars()
  for (v in cp_vars) {
    cp_var_to_envir(v, get(v, envir = pinfo201.learner_env))
  }

  # STEP 6
  # Evaluate the expected code.
  expected_vars <- eval_code_expected(ps_get_all_expected_code(), FALSE)
  if (is.null(expected_vars)) {
    stop("check_answers: expected_vars: Internal Error: Likely R syntax error in expected code.")
  }

  print_all_envirs()
  cat("Step 2 done.")

  # STEP 7
  # Parse the learner's code and extract all variables and assignment
  # operators. Update the practice set with this code.
  tryCatch(
    expr = {
      learner_assign_ops <- ast_get_assignments(learner_expression)
    },
    error = function(e) {
      # This error should not happen -- since, the code has been evaluated above to get
      # the learner variables
      t <- result_prompt_error(-1, "Likely a Syntax Error: Check code and try again.")
      practice_result <- result_update(practice_result, -1, FALSE, t)
      return(practice_result)
    }
  )

  # Step 8
  # Get the learner's variables and code - NOTE: Why flatten here?
  for (k in 1:length(learner_assign_ops)) {
    t <- learner_assign_ops[[k]]
    flatten <- paste0(t$rhs, collapse = "\n")
    ps_update_learner_answer(t$lhs, paste0(t$lhs, "<-", flatten))
  }

  # STEP 5
  # Get all of the variable names that need to be checked for correctness.
  # Check if the equivalent variables hold the same values in the Learner
  # and Expected environments.
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

ps_get_prompt_id_list <- function(v) {
  l <- c()
  if (!is.null(v) && length(v) > 0) {
    for (k in 1:length(v)) {
      prompt_id <- ps_get_prompt_id(v[k])
      # cat(k, "\t", v[k], "\t", prompt_id, "\n")
      l <- append(l, prompt_id)
    }
  }
  return(l)
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

ps_get_all_cp_vars <- function(flag = TRUE) {
  ps <- ps_get_current()
  vars <- c()
  for (t in ps$task_list) {
    if (t$copy_var == flag) {
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
  ps <- ps_get_current()
  if (!is.null(var_name) && var_name != "" && length(ps$task_list) > 0) {
    for (k in 1:length(ps$task_list)) {
      if (ps$task_list[[k]]$assignment_var == var_name) {
        return(k)
      }
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

ps_get_expected_code <- function(id) {
  ps <- ps_get_current()
  if (id < 1 || id > length(ps$task_list)) {
    stop(paste0("id is out of bounds (id=", id, ")"))
  }
  a <- ps$task_list[[id]]$expected_answer
  return(a)
}

ps_get_all_expected_code <- function() {
  ps <- ps_get_current()
  code <- c()
  # if (length(ps$ps_initial_vars) > 0) {
  #   for (k in 1:length(ps$ps_initial_vars)) {
  #     code <- append(code, ps$ps_initial_vars[k])
  #   }
  # }
  if (length(ps$task_list) > 0) {
    for (task in ps$task_list) {
      if (task$copy_var == FALSE) {
        code <- append(code, task$expected_answer)
      }
    }
  }
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
  ps_id <- pinfo201.globals$gPRACTICE_SET_ID
  ps <- pinfo201.globals$gPRACTICE_SETS[[ps_id]]

  id <- ps_var_name_to_id(var_name)
  if (id > 0) {
    ps$task_list[[id]]$learner_answer <- answer
    pinfo201.globals$gPRACTICE_SETS[[ps_id]] <- ps
  }

  return(TRUE)
}

ps_get_learner_code <- function(id) {
  ps <- ps_get_current()
  t <- ps$task_list[[id]]$learner_answer
  return(t)
}

ps_get_learner_answer <- function(var_name) {
  id <- ps_var_name_to_id(var_name)
  return(ps_get_learner_code(id))
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

all_prompt_ids <- function() {
  ps <- ps_get_current()
  l <- c()
  if (length(ps$task_list) > 0) {
    for (k in 1:length(ps$task_list)) {
      if (ps$task_list[[k]]$is_note_msg == FALSE) {
        l <- append(l, k)
      }
    }
  }
  return(l)
}

# This function is used to create a template script - learners can start
# here and write code for each of the prompts
format_practice_script <- function(show_answers = TRUE) {
  ps <- ps_get_current()

  # Count the number of prompts and create the `num_pompts_msg`, which is
  # presented below.
  note_msg_num <- 0
  for (task in ps$task_list) {
    if (task$is_note_msg == TRUE) {
      note_msg_num <- note_msg_num + 1
    }
  }
  num_prompts <- length(ps$task_list) - note_msg_num
  num_prompts_msg <- ""
  if (num_prompts > 0 && num_prompts < 27) {
    letter <- str_sub("abcdefghijklmnopqrstuvwxyz", num_prompts, num_prompts)
    num_prompts_msg <- sprintf("Your %d prompts: (a)-(%s)", num_prompts, letter)
  } else {
    num_prompts_msg <- sprintf("Your %d prompts", num_prompts)
  }

  # Loop through each of the prompts in the task_list
  note_msg_num <- 1
  t <- ""
  for (task in ps$task_list) {

    # Output a prompt - either message prompt or a real prompt
    msg <- ""
    if (task$is_note_msg == TRUE) {
      snum <- sprintf("%02d", note_msg_num)
      msg <- str_replace_all(task$prompt_msg, "\n", "\n#   ")
      t <- paste0(t, "#                                         Note ", snum, ".\n#    ", msg, "\n")
      note_msg_num <- note_msg_num + 1
    } else {
      msg <- str_replace_all(task$prompt_msg, "\n", "\n#   ")
      t <- paste0(t, "# ", task$prompt_id, ": ", msg, " (Variable: ", task$assignment_var, ")", "\n")
    }

    # NOTE: This will show the expected answers, which is very useful for
    # checking and debugging the practice set files.
    if (show_answers == TRUE) {
      s <- paste0(task$expected_answer, collapse = "\n")
      t <- paste0(t, s, "\n\n")
    } else {
      t <- paste0(t, "\n")
    }
  }

  # The initial variables that are set at the top of the script.
  lines_of_code <- str_trim(paste0(cTAB_IN_SPACES, ps_get_env_vars(), collapse = "\n#"))
  t_lines_of_code <- ""
  if (lines_of_code != "") {
    t_lines_of_code <- paste0(
      "# Key practice set variables (already initialized) ----\n#", cTAB_IN_SPACES,
      lines_of_code, "\n\n"
    )
  }

  # Put all the bits together
  t <- paste0(
    "# pinfo201 / ", ps$ps_version, "\n",
    "#\n",
    "# ", ps$ps_short, ": ", ps$ps_title, "\n",
    "#   ", str_replace_all(ps$ps_descr, "\n", "\n#   "), "\n", "",

    # Basic practice set information
    "\n# Practice set info ---- \n",
    "practice.begin(\"", ps$ps_short,
    "\", learner=\"[your name]\"",
    ", email=\"[your e-mail]\")",
    "\n\n",

    # Initial lines of code
    t_lines_of_code,

    # The prompts come here
    "# ", num_prompts_msg, " ----\n\n",
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

  # Loop through each of the prompts in the task_list
  note_msg_num <- 1
  t <- ""
  for (task in ps$task_list) {

    # Output a prompt - either message prompt or a real prompt
    msg <- ""
    if (task$is_note_msg == TRUE) {
      msg <- task$prompt_msg
      snum <- sprintf("%02d", note_msg_num)
      t <- paste0(t, '<p style="text-align:center;"><b>Note ', snum, "</b></p>")
      t <- paste0(t, "<pre>", msg, "</pre>")

      note_msg_num <- note_msg_num + 1
    } else {
      msg <- task$prompt_msg
      t <- paste0(t, "<pre><b>", task$prompt_id, "</b>: ", msg, " (Variable: ", task$assignment_var, ")", "</pre>")
    }
  }

  t_out <- t

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
    "<b>", ps$ps_short, ": Prompts: ", ps$ps_title, "</b>\n",
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
format_answers2 <- function() {
  pg <- answer_page()

  ps <- ps_get_current()
  t1 <- paste0(ps$ps_short, ": ", ps$ps_title, ": Answers")

  pg <- str_replace(pg, "--PS-TITLE--", t1)
  pg <- str_replace(pg, "--PS-DESCR--", ps$ps_descr)

  t <- ""
  id <- 0
  msg_id <- 1

  chunk1 <-
    ' <button class="collapsible">--PS-PROMPT--</button>
  <div class="content">
  <pre>
   --PS-CODE--
  </pre>
  </div>
'
  answer_html <- ""

  for (task in ps$task_list) {
    if (task$is_note_msg == TRUE) {
      if (length(task$expected_answer) != 0) {
        t1 <- paste0("Note ", msg_id, ": Expected code")
        t2 <- paste0(str_trim(format_code(task$expected_answer)))
      }
      msg_id <- msg_id + 1
    } else {
      t1 <- paste0("", task$prompt_id, ": Expected code")
      t2 <- paste0("", str_trim(format_code(task$expected_answer)))
    }

    t <- str_replace(chunk1, "--PS-PROMPT--", t1)
    t <- str_replace(t, "--PS-CODE--", t2)

    answer_html <- paste0(answer_html, t)
  }

  pg <- str_replace(pg, "--PS-ANSWERS--", answer_html)

  return(pg)
}

format_answers <- function() {
  ps <- ps_get_current()
  short <- ps$ps_short

  t <- paste0("<b>", ps$ps_short, ": Answers: ", ps$ps_title, "</b>\n")
  id <- 0
  msg_id <- 1

  for (task in ps$task_list) {
    if (task$is_note_msg == TRUE) {
      if (length(task$expected_answer) != 0) {
        t <- paste0(t, "<b>Note ", sprintf("%02d", msg_id), "</b>: Expected code\n")
        t <- paste0(t, format_code(task$expected_answer), "\n\n")
      }
      msg_id <- msg_id + 1
    } else {
      t <- paste0(t, "<b>", task$prompt_id, "</b>: Expected code\n")
      t <- paste0(t, "", format_code(task$expected_answer))
      t <- paste0(t, "\n\n")
    }
  }
  return(t)
}


# Formatting results ----
#----------------------------------------------------------------------------#
# Functions for formatting and outputting feedback on practice sets
#----------------------------------------------------------------------------#
result_good_msg <- function(id) {
  expected_code <- ps_get_expected_code(id)
  answer <- ps_get_expected_answer(id)
  t <- paste0(
    "<span style='color:green'>&#10004;",
    " ", answer, "</span>\n",
#    "   > ", format_code(expected_code)
     "", format_code(expected_code), "\n"
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
    t <- paste0("", msg)
  } else {
    t <- paste0(" Prompt error: \"", ps_get_prompt(id), "\"\n")
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
  # A non-specific error because id is -1
  if (id == -1) {
    result$general_msg <- text
    return(result)
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

# Randomly chose a smilely face
get_smilely_face <- function() {
  faces <- c(
    128512,
    127752,
    128570,
    128175,
    128522
  )
  num <- round(stats::runif(1, 1, length(faces)), 0)
  return(sprintf("&#%d;", faces[num]))
}

# Randomly chose an adage
get_adage <- function() {
  adage <- c(
    "Review your code. Double check. Do you understand each step?",
    "Repeating practice sets is a good way to learn!",
    "To learn, you can write your own prompts and test your understandng!",
    "Do you understand each step? Explaining your code to others is a good way to learn.",
    "Working on practice sets are like baking a cake. It takes practice.",
    "Does the code work, but is confusing. Ask a friend to clarify.",
    "Working on practice sets are like fixing a car or bike. It takes practice.",
    "Coding by thoughtful trial and error is a good way to learn."
  )
  num <- round(stats::runif(1, 1, length(adage)), 0)
  return(sprintf("%s", adage[num]))
}

# This function formats a result set
format_result <- function(result) {
  total <- number_of_prompts()
  num_attempted <- result$num_correct + result$num_incorrect
  num_correct <- result$num_correct

  ps <- ps_get_current()

  t <- ""
  t <- paste0(t, "<b>", ps$ps_short, ": ", ps$ps_title, "</b>\n")
  t <- paste0(t, "<i>", date(), "</i>\n")
  if (result$learner_name != "") {
    t <- paste0(t, "", result$learner_name, "</i> (", result$learner_email, ")\n")
    t <- paste0(t, "\n")
  } else {
    t <- paste0(t, "Learner name: ", "None.")
    t <- paste0(t, "\n")
  }

  # General syntax error - likely, because of a student error
  if (result$general_msg != "") {
    t <- paste0(t, "\n>>> Note: ", result$general_msg, "\n\n")
    return(t)
  }

  # Show the results
  t <- paste0(t, "Checking your code:\n   ", num_correct, "/", total, " complete.")
  if (total == num_correct) {
    # All prompts are correct !!
    t <- paste0(t, " Good work! ", get_smilely_face(), "\n")

    # A (fun) adage - intended to be motivating
    t <- paste0(t, "   ", "<font color='purple'>\"", get_adage(), "\"</font>")

    t <- paste0(t, "\n<p style='text-align:center;'><b> Summary:</b></p>")

    for (m in result$message_list) {
      t <- paste0(t, m$prompt_id, ": ", m$msg_text, "\n")
    }

    # Show code that was expected in a complete and compact form
    t <- paste0(t, "\n<p style='text-align:center;'><b> Expected code:</b></p>")

    # The global variables
    theGlobalVars <- ps_get_env_vars()
    if (length(theGlobalVars) > 0) {
      t <- paste0(t, "# Preset variables:\n")
      t <- paste0(t, paste0(theGlobalVars, collapse = "\n"))
    } else {
      t <- paste0(t, "# Preset variables:\n")
      t <- paste0(t, "# None.\n")
    }

    # The code
    theCode <- ps_get_all_expected_code()
    if (length(theCode) > 0) {
      t <- paste0(t, "\n\n# The code:\n")
      for (k in 1:length(theCode)) {
        t <- paste0(t, "", paste0(theCode[k], collpase = "\n"))
      }
    } else {
      t <- paste0(t, "\n\n# The code:\n")
      t <- paste0(t, "#    None.\n\n")
    }
  } else {
    # Errors are present
    t <- paste0(t, " More work to do.\n\nYour progress:\n")

    for (m in result$message_list) {
      t <- paste0(t, "", m$prompt_id, ": ", m$msg_text, "\n")
    }

    all <- all_prompt_ids()
    attempted <- c(result$correct_v, result$incorrect_v)
    still_to_do <- all[!(all %in% attempted)]

    # cat("\nall>         ", all, "\t", is.null(all), "\n")
    # cat("correct_v    ", result$correct_v, "\t", is.null(result$correct_v), "\n")
    # cat("incorrect_v  ", result$incorrect_v, "\t", is.null(result$incorrect_v), "\n")
    # cat("attempted    ", attempted, "\t", is.null(attempted), "\n")
    # cat("still_to_do  ", still_to_do, "\t", is.null(still_to_do), "\n")

    correct_list <- paste0(ps_get_prompt_id_list(result$correct_v), collapse = " ")
    incorrect_list <- paste0(ps_get_prompt_id_list(result$incorrect_v), collapse = " ")
    still_to_do_list <- paste0(ps_get_prompt_id_list(still_to_do), collapse = " ")

    t <- paste0(t, "\nSummary:")
    if (correct_list != "") {
      t <- paste0(t, "\n   <span style='color:green'>&#10004; Correct: ", correct_list, "</span>")
    }
    if (incorrect_list != "") {
      t <- paste0(t, "\n   Try again: ", incorrect_list)
    }
    if (still_to_do_list != "") {
      t <- paste0(t, "\n   Still to do: ", still_to_do_list)
    }
  }
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
