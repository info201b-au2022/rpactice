
# Addins ----
#----------------------------------------------------------------------------#
# The add-in functions for controlling the presentation of the practice
# sets
#----------------------------------------------------------------------------#

#' Begin a practice set
#'
#' Call this function to install a specific practice
#' set and to set things up. Currently, there are two practice sets -
#' "P01" and "P02".
#'
#' @param short The short ID for this practice set.
#' @param learner The learner's name
#' @return `TRUE` if all goes well; otherwise, this function will stop with an message.
#'
#' @export
practice.begin <- function(short = "P01", learner="Anonymous", uwnetid="") {
  id <- ps_get_id_by_short(short)
  if (id == -1) {
    stop(paste0("Can't find practice set named ", short, " (id=", id, ")."))
  }

  # Set the current practice set ID
  ps_set_current(id)

  # Currently, no session information, so just a global variable
  pkg.globals$gUSER_NAME <- learner
  pkg.globals$gUWNETID <-uwnetid

  return(TRUE)
}

#' Show questions for a practice set
#'
#' @param do_not_show optional list of internal IDs of questions to not show
#' @return `TRUE` if all goes well.
#' @export
practice.questions <- function(do_not_show = NULL) {
  ps <- ps_get_current()
  t <- format_prompts(do_not_show)
  print_output(t, "questions")
  return(TRUE)
}

#' Evaluate a practice set and provide feedback
#'
#' @return `TRUE` if all goes well; otherwise, this function will stop with an message.
#' @export
practice.check <- function() {
  results <-  check_answers_from_ui()
  t <- format_result(results)
  print_output(t, "check")
  return(TRUE)
}

#' Show  the answers for the practice set
#'
#' @export
practice.answers <- function() {
  ps <- ps_get_current()
  t <- format_answers()

  t <- paste0(
    "<b>", ps$ps_short, ": ", ps$ps_title, ": Answers</b>\n",
    ps$ps_descr, "\n",
    "---\n",
    t
  )
  print_output(t, "anwers")
  return(TRUE)
}

#' Read and load a practice set into RStudio
#'
#' @param fn The url for the practice set
#' @export
practice.load_url <- function(fn = paste0(
  "https://raw.githubusercontent.com/",
  "info201B-2022-Autumn/practice-sets/main/",
  "PS-T10.R"
)) {
  ps <- create_ps_from_url(fn)
  ps_add(ps)
  return(TRUE)
}
