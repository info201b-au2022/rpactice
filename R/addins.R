#----------------------------------------------------------------------------#
# These wrappers are needed to get the Addins shown in the correct order
# in RStudio.  I've not found another way stipulate a desired ordering.
#
# The addins are installed in this file:
#     inst/rstudio/addins.dcf
#----------------------------------------------------------------------------#
addin.a <- function() {
  ui_begin()
}

addin.b <- function() {
  results <- check_answers_from_ui()
  if (!is.null(results)) {
    t <- format_result(results)
    print_output(t, "check")
  }
  return(TRUE)
}

addin.c <- function() {
  practice.questions()
}

addin.d <- function() {
  practice.answers()
}
