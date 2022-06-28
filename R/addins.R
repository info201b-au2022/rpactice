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
  practice.check()
}

addin.c <- function() {
  practice.questions()
}

addin.d <- function() {
  practice.answers()
}
