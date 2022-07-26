# Reading practice sets ----
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

mk_github_dir_path <- function(dir_path) {
  t <- "https://api.github.com/repos/dghendry/rpractice/contents/"
  return(paste0(t, dir_path))
}

# START HERE
# https://cran.r-project.org/web/packages/jsonlite/vignettes/json-aaquickstart.html
# https://cran.r-project.org/web/packages/jsonlite/jsonlite.pdf
create_ps_from_github <- function(dir, clear=FALSE) {

  # Should the list of practice sets be cleared?
  if (clear == TRUE) {
    ps_clear()
  }

  # Create the correct path and check that the directory exists
  dir_path <- mk_github_dir_path(dir)
  if (RCurl::url.exists(dir_path) == FALSE) {
    #stop(paste0("create_ps_from_github: directory does not exist\n", dir_path))
  }
  cat("\n github path", dir_path, "\n")

  # Read the list of filenames from the directory into a dataframe and
  # build the practice set for each filename
  conn <- curl::curl(dir_path)
  tryCatch(
    expr = {
      file_data <- jsonlite::prettify(readLines(conn, warn=FALSE))
    }, error = function(e) {
      stop(paste0("create_ps_from_github: file access error\n", e, "\n", dir_path))
    }
  )
  file_data <- jsonlite::prettify(readLines(conn, warn=FALSE))
  files_to_process <- jsonlite::fromJSON(file_data)
  for (k in 1:length(files_to_process$download_url)) {
    cat(k, ": ", files_to_process$download_url[k], "\n")
    ps <- create_ps_from_url(files_to_process$download_url[k])
    ps_add(ps)
  }
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
load_ps <- function(fn, silent = TRUE) {
  filename <- system.file("extdata", fn, package = "pinfo201", mustWork = TRUE)
  ps <- read_ps_doc(filename)
  ps$ps_filename <- filename
  ps <- check_ps(ps, silent)
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
  # s is a vector so turn it into a single string
  t <- paste0(s, collapse = "\n")
  tryCatch(
    expr = {
      e <- parse(text = t)
      r <- ast_last_assignment(e)
      if (length(r) == 0) {
        return(NULL)
      } else {
        return(r$lhs)
      }
    },
    error = function(e) {
      return(NULL)
    }
  )
}

#----------------------------------------------------------------------------#
# Helper function to update the practice set data structure
#----------------------------------------------------------------------------#
update_list <- function(prompts, id, msg, var, cp_var, check, code, h) {
  t_var <- var
  t_cp_var <- FALSE

  if (cp_var != "") {
    t_var <- cp_var
    t_cp_var <- TRUE
  }

  new_prompt <- list(task = list(
    prompt_id = id,
    is_note_msg = FALSE,
    prompt_msg = msg,
    assignment_var = t_var,
    checks_for_f = check,
    copy_var = t_cp_var,
    expected_answer = code,
    learner_answer = NULL,
    hints = h
  ))
  prompts <- append(prompts, new_prompt)
  return(prompts)
}

# Parsing practice sets ----
#----------------------------------------------------------------------------#
# Parse the practice set document and produce the following structure:
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
#        copy_var <string>
#        expected_answer = c(<string>, <string>, ...) // lines of code
#        learner_answer = NULL  // during checking, filled in with lines of code
#        hints = c(<string>, <string>, ...)   // list of hints
#     )
#   )
# )
#----------------------------------------------------------------------------#
parse_ps <- function(t, silient = TRUE) {
  if (!silient) {
    print(t)
  }

  ps <- NULL
  ps_version_p <- ""
  ps_filename <- ""
  ps_title_p <- ""
  ps_short_p <- "_SHORT_"
  ps_descr_p <- ""
  ps_initial_vars_p <- c()

  id <- -1
  msg <- ""
  var <- ""
  cp_var <- ""
  check <- ""
  code <- c()
  hints <- c()

  prompts <- c()
  first_id <- FALSE
  k <- 1

  while (k <= length(t)) {
    rec <- t[k]
    if (!silient) {
      print(paste0("line: ", k, ": ", t[k]))
    }

    # Syntax clean-up for a common typo, namely "#' #'"
    if (str_detect(t[k], "^#' #'")) {
      replace_t <- str_replace(t[k], "^#' #'", "#'")
      t[k] <- replace_t
    }

    # Found the practice set title
    if (str_detect(t[k], "^#' @title")) {
      ps_title_p <- str_trim(str_sub(t[k], 10, str_length(t[k])))
      if (!silient) {
        print(paste0("ps_title: ", ps_title_p))
      }
    }

    # Found the practice set version
    else if (str_detect(t[k], "^#' @version")) {
      ps_version_p <- str_trim(str_sub(t[k], 12, str_length(t[k])))
      if (!silient) {
        print(paste0("ps_version: ", ps_version_p))
      }
    }

    # Found the practice set short title
    else if (str_detect(t[k], "^#' @short")) {
      ps_short_p <- str_trim(str_sub(t[k], 10, str_length(t[k])))
      if (!silient) {
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
      if (!silient) {
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
      if (!silient) {
        print(paste0("ps_initial_vars: ", ps_initial_vars_p, collpase = "\n"))
      }
    }

    # Found a prompt ID
    else if (str_detect(t[k], "^#' @id")) {

      # For the second or more ID update the prompts list structure
      if (first_id == TRUE) {
        prompts <- update_list(prompts, id, msg, var, cp_var, check, code, hints)
        id <- ""
        msg <- ""
        var <- ""
        cp_var <- ""
        check <- ""
        code <- c()
        hints <- c()

        # When we encounter an ID for the first time create the practice set list
      } else {
        first_id <- TRUE
        ps <- list(
          ps_version = ps_version_p,
          ps_filename = "",
          ps_title = ps_title_p,
          ps_short = ps_short_p,
          ps_descr = ps_descr_p,
          ps_initial_vars = ps_initial_vars_p,
          task_list = NULL
        )
      }
      id <- str_trim(str_sub(t[k], 7, str_length(t[k])))
      if (!silient) {
        print(paste0("id: ", id))
      }

      # Found the message for this prompt
    } else if (str_detect(t[k], "^#' @msg")) {
      msg <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      if (!silient) {
        print(paste0("msg: ", msg))
      }
      k <- k + 1
      # Keep reading until we get to end or until @code or @id
      while (k < length(t)) {
        if (str_detect(t[k], "^#' @end")) {
          break
        }
        if (str_detect(t[k], "^#' @code") ||
          str_detect(t[k], "^#' @id") ||
          str_detect(t[k], "^#' @check") ||
          str_detect(t[k], "^#' @var") ||
          str_detect(t[k], "^#' @cp-var")) {
          k <- k - 1 # push the line back, so we can process this chunk on the next loop
          break
        }
        msg <- paste0(msg, "\n", t[k])
        k <- k + 1
      }

      # Found the name of the variable for this prompt
    } else if (str_detect(t[k], "#' @var")) {
      var <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      if (!silient) {
        print(paste0("var: ", var))
      }

      # Found the name cp-var
    } else if (str_detect(t[k], "#' @cp-var")) {
      cp_var <- str_trim(str_sub(t[k], 11, str_length(t[k])))
      if (!silient) {
        print(paste0("cp-var: ", cp_var))
      }

      # Found the check information
    } else if (str_detect(t[k], "#' @check")) {
      check <- str_trim(str_sub(t[k], 10, str_length(t[k])))
      if (!silient) {
        print(paste0("check: ", check))
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
      if (!silient) {
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
      if (!silient) {
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
    prompts <- update_list(prompts, id, msg, var, cp_var, check, code, hints)
    ps$task_list <- prompts
  }

  return(ps)
}

# Integrity checking ----
#----------------------------------------------------------------------------#
# This function runs through a practice set specification and checks
# its integrity.
#----------------------------------------------------------------------------#
check_file_integrity <- function(filename, silient = FALSE, detailed = FALSE) {
  if (!file.exists(filename)) {
    message(paste0("File not found.\n", filename))
    return()
  }
  file_list <- c()
  if (dir.exists(filename)) {
    file_list <- list.files(filename, pattern = "*.R", full.names = TRUE)
  } else {
    file_list <- append(file_list, filename)
  }

  for (k in 1:length(file_list)) {
    tryCatch(
      expr = {
        t <- readLines(file_list[k])
      },
      error = function(e) {
        stop(paste0("check_file_integrity:\nFilename: ", file_list[k], "\n", e))
      }
    )

    # Checking tags ...
    if (!silient) {
      message("\n1. Checking tags ...")
      message("   Filename: ", file_list[k], "")

      if (detailed) {
        message("Lines")
      }
      check_tags(t, silient, detailed)
    }

    if (!silient) {
      message("Done step 1.\n")
    }

    # Parsing the file
    if (!silient) {
      message("2. Parsing file ...")
      message("   Filename: ", file_list[k], "")
    }
    ps <- parse_ps(t)
    ps$ps_filename <- file_list[k]

    if (!silient) {
      message("Done step 2.\n")
    }

    # Checking the output
    if (!silient) {
      message("3. Checking practice set integrity ... ")
    }
    ps <- check_ps(ps, silient)

    if (!silient) {
      message("Done step 3.\n")
    }

    # Evaluating code
    if (!silient) {
      message("4. Checking the expected code ... ")
    }

    check_test_code(ps)

    if (!silient) {
      message("Done step 4.\n")
    }
  }
}

check_test_code <- function(ps) {
  # Basic information on the prompts, variables, and code
  cat("\nI. Variable information for each prompt ('\\n' collapsed to ';'):\n", sep = "")
  t <- sprintf("%6s\t%-20s\t%5s\t%-78s\n", "Prompt", "Variable Name", "Copy?", "Code")
  cat(t)

  for (task in ps$task_list) {
    a <- paste0(task$expected_answer, collapse = ";")
    if (nchar(a) > 74) {
      a <- str_sub(a, 1, 74)
      a <- paste0(a, " ...")
    }
    t <- sprintf("%6s\t%20s\t%5s\t%-78s\n", task$prompt_id, task$assignment_var, task$copy_var, a)
    cat(t)
  }
  cat("\n")

  # The initial variables
  code <- c()
  for (k in 1:length(ps$ps_initial_vars)) {
    code <- append(code, ps$ps_initial_vars[k])
  }
  cat("II. Initial Variables:\n   ")
  if (length(code) != 0) {
    t <- paste0(ps$ps_initial_vars, collapse = "\n   ")
  } else {
    t <- "None."
  }
  cat(t)

  # The variables to copy, if any
  v <- c()
  for (task in ps$task_list) {
    if (task$copy_var == TRUE) {
      v <- append(v, task$assignment_var)
    }
  }
  cat("\n\nIII. Variables to copy:\n   ")
  if (length(v) > 0) {
    t <- paste0(v, collapse = "\n   ")
  } else {
    t <- "None."
  }
  cat(t)

  cat("\n",
    "\nIV. Code (for easy copy-and-paste)\n",
    sep = ""
  )
  code <- c()
  for (k in 1:length(ps$ps_initial_vars)) {
    code <- append(code, ps$ps_initial_vars[k])
  }
  for (task in ps$task_list) {
    if (task$copy_var == FALSE) {
      code <- append(code, task$expected_answer)
    }
  }

  for (c in code) {
    cat(c, "\n", sep = "")
  }

  # If possible try running the code (currently, if
  # are variables to copy we can't runn the code because
  # there values are undefined.
  if (length(v) == 0) {
    results <- eval_code_expected(code)
    cat("\n",
      "V. Environment: pinfo201.expected_env\n",
      sep = ""
    )
    cat(sprintf("%-20s %-10s %-80s\n", "Variable", "Type", "Value"))
    if (!is.null(results)) {
      for (r in results) {
        out <- sprintf("%-20s %-10s %-60s\n", r$vname, r$vtype, r$vstr)
        cat(out)
      }
    } else {
      stop("admin.run(): eval_code_expected FAILED.\n")
    }
  } else {
    cat("\nV. Did not evaluate code - because there are variables to copy.\n")
  }
}


#----------------------------------------------------------------------------#
# This function checks that are all tags are known
#----------------------------------------------------------------------------#
check_tags <- function(t, silient = FALSE, detailed = FALSE) {
  any_errors <- FALSE
  prompts_will_be_renumbered <- 0
  msg_prompts <- 0
  num_prompts <- 0

  for (k in 1:length(t)) {
    if (!silient && detailed) {
      message(paste0("   [", k, "]: ", t[k], ""))
    }

    if (str_detect(t[k], "^#' @")) {
      if (str_detect(t[k], "^#' @check ")) {
        next
      }
      if (str_detect(t[k], "^#' @code$")) {
        next
      }
      if (str_detect(t[k], "^#' @descr")) {
        next
      }
      if (str_detect(t[k], "^#' @end$")) {
        next
      }
      if (str_detect(t[k], "^#' @id \\?$")) {
        num_prompts <- num_prompts + 1
        prompts_will_be_renumbered <- prompts_will_be_renumbered + 1
        next
      }
      if (str_detect(t[k], "^#' @id -$")) {
        num_prompts <- num_prompts + 1
        msg_prompts <- msg_prompts + 1
        next
      }
      if (str_detect(t[k], "^#' @id ")) {
        num_prompts <- num_prompts + 1
        next
      }
      if (str_detect(t[k], "^#' @msg ")) {
        next
      }
      if (str_detect(t[k], "^#' @msg")) {
        next
      }
      if (str_detect(t[k], "^#' @initial-vars$")) {
        next
      }
      if (str_detect(t[k], "^#' @hints$")) {
        next
      }
      if (str_detect(t[k], "^#' @short ")) {
        next
      }
      if (str_detect(t[k], "^#' @title ")) {
        next
      }
      if (str_detect(t[k], "^#' @var ")) {
        next
      }
      if (str_detect(t[k], "^#' @cp-var ")) {
        next
      }
      if (str_detect(t[k], "^#' @version ")) {
        next
      }
      any_errors <- TRUE

      message(paste0(">>> Unrecognized tag:"))
      message(paste0("   [", k, "] ", t[k], "\n"))
    }
  }

  if (!silient) {
    if (any_errors == FALSE) {
      message(paste0("   Summary: All tags appear good."))
    } else {
      message(paste0("   Summary: Erroneous tags found."))
    }

    message(paste0("   Summary: Num prompts: ", num_prompts))
    message(paste0("   Summary: Num message prompts: ", msg_prompts))

    if (prompts_will_be_renumbered > 0) {
      message(paste0("   Summary: Prompt IDs will be renumbered: Yes."))
    } else {
      message(paste0("   Summary: Prompt IDs will be renumbered: No."))
    }
  }
}

#----------------------------------------------------------------------------#
# Check the basic integrity of the practice set. Where possible, clean
# things up and make corrections
#----------------------------------------------------------------------------#
check_ps <- function(ps, silent = FALSE) {
  letters <- "abcdefghijklmnopqrstuvwxyz"
  no_prompt_assigned <- "<no prompt assigned>"

  N <- length(ps$task_list)

  if (!silent) {
    message(paste0("   ", ps$ps_short, ": ", ps$ps_title))
    message(paste0("   From filename: ", ps$ps_filename))
    message(paste0("   Number of prompts: ", N))
    message(paste0("A. Analyzing prompts:"))
  }

  # Check that all messages have been assigned something
  for (k in 1:N) {
    if (ps$task_list[[k]]$prompt_msg == "") {
      ps$task_list[[k]]$prompt_msg <- no_prompt_assigned
    }
  }

  # Remove R comments
  for (k in 1:N) {
    ps$task_list[[k]]$prompt_msg <- str_trim(
      str_replace_all(ps$task_list[[k]]$prompt_msg, "#'", "")
    )

    ps$task_list[[k]]$prompt_msg <-
      str_replace(ps$task_list[[k]]$prompt_msg, "^\n", "")
  }

  # Check that the expected answer has some code
  for (k in 1:N) {
    if (length(ps$task_list[[k]]$expected_answer) == 0) {
      if (ps$task_list[[k]]$prompt_id != "-") {
        if (!silent) {
          message(paste0("   [", k, "] @code. No code found."))
        }
      }
    }
  }

  # Check if a task ID is a dash ("-"), which means it is a note (not a prompt for code)
  for (k in 1:N) {
    if (ps$task_list[[k]]$prompt_id == "-") {
      ps$task_list[[k]]$is_note_msg <- TRUE
    } else {
      ps$task_list[[k]]$is_note_msg <- FALSE
    }
  }

  # Check that a variable name was assigned; if not, correct
  for (j in 1:N) {
    # Check of the prompt is a note (not a coding prompt)
    if (ps$task_list[[j]]$is_note_msg == TRUE) {
      next
    }
    # Check for a "good" assignment variable

    var_name <- ps$task_list[[j]]$assignment_var # TODO: vector?
    if (var_name == "") {
      fixed <- FALSE
      v <- get_var_lhs(ps$task_list[[j]]$expected_answer)
      if (!is.null(v)) {
        if (!silent) {
          message(paste0("   [", j, "] @var missing. Added variable: ", v))
        }
        ps$task_list[[j]]$assignment_var <- v
        fixed <- TRUE
      }

      if (fixed == FALSE) {
        if (!silent) {
          message(paste0("   [", j, "] @var missing: Is prompt a message?"))
          message(paste0("      Prompt:", ps$task_list[[j]]$prompt_msg))
        }
        ps$task_list[[j]]$is_note_msg <- TRUE
        ps$task_list[[j]]$prompt_id <- "-"
      }
    }
  }

  # # Check that a all variable names are unique - if not unique, try to fix
  # var_list <- c()
  # for (j in 1:N) {
  #   v <- ps$task_list[[j]]$assignment_var # TODO: vector?
  #   duplicate <- FALSE
  #   old_v <- v
  #   if (v != "") {
  #     k <- 1
  #     repeat {
  #       if (v %in% var_list) {
  #         duplicate <- TRUE
  #         if (k == 1) {
  #           v <- paste0(v, ".")
  #         } else if (k > 5) {
  #           stop(paste0("check_ps: duplicate variable name - could not correct (", v, ")"))
  #         }
  #         v <- paste0(v, str_sub(letters, k, k))
  #       } else {
  #         var_list <- append(var_list, v)
  #         ps$task_list[[j]]$assignment_var <- v
  #         break
  #       }
  #       k <- k + 1
  #     }
  #   }
  #   if (!silent && duplicate) {
  #     message(paste0("   [", j, "] @var: Duplicate varirable names."))
  #     message(paste0("      Changed variable name (from ", old_v, " to ", ps$task_list[[j]]$assignment_var, ")."))
  #   }
  # }

  # Check if a task ID has not been assigned
  renumber <- FALSE
  for (task in ps$task_list) {
    if (task$prompt_id == "?" || task$prompt_id == "") {
      renumber <- TRUE
      break
    }
  }

  if (!silent) {
    message(paste0("B. Checking prompt IDs:"))
  }

  # If an assignment ID has not been assigned make them up
  if (renumber) {
    if (!silent) {
      message(paste0("   Found '?' or nothing. Renumbering prompt IDs."))
    }
    new_id <- 1
    for (k in 1:N) {
      # Only assign new IDs to prompts that are NOT message prompts
      if (ps$task_list[[k]]$is_note_msg == FALSE) {
        if (N <= 26) {
          ps$task_list[[k]]$prompt_id <- str_sub("abcdefghijklmnopqrstuvwxyz", new_id, new_id)
        } else {
          ps$task_list[[k]]$prompt_id <- as.character(new_id)
        }
        new_id <- new_id + 1
      }
    }
  }

  if (!silent) {
    message(paste0("C. Checking the checks:"))
  }

  no_checks_found <- TRUE

  for (k in 1:N) {
    t <- ps$task_list[[k]]$checks_for_f

    if (is.null(t)) {
      ps$task_list[[k]]$checks_for_f <- ""
    }

    if (ps$task_list[[k]]$checks_for_f != "") {
      no_checks_found <- FALSE
      tryCatch(
        expr = {
          e <- parse(text = ps$task_list[[k]]$checks_for_f)
          if (!silent) {
            message(paste0("   [", k, "] Checking: ", ps$task_list[[k]]$checks_for_f), " Good!")
          }
        },
        error = function(e) {
          if (!silent) {
            message(paste0("   [", k, "] Syntax error: ", ps$task_list[[k]]$checks_for_f))
          }
          stop(paste0("   [", k, "] Syntax error: ", ps$task_list[[k]]$checks_for_f))
        }
      )
    }
  }

  if (!silent) {
    if (no_checks_found) {
      message("   No checks found.")
    }
  }

  return(ps)
}
