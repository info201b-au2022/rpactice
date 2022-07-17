# Admin ----
#----------------------------------------------------------------------------#
# Admin functions - very useful for debugging and for auto-grading
#----------------------------------------------------------------------------#

#' List the available admin functions
#'
#' Intended for teaching assistants and instructors only, \code{admin} simply
#' lists all the available administrative functions. Use these functions to
#' create practice sets and to grade student work.
#'
#' @export
admin <- function() {
  cat("\014") # Clear screen
  cat(crayon::red("Function\t\t       "), crayon::red("Purpose"), "\n")
  cat("admin()                         List the current admin functions.\n")
  cat("admin.grade()                   Select a directory (dir) and grade all work.\n")
  cat("admin.grade_fn(fn)              Grade work in directory or grade single file.\n")
  cat("admin.grade_ui_file()           Select a file and grade it.\n")
  cat("admin.load(dir)                 Load practice sets from the directory.\n")
  cat("admin.ls()                      List installed practice sets.\n")
  cat("admin.prompts(short)            List the practice prompts and expected results - the answers!\n")
  cat("admin.run(short)                Execute the code in a practice set - and check if the code works.\n")
  cat("---\n")
  cat("Examples:\n")
  cat("admin.check(\"~/Documents/_Code2/pinfo201/inst/extdata/<fname>\")\n")
  cat('admin.load("/Users/dhendry/Documents/_Code2/assignments/practice-sets")\n')
  cat('admin.grade_fn("/Users/dhendry/Documents/_Code2/assignments/A01")')
}

#' List installed practice sets
#'
#' Intended for teaching assistants and instructors only, \code{admin.ls()}
#' simply lists all currently installed practice sets. Each of these
#' practice sets are available to learners and for grading.
#'
#' To grade student work, the practice set must be loaded.
#'
#' @export
#----------------------------------------------------------------------------#
# List all the practice sets that have been loaded
#----------------------------------------------------------------------------#
admin.ls <- function() {
  v <- ps_get_all()
  cat("\014") # Clear screen
  cat("Practice sets:", str_trim(length(v)), "\n")
  if (length(v) == 0) {
    cat("   No practice sets loaded\n")
    return(TRUE)
  }
  for (k in 1:length(v)) {
    ps <- ps_get_by_short(v[k])
    num_prompts <- length(ps$task_list)
    t <- sprintf("%2d", k)
    cat(paste0(t, ": [", v[k], "]: ", ps$ps_title, " (Prompts: ", num_prompts, ")\n"))
  }
  return(TRUE)
}

#' List practice set objects
#'
#' Intended for teaching assistants and instructors only, \code{admin.run()}
#' executes all of the code for the practice set, \code{short}. Use this
#' function to test the practice set and to see that it is set-up
#' correctly.
#'
#' @param short for the short name of the practice set
#'
#' @export
#----------------------------------------------------------------------------#
# List all the variable names that are current alive in the practice set
#----------------------------------------------------------------------------#
admin.run <- function(short) {
  id <- ps_get_id_by_short(short)
  if (id == -1) {
    message(paste0("Error. Practice set not found (", short, ")"))
    return(FALSE)
  }
  ps_set_current(id)

  cat("\014")
  cat("admin.run()\n")
  cat(
    "Short ID: ", short, "\n",
    sep = ""
  )

  # Clear the learner and expected code environments
  clear_all_envirs()

  # Initialize the pre-set variables
  initialize_static_vars()

  # Show the preset variables
  preset_vars <- ps_get_env_vars()
  cat("Preset Variables:\n")
  if (length(preset_vars) > 0) {
    for (k in 1:length(preset_vars)) {
      cat("   ", preset_vars[k], "\n", sep = "")
    }
  } else {
    cat("   None.\n")
  }

  # Show callback evaluation functions (if any)
  cat("Callbacks loaded (see checks.R):\n")
  any <- 0
  v <- ps_get_all_assignment_vars()
  if (length(v) > 0) {
    for (k in 1:length(v)) {
      if (is_callback_loaded(v[k])) {
        cat("   ", k, ":CALLBACK: ", get_callback_name(v[k]), "(internal_id, result)\n", sep = "")
        any <- any + 1
      }
    }
  }
  if (any > 0) {
    cat("   Number:", any)
  } else {
    cat("   None.")
  }
  cat("\n")

  # Show the expected code for this practice set
  t <- ps_get_all_expected_code()
  if (length(t) > 0) {
    cat("Code:\n")
    for (k in 1:length(t)) {
      # cat("[", k, "] ", t[k], "\n", sep = "")
      cat("   ", t[k], "\n", sep = "")
    }
  } else {
    cat("\nCode:\n")
    cat("   None.\n")
  }

  # Show the "copy" variables (variables to copy from learner's
  # code environment to expected code environment)
  v <- ps_get_all_cp_vars()
  if (length(v) > 0) {
    cat(
      "\n\nVariables to copy: \n",
      sep = ""
    )
    cp_vars <- ps_get_all_cp_vars()
    for (k in 1:length(cp_vars)) {
      cat("   ", cp_vars[k], "\n", sep = "")
    }
  } else {
    cat(
      "Variables to copy:\n   None.\n",
      sep = ""
    )
  }

  # Evaluate the code and show the variables and values
  cat("\n",
    "Environment: pinfo201.expected_env\n",
    sep = ""
  )
  cat(sprintf("%-20s %-10s %-80s\n", "Variable", "Type", "Value"))

  results <- eval_code_expected(t, FALSE)
  if (!is.null(results)) {
    for (r in results) {
      out <- sprintf("%-20s %-10s %-60s\n", r$vname, r$vtype, r$vstr)
      cat(out)
    }
  } else {
    stop("admin.run(): eval_code_expected FAILED")
  }
}

#' Evaluate a directory of practice sets
#'
#' Intended for teaching assistants and instructors only, \code{admin.grade()},
#' this function will grade all of the practice sets within a directory.
#' That is, it will check student code against expected code and produce
#' a reports - currently, one report for each student assignment.
#'
#' This reports are placed within a sub-folder, named `results`.
#'
#' @param filename either a directory for a particular file
#'
#' @export
admin.grade_fn <- function(filename) {
  cResultsDir <- "results"
  if (!file.exists(filename)) {
    stop(paste0("Directory does not exist.\n", dir, ""), sep = "")
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

  results_dir <- paste0(dir, "/", cResultsDir)
  if (dir.exists(results_dir)) {
    unlink(results_dir)
  }
  dir.create(results_dir)

  cat("\014admin.grade()\n") # Clear screen
  cat(
    "Directory: ", dir, "\n",
    "Student work: ", filename, "\n",
    "Summary:\n",
    sep = ""
  )

  out <- ""

  t <- sprintf("%-20s %-20s %-15s %-15s", "Filename", "Name", "Summary", "Wrong Answers (internal ids)\n")
  cat("        ", t, sep = "")
  out <- paste0(out, "     ", t)

  for (k in 1:length(file_list)) {

    # Get the learners code from a file
    code_v <- readLines(file_list[k])
    code_string <- paste0(code_v, collapse = "\n")

    # Check the answers and get the results
    result <- check_answers(code_v)
    t <- format_grading(result)

    # Write grading results
    ps_feedback_fn <- str_replace(file_names[k], ".R", ".html")
    ps_feedback_fn_abs <- paste0(dir, "/results/", ps_feedback_fn)
    fileConn <- file(ps_feedback_fn_abs, "w")
    writeLines(t, fileConn)
    close(fileConn)

    # Collect some basic feedback
    wrongs <- paste0(result$incorrect_v, collapse = " ")

    t <- sprintf(
      "%-20s %-20s %-15s %-15s",
      file_names[k],
      paste0(result$user_name, "(", result$uwnetid, ")"),
      paste0(
        result$num_correct, " of ",
        (result$num_incorrect + result$num_correct)
      ),
      wrongs
    )
    cat("[", k, "]\t", t, "\n", sep = "")

    t_out <- sprintf(
      "<a href=\"./%s\">%-20s</a> %-20s %-15s %-15s",
      ps_feedback_fn,
      ps_feedback_fn,
      paste0(result$user_name, "(", result$uwnetid, ")"),
      paste0(
        result$num_correct, " of ",
        (result$num_incorrect + result$num_correct)
      ),
      wrongs
    )


    out <- paste0(out, "[", k, "]  ", t_out, "\n", sep = "")
  }

  # Build output for an index.html file
  out <- paste0(
    "<!DOCTYPE html>\n",
    "<html>\n",
    "<head></head>\n",
    "<body>\n",
    "<pre>\n",
    paste0(
      "admin.grade()\n",
      "Date:        ", date(), "\n",
      "Assignments: ", dir, "\n",
      "Results:     ", results_dir, "\n"
    ),
    "</pre>\n",
    "<pre>\n",
    out,
    "</pre>\n",
    "</body>\n",
    "</html>"
  )

  # Save index.html file
  index_fn <- paste0(dir, "/", cResultsDir, "/", "index.html")
  fileConn <- file(index_fn, "w")
  writeLines(out, fileConn)
  close(fileConn)

  cat("See graded work in:\n   ", index_fn, "\n", sep = "")
}

#' Grade all files in a folder
#'
#' Intended for teaching assistants and instructors only, this function allows
#' you to select a folder and grade all files within this folder.
#'
#' @export
admin.grade <- function() {
  t <- rstudioapi::selectDirectory(
    caption = "Select a Directory of Files to Grade",
    label = "Select",
    path = paste0(getActiveProject(), "/inst/extdata")
  )

  if (is.null(t)) {
    return(FALSE)
  } else {
    return(admin.grade_fn(t))
  }
}

#' Grade a single file
#'
#' Intended for teaching assistants and instructors only, this function allows
#' you to select a single file and grade it.
#'
#' @export
admin.grade_ui_file <- function() {
  t <- rstudioapi::selectFile(
    caption = "Select an Answer File to Grade",
    label = "Select",
    filter = "R Files (*.R)",
    path = paste0(getActiveProject(), "/inst/extdata/answers")
  )

  if (is.null(t)) {
    return(FALSE)
  } else {
    return(admin.grade_fn(t))
  }
}

#' Show the practice set prompts
#'
#' Intended for teaching assistants and instructors only, \code{admin.prompts()}
#' shows the prompts and expected answers in a practice set. The output is
#' R code showing the correct answers.
#'
#' @param short for the short name of the practice set
#'
#' @export
#----------------------------------------------------------------------------#
# List the prompts and some basic information for a practice set
#----------------------------------------------------------------------------#
admin.prompts <- function(short) {
  id <- ps_get_id_by_short(short)
  if (id == -1) {
    message(paste0("Error. Practice set not found (", short, ")"))
    return(FALSE)
  }
  ps_set_current(id)
  cat("\014") # Clear screen
  cat(format_practice_script(TRUE))
  return(TRUE)
}

#' Generates the answer files and
#'
#' Intended for teaching assistants and instructors only, \code{admin.gen_answers()}
#' creates answer files for all loaded practice sets and stores the answers in
#' a directory.
#'
#' @param dir_path the direct into which answer files are to be saved

#' @export
admin.gen_answers <- function(dir_path) {
  if (!dir.exists(dir_path)) {
    dir.create(dir_path)
  }
  cat("\014") # Clear screen
  cat("admin.gen_answers()\n")
  cat("Writing answers to these files: ")

  v <- ps_get_all()
  if (length(v) > 0) {
    for (k in 1:length(v)) {
      id <- ps_get_id_by_short(v[k])
      ps_set_current(id)
      t <- format_practice_script(TRUE)
      fname <- paste0(dir_path, "/", v[k], ".R")
      cat("   ", fname,"\n")
      fileConn <- file(fname, "w")
      writeLines(t, fileConn)
      close(fileConn)
    }
  }
  cat("Done.\n")
  return(TRUE)
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
admin.check <- function(filename, silient = FALSE, detailed = FALSE) {
  check_file_integrity(filename, silient, detailed)
  return(TRUE)
}

#' Load practice sets into the package
#'
#' Intended for teaching assistants and instructors only, \code{admin.load()}
#' is used to load practice sets. All practice sets that are found in the
#' the directory, \code{dir}, are loaded into the package. (Default practice
#' sets are automatically added. These defaults are installed when the
#' package is installed.)
#'
#' @param dir a directory
#' @export
#'
admin.load <- function(dir) {
  if (!dir.exists(dir)) {
    message(paste0("Directory does not exist.\n", dir, ""), sep = "")
    return(TRUE)
  }

  file_list <- c()
  file_names <- c()

  file_list <- list.files(dir, pattern = "*.R", full.names = TRUE)
  file_names <- list.files(dir, pattern = "*.R")

  cat("\014admin.load_ps()\n") # Clear screen
  cat(
    "Directory: ", dir, "\n",
    "Summary:\n",
    sep = ""
  )

  for (k in 1:length(file_list)) {
    fname <- file(file_list[k])
    ps <- read_ps_doc(fname)
    ps$ps_filename <- fname
    ps <- check_ps(ps)
    ps_add(ps)
    cat("Added: ", ps$ps_short, "(", fname, ").\n")
  }
}
