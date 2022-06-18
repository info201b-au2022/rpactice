library(stringr)
cPRACTICE_SET_DIR = "/R/practice-sets/"


trim_comment <- function(s) {
  s <- str_trim(str_replace_all(s, "#'", ""))
  return(s)
}

#' Create practice set from a coded text file
#'
#' Xxx xxx xxx
#'
#' @param ps a practice set
#' @return a filename
#' @export
create_practice_set <- function(fn) {
  wdir <- getwd()
  filename <- paste0(wdir, cPRACTICE_SET_DIR, fn)
  ps <- process_practice_set_doc2(filename)
  return(ps)
}

update_list <- function(prompts, id, msg, var, code, h) {
  new_prompt <- list( task = list(
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

process_practice_set_doc <- function(filename) {
  cDEBUG <- FALSE
  t <- readLines(filename)
  if (cDEBUG) {print(t)}

  ps_id_p <- -1
  ps_title_p <- ""
  ps_short_p <- "P03"
  ps_descr_p <- c()
  ps_initial_vars_p = c()

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
    if (cDEBUG) {print(paste0("line: ", k, ": ", t[k]))}

    # Found a comment
    if (str_detect(t[k], "^#")) {
      NULL # Do nothing

    # Found the practice set ID
    } else if (str_detect(t[k], "^<ps_id>")) {
      ps_id_p <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      if (cDEBUG) {print(paste0("ps_id: ", ps_id_p))}

    # Found the practice set title
    } else if (str_detect(t[k], "^<ps_title>")) {
      ps_title_p <- str_trim(str_sub(t[k], 11, str_length(t[k])))
      if (cDEBUG) {print(paste0("ps_title: ", ps_title_p))}
    }

    # Found the practice set short title
    else if (str_detect(t[k], "^<ps_short>")) {
      ps_short_p <- str_trim(str_sub(t[k], 11, str_length(t[k])))
      if (cDEBUG) {print(paste0("ps_short: ", ps_short_p))}
    }

    # Found the practice set description, which can be multiple lines
    else if (str_detect(t[k], "^<ps_descr")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^</ps_descr>")) {
          break
        }
        ps_descr_p <- append(ps_descr_p, t[k])
        k <- k + 1
      }
      if (cDEBUG) {print(paste0("descr: ", ps_descr_p))}
    }

    # Found the list of initial variables
    else if (str_detect(t[k], "^<ps_initial_vars")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^</ps_initial_vars>")) {
          break
        }
        ps_initial_vars_p <- append(ps_initial_vars_p, t[k])
        k <- k + 1
      }
      if (cDEBUG) {print(paste0("ps_initial_vars: ", ps_initial_vars_p))}
    }

    # Found a prompt ID
    else if (str_detect(t[k], "^<id>")) {

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
          ps_id = ps_id_p,
          ps_title = ps_title_p,
          ps_short = ps_short_p,
          ps_descr = ps_descr_p,
          initial_vars = ps_initial_vars_p,
          task_list = NULL
        )
      }
      id <- str_trim(str_sub(t[k], 5, str_length(t[k])))
      if (cDEBUG) {print(paste0("id: ", id))}

      # Found the message for this prompt
    } else if (str_detect(t[k], "^<msg>")) {
      msg <- str_trim(str_sub(t[k], 6, str_length(t[k])))
      if (cDEBUG) {print(paste0("msg: ", msg))}

      # Found the name of the variable for this prompt
    } else if (str_detect(t[k], "^<var>")) {
      var <- str_trim(str_sub(t[k], 6, str_length(t[k])))
      if (cDEBUG) {print(paste0("var: ", var))}

      # Found the correct code for this prompt
    } else if (str_detect(t[k], "^<code>")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^</code>")) {
          break
        }
        code <- append(code, t[k])
        k <- k + 1
      }
      if (cDEBUG) {print(paste0("Code: ", code))}

      # Found the list of hints for this prompt
    } else if (str_detect(t[k], "^<hints>")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^</hints>")) {
          break
        }
        hints <- append(hints, t[k])
        k <- k + 1
      }
      if (cDEBUG) {print(paste0("hints:", hints))}
    }
    k <- k + 1
  }
  prompts <- update_list(prompts, id, msg, var, code, hints)
  ps$task_list <- prompts
  return(ps)
}

process_practice_set_doc2 <- function(filename) {
  cDEBUG <- TRUE
  t <- readLines(filename)
  if (cDEBUG) {print(t)}

  ps_id_p <- -1
  ps_title_p <- ""
  ps_short_p <- "P03"
  ps_descr_p <- c()
  ps_initial_vars_p = c()

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
    if (cDEBUG) {print(paste0("line: ", k, ": ", t[k]))}

      # Found the practice set ID
    if (str_detect(t[k], "^#' @ps_id")) {
      ps_id_p <- str_trim(str_sub(t[k], 10, str_length(t[k])))
      if (cDEBUG) {print(paste0("ps_id: ", ps_id_p))}

      # Found the practice set title
    } else if (str_detect(t[k], "^#' @ps_title")) {
      ps_title_p <- str_trim(str_sub(t[k], 13, str_length(t[k])))
      if (cDEBUG) {print(paste0("ps_title: ", ps_title_p))}
    }

    # Found the practice set short title
    else if (str_detect(t[k], "^#' @ps_short")) {
      ps_short_p <- str_trim(str_sub(t[k], 13, str_length(t[k])))
      if (cDEBUG) {print(paste0("ps_short: ", ps_short_p))}
    }

    # Found the practice set description, which can be multiple lines
    else if (str_detect(t[k], "^#' @ps_descr")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^#' @end")) {
          break
        }
        ps_descr_p <- append(ps_descr_p, trim_comment(t[k]))
        k <- k + 1
      }
      if (cDEBUG) {print(paste0("descr: ", ps_descr_p, collapse="\n"))}
    }

    # Found the list of initial variables
    else if (str_detect(t[k], "^#' @ps_initial_vars")) {
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^#' @end")) {
          break
        }
        ps_initial_vars_p <- append(ps_initial_vars_p, t[k])
        k <- k + 1
      }
      if (cDEBUG) {print(paste0("ps_initial_vars: ", ps_initial_vars_p, collpase="\n"))}
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
          ps_id = ps_id_p,
          ps_title = ps_title_p,
          ps_short = ps_short_p,
          ps_descr = ps_descr_p,
          initial_vars = ps_initial_vars_p,
          task_list = NULL
        )
      }
      id <- str_trim(str_sub(t[k], 7, str_length(t[k])))
      if (cDEBUG) {print(paste0("id: ", id))}

      # Found the message for this prompt
    } else if (str_detect(t[k], "^#' @msg")) {
      msg <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      if (cDEBUG) {print(paste0("msg: ", msg))}

      # Found the name of the variable for this prompt
    } else if (str_detect(t[k], "#' @var")) {
      var <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      if (cDEBUG) {print(paste0("var: ", var))}

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
      if (cDEBUG) {print(paste0("Code: ", code))}

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
      if (cDEBUG) {print(paste0("hints:", hints))}
    }
    k <- k + 1
  }
  prompts <- update_list(prompts, id, msg, var, code, hints)
  ps$task_list <- prompts
  return(ps)
}

