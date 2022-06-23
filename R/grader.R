#----------------------------------------------------------------------------#
# Functions for automatically grading files
#----------------------------------------------------------------------------#

# Create practice set from a coded text file
code_to_grade <- function(fn) {
  if (file.exists(fn) == FALSE) {
    stop(paste0("File does not exist.\n", fn, ""))
  }
  code <- readLines(fn)
  return(code)
}


