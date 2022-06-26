#' pinfo201
#'
#' \code{pinfo201} refers to \emph{practice for INFO-201}. INFO-201 is an
#' introduction to data science at the University of Washington, a class originally
#' developed by Mike Freeman and Joel Ross.
#' See \url{https://ischool.uw.edu/news/2018/12/ischools-freeman-and-ross-publish-textbook-informatics-classes}.
#'
#' \code{pinfo201} is a package for practicing basic R programming. It is intended for
#' learners who are just beginning. In addition, \code{pinfo201} provides functions
#' for grading student work.
#'
#' @section Practice sets: The key idea is that an instructor creates a practice
#'   set, which comprises prompts, expected answers, and hints. Once \code{pinfo201} is
#'   installed, practice sets are loaded into RStudio and can be controlled with
#'   four Addin menu options:
#'   \itemize{
#'   \item 1. Begin Practice
#'   \item 2. Show Prompts
#'   \item 3. Check Answers
#'   \item 4. Show Answers}
#'
#'   Learners select from the available practice sets (\code{1. Begin Practice}).
#'   They write code for one or more of the prompts. Then, the learner's code
#'   can be checked against the expected code
#'   (\code{3. Check Answers}). When the learner's answer differs from the expected
#'   answer, zero or more hints are shown.
#'
#'   Instructors write practice sets in in \code{.R} files, with tagged comments.  Below
#'   is a practice set with four illustrative prompts:
#'
#'   \preformatted{
#'   #' @version ps-1
#'   #' @short PS-Example
#'   #' @title Example practice set
#'   #' @descr
#'   #' An example that illustrates the essentials of practice sets.
#'   #' @end
#'   #' @initial-vars
#'   library(dplyr)
#'   X <- c(1,2,3)
#'   cDF <- data.frame(A=c(1,2,3,4), B=c('a','b','c','d'), C=c(T,F,T,T))
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
#'   #' @id c
#'   #' @msg Create a function that squares a number
#'   #' @var squared
#'   #' @check c(1, 2, 3, 0, -1, -2, -3, NA)
#'   #' @code
#'   squared <- function(x) {
#'   t <- x^2
#'   return(t)
#'   }
#'   #' @end
#'
#'   #' @id ?
#'   #' @msg Select rows from cDF, where C==TRUE. Show only A and C columns.
#'   #' @code
#'   #' df4 <- cDF %>%
#'   #' filter(C==TRUE) %>%
#'   #' select(A,C)
#'   #' @end
#'
#'   #' @id -
#'   #' @msg Next: Consider reading up on built-in mathematical functions.
#'
#' }
#' Practice sets have a title and an unique identifier (\code{short}), which is
#' a short form for referring to a practice set. Optionally, one or more
#' variables can be initialized with the \code{initial-vars} tag. The idea is
#' that the prompts can require learners to use those variables. As can be seen
#' in the example, you can can also load any required libraries.
#'
#'   The prompts comprise a unique ID, a message (the prompt), the expected answer,
#'   and a list of hints. If an \code{id} is "?" a set of unique IDs will be automatically
#'   generated, which simplifies the development of prompts. If an \code{id}
#'   is a dash ("-"), a message is formatted. This is a simple method for
#'   guiding students through the prompts.
#'
#'   In addition, the \code{@checks} tag (see prompt id "c")
#'   can be used to check the implementation of a function. More complex function
#'   checking is possible by implementing prompt-specific callback functions (see below).
#'
#'   That's it.
#'
#'   #' @section Auto-grading:
#'
#'   Practice sets contain the correct answers to prompts.  Thus, if the practice set
#'   is a graded assignment, \code{pinfo201} can be used to automatically grade the
#'   assignment. Administrative functions are provided for this work - for example, this
#'   function will grade all assignments, named \code{short}, that are located in the
#'   directory, \code{dir}. Currently, the output is one html file for each assignment,
#'   summarizing all correct and incorrect problems.
#'
#'   \preformatted{
#'   admin.grade(short, dir)
#'   }
#'
#'   Other admin functions are used to assist in the development of practice sets.
#'
#' @section What can be evaluated?:
#'
#' Currently, \code{pinfo201} can evaluate statements with the following result types:
#' \itemize{
#' \item Special constants (NULL, NA, Inf, -Inf, and NaN)
#' \item Atomic vectors (logical, integer, real, complex, string)
#' \item Vectors greater than length 1 (comprising logical, integer, real, complex, and string types)
#' \item Data frames
#' \item Functions  (functions with one argument can be automatically checked with the @checks tag)
#' }
#'
#' @section Checking callbacks:
#'
#' We plan to build in robust default approaches for evaluating expressions and giving
#' learners feedback. To do so, we are currently exploring how to structure
#' this package. At present, the framework can be extended with prompt-specific callback functions
#' for checking a learner's code by. This is the current structure of
#' the checking callbacks:
#'
#'\preformatted{
#'   <funct_name>_Check <- function(internal_id, result) {
#'     learner_result <- eval_string_details(ps_get_assignment_var(internal_id))
#'     expected_result <- eval_string_details(ps_get_expected_answer(internal_id))
#'
#'     # Analyze learner's code (e.g., with an abstract syntax tree) and add feedback
#'     # to the result
#'     #     add.message(result, message)
#'
#'     if (identical(learner_result, expected_result)) {
#'       result <- result_update(result, internal_id, TRUE, result_good_msg(internal_id))
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

#' @import rstudioapi
NULL

#' @import shiny
NULL

#' @import stringr
NULL

#' @import tidyverse
NULL
