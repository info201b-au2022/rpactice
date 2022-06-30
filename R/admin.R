# Admin ----
#----------------------------------------------------------------------------#
# Admin functions - very useful for debugging and for auto-grading
#----------------------------------------------------------------------------#

#' List the available admin functions
#'
#' Intended for teaching assistants and instructors only, \code{admin} simply
#' lists all the available admin functions.
#'
#' @export
admin <- function() {
  cat("\014") # Clear screen
  cat(crayon::red("Function\t\t   "),                   crayon::red("Purpose"), "\n")
  cat("admin()                     List the current admin functions\n")
  cat("admin.check([fn|dir])       Check the integrity of a practice set file.\n")
  cat("admin.grade(dir)            Grade all the work in the directory (dir).\n")
  cat("admin.grade_ui_dir()        Select a directory (dir) from a file dialog.\n")
  cat("admin.grade_ui_file()       Select a directory (dir) from a file dialog.\n")
  cat("admin.ls()                  List installed practice sets and basic info.\n")
  cat("admin.prompts(short)        List the practice prompts and results.\n")
  cat("admin.vars()                List all the variables that are 'alive'.\n")
  cat("---\n")
  cat("/Users/dhendry/Documents/_Code2/pinfo201/inst/extdata")
}

#' List installed practice sets
#'
#' Intended for teaching assistants and instructors only, \code{admin.ls()}
#' simply lists all currently installed practice sets. Each of these
#' practice sets are available to learners.
#'
#' @export
#----------------------------------------------------------------------------#
# List all the practice sets that have been loaded
#----------------------------------------------------------------------------#
admin.ls <- function() {
  v <- ps_get_all()
  cat("\014") # Clear screen
  cat("Practice sets:", str_trim(length(v)), "\n")
  for (k in 1:length(v)) {
    ps <- ps_get_by_short(v[k])
    num_prompts <- length(ps$task_list)
    cat(paste0(k, ": [", v[k], "]: ", ps$ps_title, " (Prompts: ", num_prompts, ")\n"))
    #cat(paste0("   Filename: ", ps$ps_filename, "\n"))
  }
}

#' Show the practice set prompts
#'
#' Intended for teaching assistants and instructors only, \code{admin.prompts()}
#' shows all of the practice sets, including the written prompts and the
#' expected answers
#'
#' @param short for the short name of the practice set
#'
#' @export
#----------------------------------------------------------------------------#
# List the prompts and some basic information for a practice set
#----------------------------------------------------------------------------#
admin.prompts <- function(short) {
  practice.begin(short)
  ps <- ps_get_by_short(short)
  if (is.null(ps)) {
    stop(paste0("Error. Practice set not found (", short, ")"))
  }
  cat("\014") # Clear screen
  cat("[", short, "]: ", ps$ps_title, " (Prompts: ", length(ps$task_list), ")\n", sep = "")

  v <- get_env_vars(short)
  t <- paste0(v, collapse = "\n")
  cat("Envir Variables\n  ", t, "\n")

  cat("ID\n")
  k <- 1
  for (task in ps$task_list) {
    if (task$is_note_msg) {
      m <- task$prompt_msg
      if (nchar(m) > 39) {
        m <- substr(m, 1, 40)
        m <- paste0(" ", m, "...")
      }
      cat(k, "[-] ", m, sep = "")
    } else {
      #r <- eval_string_and_format(task$expected_answer)
      r <- eval_string_and_format(task$assignment_var)
      if (nchar(r) > 65) {
        r <- substr(r, 1, 60)
        r <- paste0(r, "...")
      }

      cat(k, ":", task$prompt_id, "[", task$assignment_var, "]: ", task$prompt_msg, "\n", sep = "")
      t1 <- sprintf("%-60s", format_code(task$expected_answer))
      cat(t1, "\n", sep = "")
      cat("", crayon::red(r), "\n", sep = "")
    }
    k <- k + 1
    cat("\n")
  }
}

#' List practice set objects
#'
#' Intended for teaching assistants and instructors only, \code{admin.prompts()}
#' lists all of the objects associated with the currently active practice set,
#' including expected variables and callback functions for checking code.
#'
#' @export
#----------------------------------------------------------------------------#
# List all the variable names that are current alive in the practice set
#----------------------------------------------------------------------------#
admin.vars <- function() {
  v <- ps_get_live_var_names()
  cat("Live variables: ", "\n", sep = "")
  for (k in 1:length(v)) {
    cat("   ", k, ":[", v[k], "]:\t",  sep = "")
    cat("\n")
  }
  cat("Number: ", length(v), "\n")
  cat("Callbacks loaded:\n")
  any <- 0
  for (k in 1:length(v)) {
    if (is_callback_loaded(v[k])) {
      cat("   ", k, ":CALLBACK:", v[k], "_Check(internal_id, result)\n", sep = "")
      any <- any + 1
    }
  }
  if (any > 0) {
    cat("Number:", any)
  } else {
    cat("No callbacks.")
  }
  cat("\n")
}

admin.run <- function(short)  {
  id <- ps_get_id_by_short(short)
  if (id == -1) {
    stop(paste0("Error. Practice set not found (", short, ")"))
  }
  ps_set_current(id)

  cat("\014admin.run()\n")
  cat(
    "Short ID: ", short,
    "\n", "Code:\n", sep="")

  t <- ps_get_expected_code()
  for (k in 1:length(t)) {
    cat("[", k, "] ", t[k], "\n", sep = "")
  }

  cat("\n",
      "Environment: pkg.expected_env\n", sep="")

  all <- ls(envir = pkg.expected_env)
  rm(list = all, envir = pkg.expected_env)
  eval(parse(text = t), envir = pkg.expected_env)

  out <- sprintf("%-20s %-10s %-80s\n", "Variable", "Type", "Value")
  cat(out)

  all <- ls(envir = pkg.expected_env)
  for (k in 1:length(all)) {
    var <- all[k]
    val <- get(var, envir=pkg.expected_env)
    t <- typeof(val)
    s <- format_variable(val)

    out <- sprintf("%-20s %-10s %-60s\n", var, t , s)
    cat(out)
  }
}

#' Evaluate a directory of practice sets
#'
#' Intended for teaching assistants and instructors only, \code{admin.grade()},
#' will check all of the practice sets within a directory.
#'
#' @param filename either a directory for a particular file
#'
#' @export
admin.grade <- function(filename) {

  if (!file.exists(filename)) {
    stop(paste0("Directory does not exist.\n", dir, ""), sep="")
  }

  file_list <- c()
  file_names <- c()
  dir <- ""
  if (dir.exists(filename)) {
    file_list <- list.files(filename, pattern = "*.R", full.names = TRUE)
    file_names <- list.files(filename, pattern = "*.R")
    dir <- filename
  } else {
    file_list <- append(file_list, filename)
    file_names <- append(file_names, basename(filename))
    dir <- dirname(filename)
  }

  cat("\014admin.grade()\n") # Clear screen
  cat(
      "Directory: ", dir, "\n",
      "Student work: ", filename, "\n",
      "Summary:\n", sep="")

  t <- sprintf("%-30s %-20s %-15s %-15s", "Filename", "Name", "Summary", "Wrong Answers (internal ids)\n")
  cat("        ", t, sep="")

  for (k in 1:length(file_list)) {

    # Get the learners code from a file
    code_v <- readLines(file_list[k])
    code_string <- paste0(code_v, collapse = "\n")

    # Try to evaluate the code
    out <- tryCatch(
      {
        eval(parse(text = code_string), envir = globalenv())
      },
      error = function(cond) {
        message(paste0("Evaluation failed."))
        message(paste0("Filename: ", file_list[k]))
        message(cond)
      }
    )

    # Check the answers and get the results
    result <- check_answers(code_v)
    t <-format_grading(result)

    # Write grading results
    ps_feedback_fn <- str_replace(file_names[k], ".R", ".html")
    ps_feedback_fn <- paste0(dir, "/", ps_feedback_fn)
    fileConn <- file(ps_feedback_fn, "w")
    writeLines(t, fileConn)
    close(fileConn)

    # Collect some basic feedback
    wrongs <- paste0(result$incorrect_v, collapse=" ")

    t <- sprintf("%-30s %-20s %-15s %-15s",
                 file_names[k],
                 result$user_name,
                 paste0(result$num_correct, " of ",
                        (result$num_incorrect+result$num_correct)),
                 wrongs
                 )
    cat("[", k, "]\t", t, "\n", sep="")
  }

  cat("See graded work in:\n   ", filename, "/<Filename.html>", sep="")
  }

#' UI for selecting a directory to grade
#'
#' @export
admin.grade_ui_dir <- function() {

t <- rstudioapi::selectDirectory(
  caption = "Select a Directory of Files to Grade",
  label = "Select",
  path = paste0(getActiveProject(),"/inst/extdata")
)

if(is.null(t)) {
  return(TRUE)
} else {
  return (admin.grade(t))
}
}

#' UI for selecting a directory to grade
#'
#' @export
admin.grade_ui_file <- function() {

  t <- rstudioapi::selectFile(
    caption = "Select an Answer File to Grade",
    label = "Select",
    filter = "R Files (*.R)",
    path = paste0(getActiveProject(),"/inst/extdata/answers")
)

  if(is.null(t)) {
    return(TRUE)
  } else {
    return (admin.grade(t))
  }
}

#' Check the integrity of practice set
#'
#' Intended for teaching assistants and instructors only, \code{admin.ps()}
#' checks the integrity of a practice set. It loads the source file and provides
#' feedback on the mark-up.
#'
#' @param filename the file to be checked
#' @param silient output messages
#' @param detailed show (or do not show) detailed messages
#' @export
admin.check <- function(filename, silient=FALSE, detailed=FALSE) {
  check_file_integrity(filename, silient, detailed)
}
