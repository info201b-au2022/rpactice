#' pinfo201
#'
#' \code{pinfo201} refers to \emph{practice for INFO-201}. INFO-201 is an
#' introduction to data science at the University of Washington, a class originally
#' developed by Mike Freeman and Joel Ross.
#' See \url{https://ischool.uw.edu/news/2018/12/ischools-freeman-and-ross-publish-textbook-informatics-classes}.
#'
#' \code{pinfo201} is a package for practicing basic R programming. It is intended for
#' learners who are just beginning. In addition, \code{pinfo201} provides functions
#' for efficiently grading student work.
#'
#' @section Practice sets: The key idea is that an instructor creates a practice
#'   set, which comprises prompts, expected answers, and hints. Once \code{pinfo201} is
#'   installed, practice sets are loaded into RStudio and can be controlled with an
#'   Addins menu. The \code{pinfo201} menu includes these options:
#'   \itemize{
#'   \item 1. Begin Practice
#'   \item 2. Check Answers
#'   \item 3. Show Prompts
#'   \item 4. Show Answers}
#'
#'   Learners select from the available practice sets (\code{1. Begin
#'   Practice}). They write code for one or more of the prompts. When ready,
#'   learners check their code (\code{2. Check Answers}). If the learner's answer
#'   differs from the expected answer, hints, if available, are shown.
#'
#'   Instructors write practice sets in \code{.R} files, with tagged comments. Here
#'   is a practice set, with six illustrative prompts:
#'
#'   \preformatted{
#'   #' @version ps-1
#'   #' @short PS-Example
#'   #' @title Example practice set
#'   #' @descr
#'   #' This file illustrates the essentials of specifying a practice set. It is
#'   #' intended to informally show what kinds of prompts can be presented to
#'   #' students and what kind of testing can be accomplished.
#'   #' @end
#'   #' @initial-vars
#'   library(dplyr)
#'   X <- c(1,2,3)
#'   cDF <- data.frame(A=c(1,2,3,4), B=c('a','b','c','d'), C=c(T,F,T,T))
#'   #' @end
#'
#'   #' @id a
#'   #' @msg Add ten, nine, and eight together. Assign the result to `sum1`.
#'   #' @code
#'   sum1 <- 10 + 9 + 8
#'   #' @end
#'   #' @hints
#'   #' Do you use the math plus operator (+)?
#'   #' Do you use the assignment operator (<-)?
#'   #' Is the expected variable name (sum1) used?
#'   #' @end
#'
#'   #' @id b
#'   #' @msg Add 10 to each of the elements of vector `X`.
#'   #' @code
#'   v1 <- X + 10
#'   #' @end
#'
#'   #' @id -
#'   #' @msg Working with functions.
#'
#'   #' @id c
#'   #' @msg Write a function, named `what_is_pi`, which returns pi (3.1415).
#'   #' @var what_is_pi
#'   #' @code
#'   what_is_pi <- function() {
#'      pi
#'   }
#'   #' @end
#'
#'   #' @id d
#'   #' @msg Write a function, named `squared(x)`, which squares a number.
#'   #' @var squared
#'   #' @check list(arg1 = c(1, 2, 3, 0, -1, -2, -3, NA))
#'   #' @code
#'   squared <- function(x) {
#'      t <- x^2
#'   return(t)
#'   }
#'   #' @end
#'
#'   #' @id e
#'   #' @msg
#'   #' Define a function, named `imperial_to_metric`, that takes in two arguments: a
#'   #' number of feet and a number of inches. The function should return the
#'   #' equivalent length in meters.
#'   #' @end
#'   #' @check list(arg1 = c(4, 5, 100, 0, NA), arg2 = c(0, 1, 1.5, 12.0, 24))
#'   #' @code
#'   imperial_to_metric <- function(feet, inches) {
#'      total_inches <- feet * 12 + inches
#'      meters <- total_inches * 0.0254
#'      meters
#'   }
#'   #' @end
#'
#'   #' @id -
#'   #' @msg Working with dataframes
#'
#'   #' @id f
#'   #' @msg Select rows from cDF, where C==TRUE. Show only A and C columns.
#'   #' @code
#'   df4 <- cDF %>%
#'      filter(C==TRUE) %>%
#'      select(A,C)
#'   #' @end'
#' }
#'
#' Practice sets have a title and an identifier (\code{short}), which is a short
#' form for referring to a practice set. These short identifiers must be unique.
#' Optionally, one or more variables can be initialized with the
#' \code{initial-vars} tag. Here, the idea is that prompts can require learners
#' to use those variables. As can be seen in the example, specific libaries can
#' also be loaded.
#'
#' The prompts comprise a unique ID, a message (the prompt), the expected
#' answer, and a list of hints. If an \code{id} is "?" a set of unique IDs
#' will be automatically generated, which simplifies the development of
#' prompts. If an \code{id} is a dash ("-"), a message is formatted. This is a
#' simple method for guiding students through the prompts.
#'
#' In addition, the \code{@checks} tag (see prompt id "d" and "e") can be used to
#' check the implementation of a function. Currently, practice sets can ask
#' learners to create functions with zero, one, or two arguments. For functions
#' with two parameters, the function is tested on all combinations of
#' inputs, \code{arg1} and \code{arg2}.
#'
#' More complex function checking, including checking functions with three or
#' more arguments, is possible by implementing prompt-specific callback
#' functions (see below).
#'
#' Basically, that's it.
#'
#' One limitation: This package is oriented toward checking data values.
#' Currently, \code{pinfo201} does not model the structure of student's code nor
#' its execution. For example, the package cannot be used evaluate the
#' correctness of a task like this: \preformatted{ Use cat() to output two
#' variables a and b}. It can, however, be used to evaluate the following:
#' \preformmated{Create a string out of the two variables, a and b, and assign
#' the string to output.} This said, the building blocks are in place for
#' analyzing a student's code through abstract syntax trees -- this is an area
#' of interest.
#'
#' @section Auto-grading:
#'
#'   Practice sets contain the correct answers to prompts. Thus, if the practice
#'   set is a graded assignment, \code{pinfo201} can be used to automatically
#'   grade the assignment. This administrative function, for example, will grade
#'   all assignments that are located in the directory, \code{dir}:
#'
#'   \preformatted{
#'   admin.grade(dir)
#'   }
#'
#'   Currently, the output is one \code{.html} file per student \code{.R} file, with
#'   each output file summarizing correct and incorrect solutions.
#'
#'   Other admin functions are used to assist in the development of practice sets.
#'
#' @section What can be evaluated?:
#'
#' Currently, \code{pinfo201} is able to check the following data types:
#' \itemize{
#' \item Special constants (NULL, NA, Inf, -Inf, and NaN)
#' \item Atomic vectors (scalars) (logical, numeric, integer, complex, charactter types)
#' \item Vectors greater than length 1 (comprising logical, numeric, integer, complex, and character types)
#' \item Lists -- TBD
#' \item Data frames
#' \item Functions with zero, one, or two unnamed arguments (with the @check tag)
#' }
#'
#' @section Checking callbacks:
#'
#' At present, the framework can be extended with prompt-specific callback
#' functions for checking a learner's code, although this takes a good deal of
#' effort. Thus, if you need to test a function with 3 or more parameters or
#' test a data structure in some specific ways, you can write a checking
#' callback function. This is the current structure of the checking callbacks:
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
