library("stringr")
cPRACTICE_SET_DIR = "/R/practice-sets/"

#' Create practice set from a coded text file
#'
#' Xxx xxx xxx
#'
#' @param ps a practice set
#' @return a filename
#' @export
create_practice_set <- function(ps,fn) {
  wdir <- getwd()
  filename <- paste0(wdir, cPRACTICE_SET_DIR, fn)
  ps$task_list <- process_prompts(filename)
  return(ps)
}

update_list <- function(prompts, id, msg, var, code, h) {
  new_prompt <- list(
    prompt_id = id,
    prompt_msg = msg,
    assignment_var = var,
    expected_answer = code,
    learner_answer = NULL,
    hints = h
  )
  prompts <- append(prompts, new_prompt)
  return(prompts)
}

process_prompts <- function(filename) {
  t <- readLines(filename)
  print(t)

  ps_id <- -1
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
    print(paste0("line: ", k, ": ", t[k]))

    if (str_detect(t[k], "^#")) {
      NULL # Do nothing
    } else if (str_detect(t[k], "^<ps_id>")) {
      ps_id <- str_trim(str_sub(t[k], 8, str_length(t[k])))
      print(paste0("ps_id: ", ps_id))
    } else if (str_detect(t[k], "^<id>")) {
      if (first_id == TRUE) {
        prompts <- update_list(prompts, id, msg, var, code, hints)
        id <- -1
        msg <- ""
        var <- ""
        code <- c()
        hints <- c()
      } else {
        first_id <- TRUE
      }
      id <- str_trim(str_sub(t[k], 5, str_length(t[k])))
      print(paste0("id: ", id))
    } else if (str_detect(t[k], "^<msg>")) {
      msg <- str_trim(str_sub(t[k], 6, str_length(t[k])))
      print(paste0("msg: ", msg))
    } else if (str_detect(t[k], "^<var>")) {
      var <- str_trim(str_sub(t[k], 6, str_length(t[k])))
      print(paste0("var: ", var))
    } else if (str_detect(t[k], "^<code>")) {
      print("code:")
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^</code>")) {
          break
        }
        code <- append(code, t[k])
        k <- k + 1
      }
      print(code)
    } else if (str_detect(t[k], "^<hints>")) {
      print("hints:")
      k <- k + 1
      while (k <= length(t)) {
        if (str_detect(t[k], "^</hints>")) {
          break
        }
        hints <- append(hints, t[k])
        k <- k + 1
      }
    }
    k <- k + 1
  }
  prompts <- update_list(prompts, id, msg, var, code, hints)
}

