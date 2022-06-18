#----------------------------------------------------------------------------#
# These functions are used to read and process practice set input files
#----------------------------------------------------------------------------#
cPRACTICE_SET_DIR <- "/R/practice-sets/"

# Create practice set from a coded text file
create_practice_set <- function(fn) {
  wdir <- getwd()
  filename <- paste0(wdir, cPRACTICE_SET_DIR, fn)
  if (file.exists(filename) == FALSE) {
    stop(paste0("create_practice_set: File does not exist\n", filename))
  }

  ps <- process_practice_set_doc(filename)
  if (is.null(ps)) {
    stop(paste0("create_practice_set: Practice set not created\n", filename))
  }

  ps <- check_practice_set(ps)
  return(ps)
}

#----------------------------------------------------------------------------#
# Utility to remove comment symbols from the front of a line of text
#----------------------------------------------------------------------------#
trim_comment <- function(s) {
  s <- str_trim(str_replace_all(s, "^#'", ""),side="right")
  return(s)
}

get_var_lhs <- function(s) {
  if(str_detect(s, "<-")) {
    p <- str_locate(s, "<-")
    v <- str_trim(str_sub(s, 1, p[1, 1] - 1))
    return(v)
  } else{
    return(NULL)
  }
}

#----------------------------------------------------------------------------#
# Check the basic integrity of the practice set. Where possible make
# corrections
#----------------------------------------------------------------------------#
check_practice_set <- function(ps) {

  print("ONE")
  # Check that all messages have been assigned something
  for (k in 1:length(ps$task_list)) {
    if (is.null(ps$task_list[[k]]$prompt_msg) || ps$task_list[[k]]$prompt_msg == "") {
      ps$task_list[[k]]$prompt_msg <- "<no prompt assigned>"
    }
  }

  print("TWO")
  # Check that the expected answer has some code
  for (k in 1:length(ps$task_list)) {
    if (is.null(ps$task_list[[k]]$expected_answer) || ps$task_list[[k]]$expected_answer == "") {
      ps$task_list[[k]]$expected_answer <- "1 == 1"
    }
  }

  print("THREE")
  # Check that a variable name was assigned; if not, correct
  for (j in 1:length(ps$task_list)) {
    var_name <- ps$task_list[[j]]$assignment_var
    if (is.null(var_name) || var_name == "") {
      fixed = FALSE
      code <- ps$task_list[[j]]$expected_answer
      for (k in length(code):1) {
        t <- code[k]
        print(t)
        v <- get_var_lhs(t)
        if (!is.null(v)) {
          ps$task_list[[j]]$assignment_var <- v
          fixed = TRUE
          break
        }
      }
      print(ps$task_list[[k]]$assignment_var)
      if (fixed==FALSE) {
        stop(paste0("check_practice_set: unable to correct variable name"))
      }
    }
  }

  print("FOUR")
  # Check that a all variable names are unique
  var_list <- c()
  for (task in ps$task_list) {
    v <- task$assignment_var
    if (v %in% var_list) {
      stop(paste0("check_practice_set: duplicate variable name (", v, ")"))
    }
    var_list <- append(var_list, v)
  }

  print("FIVE")
  # Check if a task ID has not been assigned
  renumber <- FALSE
  for (task in ps$task_list) {
    if (task$prompt_id == "?" || task$prompt_id == "" || is.null(task$prompt_id)) {
      renumber <- TRUE
      break
    }
  }

  cat("\n\n>>>>>")
  cat(renumber)

  # If an assignment ID has not been assigned make them up
  if (renumber) {
    IDs <- "abcdefghijklmnopqrstuvwxyz"
    n <- length(ps$task_list)
    for (k in 1:n) {
      if (n <= 26) {
        ps$task_list[[k]]$prompt_id <- str_sub(IDs, k, k)
      } else {
        ps$task_list[[k]]$prompt_id <- as.character(k)
      }
    }
    print(ps$task_list)
  }

  print(ps)

  return(ps)
}

#----------------------------------------------------------------------------#
# Helper function to update the practice set data structure
#----------------------------------------------------------------------------#
update_list <- function(prompts, id, msg, var, code, h) {
  new_prompt <- list(task = list(
    prompt_id = id,
    prompt_msg = msg,
    assignment_var = var,
    expected_answer = code,
    learner_answer = NULL,
    hints = h
  ))
  prompts <- append(prompts, new_prompt)
  return(prompts)
}

#----------------------------------------------------------------------------#
# A basic parser which produces a practice set data structure
# TODO: Get rid of "ps" in: ps_title, ps_short, ps_descr
#----------------------------------------------------------------------------#
process_practice_set_doc <- function(filename) {
  cDEBUG <- TRUE
  t <- readLines(filename)
  return(process_practice_set_vector(t))
}


process_practice_set_vector <- function(t) {

  cDEBUG <- FALSE

  if (cDEBUG) {
    print(t)
  }

  ps <- NULL
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

    # Found the practice set title
    if (str_detect(t[k], "^#' @ps_title")) {
      ps_title_p <- str_trim(str_sub(t[k], 13, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("ps_title: ", ps_title_p))
      }
    }

    # Found the practice set short title
    else if (str_detect(t[k], "^#' @ps_short")) {
      ps_short_p <- str_trim(str_sub(t[k], 13, str_length(t[k])))
      if (cDEBUG) {
        print(paste0("ps_short: ", ps_short_p))
      }
    }

    # Found the practice set description, which can be multiple lines
    else if (str_detect(t[k], "^#' @ps_descr")) {
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
    else if (str_detect(t[k], "^#' @ps_initial_vars")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^#' @")) {
          if (str_detect(t[k], "^#' @end")) {
            break
          }
          else {
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
        id <- -1
        msg <- ""
        var <- ""
        code <- c()
        hints <- c()

        # When we encounter an ID for the first time create the practice set list
      } else {
        first_id <- TRUE
        ps <- list(
          # ps_id = ps_id_p,
          ps_title = ps_title_p,
          ps_short = ps_short_p,
          ps_descr = ps_descr_p,
          initial_vars = ps_initial_vars_p,
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

  if (length(prompts)==0) {
    ps <- list(
      # ps_id = ps_id_p,
      ps_title = ps_title_p,
      ps_short = ps_short_p,
      ps_descr = ps_descr_p,
      initial_vars = ps_initial_vars_p,
      task_list = NULL
    )
  }
  else {
    prompts <- update_list(prompts, id, msg, var, code, hints)
    ps$task_list <- prompts
  }
  return(ps)
}
