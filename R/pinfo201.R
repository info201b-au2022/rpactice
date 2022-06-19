#' pinfo201
#'
#' \code{pinfo201} refers to \emph{practice for INFO-201}. INFO-201 is an
#' introduction to data science at the University of Washington, a class originally
#' developed by Micheal Freeman and Joel Ross. See Xxx.
#'
#' ' \code{pinfo201} is a package for practicing basic R programming. The focus is
#' on learners who are just beginning. In addition, \code{pinfo201} is intended
#' to be used for grading student work.
#'
#' @section Practice sets: The key idea is that an instructor creates a practice
#'   set, which comprises prompts, expected answers, and hints. Practice sets are
#'   loaded into RStudio and controlled with four Addin menu options:
#'   \itemize{
#'   \item 1. Begin Practice
#'   \item 2. Show Prompts
#'   \item 3. Check Answers
#'   \item 4. Show Answers}
#'
#'   Learners select from the available practice sets (\code{1. Begin Practice}).
#'   They write code for one or more of the prompts. The learner's code
#'   responses are evaluated and checked against the expected answers
#'   (\code{3. Check Answers}). If the learner's answer differs from the expected
#'   answer, zero or more hints are shown. Learners can also ask for the answers
#'   to be shown (\code{4. Show Answers}).
#'
#'   Practice sets are written in \code{.R} files, with tagged comments.  Below
#'   is a practice set with two prompts.
#'
#'   Practice sets have a title and an unique identifier (\code{short}), which
#'   is a short form for referring to a practice set. Optionally, one or more
#'   variables can be initialized with the \code{initial-vars} tag. The idea is
#'   that the prompts can require learners to use those variables.
#'
#'   The prompts comprise a unique ID, a message (the prompt), the expected answer,
#'   and a list of hints. If an \code{id} is "?" a set of unique IDs will be automatically
#'   generated, which simplifies the development of prompts. If an \code{id} is
#'   "-" (dash), a message is formatted for learners. This is a simple method for
#'   organizing the prompts and guiding students.
#'
#'   That's it. When a practice set consists of the correct answers to an assigned
#'   problem set, \code{pinfo201} turns into an auto-grader RStudio Addin.
#'
#'   \preformatted{
#'   #' @title Example practice set
#'   #' @short PS-Example
#'   #' @descr
#'   #' An example that illustrates the essentials of practice sets.
#'   #' @end
#'   #' @initial-vars
#'   X <<- c(1,2,3)
#'   #' @end
#'
#'   #' @id a
#'   #' @msg Add ten, nine, and eight together.
#'   #' @code
#'   sum1 <- 10 + 9 + 8
#'   #' @end
#'   #' @hints
#'   #' Do you use the math plus operator (+)?
#'   #' Do you use the assignment operator (<-)?
#'   #' Is the variable name (sum1) correct?
#'   #' @end
#'
#'   #' @id b
#'   #' @msg Add 10 to each of the elements of vector X
#'   #' @code
#'   v1 <- X + 10
#'   #' @end
#'
#'   #' @id -
#'   #' @msg Next: Consider reading up on the trig functions.
#'
#' }
#' @section What can be evaluated?:
#'
#' We are seeking to be able to evaluate results of the following
#' types:
#' \itemize{
#' \item Special constants (NULL, NA, Inf, -Inf, and NaN)
#' \item Basic atomic vectors (logical, integer, real, string)
#' \item Vectors greater than length 1
#' \item Data frames
#' }
#'
#' @section Checking callbacks:
#'
#' We are trying to build in robust default approaches - but the framework
#' also can be extended with specific callback functions for checking
#' a learner's code. In principle, code could be written to analyze
#' the abstract syntax trees of learners' code submissions.
#'
#' This is the current structure of the checking callbacks:
#'
#'\preformatted{
#'   circle_area_Check <- function(internal_id, learner_val, result) {
#'     expected_val <- eval(parse(text = ps_get_expected_answer(internal_id)))
#'
#'     # Analyze learner's code
#'
#'     if (learner_val == expected_val) {
#'       result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id)
#'     } else {
#'       result <- result_update(result, internal_id, FALSE, result_error_msg(internal_id))
#'    }
#'    return(result)
#'  }}
#'

#' @docType package
#' @name pinfo201
NULL

#' @import miniUI
NULL

#' @import stringr
NULL

#' @import shiny
NULL

#' @import rstudioapi
NULL
