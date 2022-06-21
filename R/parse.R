#----------------------------------------------------------------------------#
# These functions are used to read and process practice set input files
#----------------------------------------------------------------------------#

# Create practice set from a coded text file
create_ps_from_url <- function(url) {
   if (RCurl::url.exists(url) == FALSE) {
    stop(paste0("create_ps_from_url: URL file does not exist\n", url))
   }

  ps <- read_ps_doc(url)
  if (is.null(ps)) {
    stop(paste0("create_ps: Practice set not created\n", url))
  }

  ps <- check_ps(ps)
  return(ps)
}

#----------------------------------------------------------------------------#
# This function loads practice sets that are "internal" to the package. The
# practice sets are found in the special directory inst/extdata.
# The calling order for this function is as follows:
#   .onLoad() - a hook function which runs when the package is loaded
#      ps_load_internal_ps() - for loading all internal practice sets
#        load_ps() - for loading a specific practice set
#
# NOTE: system.file is the preferred way to do this, so that the files
#       are available in the package and while developing the package
#----------------------------------------------------------------------------#
load_ps <- function(fn) {
  filename <- system.file("extdata", fn, package = "pinfo201", mustWork = TRUE)
  ps <- read_ps_doc(filename)
  ps <- check_ps(ps)
  return(ps)
}

read_ps_doc <- function(filename) {
  t <- readLines(filename)
  return(parse_ps(t))
}

# Utilities and helpers ----
#----------------------------------------------------------------------------#
# Utility to remove comment symbols from the front of a line of text
#----------------------------------------------------------------------------#
trim_comment <- function(s) {
  s <- str_trim(str_replace_all(s, "^#'", ""), side = "right")
  return(s)
}

#----------------------------------------------------------------------------#
# Find the variable name on left-hand side of an assignment statement
#----------------------------------------------------------------------------#
get_var_lhs <- function(s) {
  if (str_detect(s, "<-")) {
    p <- str_locate(s, "<-")
    v <- str_trim(str_sub(s, 1, p[1, 1] - 1))
    return(v)
  } else {
    return(NULL)
  }
}

#----------------------------------------------------------------------------#
# Helper function to update the practice set data structure
#----------------------------------------------------------------------------#
update_list <- function(prompts, id, msg, var, code, h) {
  new_prompt <- list(task = list(
    prompt_id = id,
    is_note_msg = FALSE,
    prompt_msg = msg,
    assignment_var = var,
    expected_answer = code,
    learner_answer = NULL,
    hints = h
  ))
  prompts <- append(prompts, new_prompt)
  return(prompts)
}

# Parsing practice sets ----
#----------------------------------------------------------------------------#
# Parse the pactice set document and produce the following structure:
#
# practice_set <- list (
#   ps_version = <string>
#   ps_title = <string>
#   ps_short = <string>
#   ps_descr = <string>
#   ps_initial_vars = c(<string>, <string>, ...)  // lines of code
#   task_list = list (
#     task = list (
#        prompt_id = <string>
#        is_note_msg = <boolean>
#        prompt_msg = <string>
#        assignment_var = <string>
#        expected_answer = c(<string>, <string>, ...) // lines of code
#        learner_answer = NULL
#        hints = c(<string>, <string>, ...)   // list of hints
#     )
#   )
# )
#----------------------------------------------------------------------------#
parse_ps <- function(t) {
  cDEBUG <- FALSE

  if (cDEBUG) {
    print(t)
  }

  ps <- NULL
  ps_version_p <- ""
  ps_title_p <- ""
  ps_short_p <- "_SHORT_"
  ps_descr_p <- ""
  ps_initial_vars_p <- c()

  id <- -1
  msg <- ""
  var <- ""
  code <- c()
  hints <- c()

  prompts <- c()
  first_id <- FALSE
  k <- 1

  while (k <= length(t)) {
    rec <- t[k]
    if (cDEBUG) {
      print(paste0("line: ", k, ": ", t[k]))
    }

    # Syntax clean-up for a common typo, namely "#' #'"
    if (str_detect(t[k], "^#' #'")) {
      replace_t <- str_replace(t[k],"^#' #'", "#'")
      t[k] <- replace_t
    }

    # Found the practice set title
    if (str_detect(t[k], "^#' @title")) {
      ps_title_p <- str_trim(str_sub(t[k], 10, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("ps_title: ", ps_title_p))
      }
    }

    # Found the practice set version
    else if (str_detect(t[k], "^#' @version")) {
      ps_version_p <- str_trim(str_sub(t[k], 12, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("ps_version: ", ps_version_p))
      }
    }

    # Found the practice set short title
    else if (str_detect(t[k], "^#' @short")) {
      ps_short_p <- str_trim(str_sub(t[k], 10, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("ps_short: ", ps_short_p))
      }
    }

    # Found the practice set description, which can be multiple lines
    else if (str_detect(t[k], "^#' @descr")) {
      v <- c()
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^#' @end")) {
          break
        }
        v <- append(v, trim_comment(t[k]))
        k <- k + 1
      }
      ps_descr_p <- paste0(v, collapse = "\n")
      if (cDEBUG) {
        print(ps_descr_p)
      }
    }

    # Found the list of initial variables
    else if (str_detect(t[k], "^#' @initial-vars")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^#' @")) {
          if (str_detect(t[k], "^#' @end")) {
            break
          } else {
            stop("Missing @end")
          }
        }
        # if (str_detect(t[k], "^#' @end")) {
        #   break
        # }
        ps_initial_vars_p <- append(ps_initial_vars_p, t[k])
        k <- k + 1
      }
      if (cDEBUG) {
        print(paste0("ps_initial_vars: ", ps_initial_vars_p, collpase = "\n"))
      }
    }

    # Found a prompt ID
    else if (str_detect(t[k], "^#' @id")) {

      # For the second or more ID update the prompts list structure
      if (first_id == TRUE) {
        prompts <- update_list(prompts, id, msg, var, code, hints)
        id <- ""
        msg <- ""
        var <- ""
        code <- c()
        hints <- c()

        # When we encounter an ID for the first time create the practice set list
      } else {
        first_id <- TRUE
        ps <- list(
          ps_version = ps_version_p,
          ps_title = ps_title_p,
          ps_short = ps_short_p,
          ps_descr = ps_descr_p,
          ps_initial_vars = ps_initial_vars_p,
          task_list = NULL
        )
      }
      id <- str_trim(str_sub(t[k], 7, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("id: ", id))
      }

      # Found the message for this prompt
    } else if (str_detect(t[k], "^#' @msg")) {
      msg <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("msg: ", msg))
      }

      # Found the name of the variable for this prompt
    } else if (str_detect(t[k], "#' @var")) {
      var <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("var: ", var))
      }

      # Found the correct code for this prompt
    } else if (str_detect(t[k], "#' @code")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^#' @end")) {
          break
        }
        code <- append(code, t[k])
        k <- k + 1
      }
      if (cDEBUG) {
        print(paste0("Code: ", code))
      }

      # Found the list of hints for this prompt
    } else if (str_detect(t[k], "#' @hints")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^#' @end")) {
          break
        }
        hints <- append(hints, trim_comment(t[k]))
        k <- k + 1
      }
      if (cDEBUG) {
        print(paste0("hints:", hints))
      }
    }
    k <- k + 1
  }

  if (length(prompts) == 0) {
    ps <- list(
      # ps_id = ps_id_p,
      ps_version = ps_version_p,
      ps_title = ps_title_p,
      ps_short = ps_short_p,
      ps_descr = ps_descr_p,
      ps_initial_vars = ps_initial_vars_p,
      task_list = NULL
    )
  }

  if (id != "") {
    prompts <- update_list(prompts, id, msg, var, code, hints)
    ps$task_list <- prompts
  }

  return(ps)
}

#----------------------------------------------------------------------------#
# Check the basic integrity of the practice set. Where possible, clean
# things up and make corrections
#----------------------------------------------------------------------------#
check_ps <- function(ps) {
  cDEBUG <- FALSE
  N <- length(ps$task_list)

  if (cDEBUG) {
    print("ONE: messages")
  }
  # Check that all messages have been assigned something
  for (k in 1:N) {
    if (ps$task_list[[k]]$prompt_msg == "") {
      ps$task_list[[k]]$prompt_msg <- "<no prompt assigned>"
    }
  }

  if (cDEBUG) {
    print("TWO: answers")
  }
  # Check that the expected answer has some code
  for (k in 1:N) {
    if (is.null(ps$task_list[[k]]$expected_answer)) {
      ps$task_list[[k]]$expected_answer <- ""
    }
  }

  if (cDEBUG) {
    print("THREE: message notes")
  }
  # Check if a task ID is a dash ("-"), which means it is a note (not a prompt for code)
  for (k in 1:N) {
    if (ps$task_list[[k]]$prompt_id == "-") {
      ps$task_list[[k]]$is_note_msg <- TRUE
    } else {
      ps$task_list[[k]]$is_note_msg <- FALSE
    }
  }

  if (cDEBUG) print("FOUR: variable names")
  # Check that a variable name was assigned; if not, correct
  for (j in 1:N) {
    # Check of the prompt is a note (not a coding prompt)
    if (ps$task_list[[j]]$is_note_msg == TRUE) {
      next
    }
    # Check for a "good" assignment variable
    var_name <- ps$task_list[[j]]$assignment_var
    if (var_name == "") {
      fixed <- FALSE
      code <- ps$task_list[[j]]$expected_answer
      for (k in length(code):1) {
        t <- code[k]
        v <- get_var_lhs(t)
        if (!is.null(v)) {
          ps$task_list[[j]]$assignment_var <- v
          fixed <- TRUE
          break
        }
      }
      if (fixed == FALSE) {
        ps$task_list[[j]]$is_note_msg <- TRUE
        ps$task_list[[j]]$prompt_id <- "-"
      }
    }
  }

  if (cDEBUG) {
    print("FIVE: variable names are unique?")
  }
  # Check that a all variable names are unique
  var_list <- c()
  for (task in ps$task_list) {
    v <- task$assignment_var
    if (v != "") {
      if (v %in% var_list) {
        stop(paste0("check_ps: duplicate variable name (", v, ")"))
      }
      var_list <- append(var_list, v)
    }
  }

  if (cDEBUG) {
    print("SIX: check for prompt IDs")
  }
  # Check if a task ID has not been assigned
  renumber <- FALSE
  for (task in ps$task_list) {
    if (task$prompt_id == "?" || task$prompt_id == "") {
      renumber <- TRUE
      break
    }
  }

  # If an assignment ID has not been assigned make them up
  if (renumber) {
    IDs <- "abcdefghijklmnopqrstuvwxyz"
    new_id <- 1
    for (k in 1:N) {
      # Only assign new IDs to prompts that are NOT message prompts
      if (ps$task_list[[k]]$is_note_msg == FALSE) {
        if (N <= 26) {
          ps$task_list[[k]]$prompt_id <- str_sub(IDs, new_id, new_id)
        } else {
          ps$task_list[[k]]$prompt_id <- as.character(new_id)
        }
        new_id <- new_id + 1
      }
    }
  }

  if (cDEBUG) {
    print(ps)
  }

  return(ps)
}
