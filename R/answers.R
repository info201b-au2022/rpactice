#----------------------------------------------------------------------------#
# Functions for extracting the learner's code from the script
#----------------------------------------------------------------------------#

get_answer <- function(answers, var_name) {
  print(answers)
  print(var_name)
  print("---------")
  for (a in answers) {
    if (a$var_name == var_name) {
      return (a$statement)
    }
  }
  return(NULL)
}

is_answer <- function(s) {
  var_names <- ps_get_all_assignment_vars()
  for (v in var_names) {
    if (str_detect(s, v)) {
      s <- str_trim(s)
      return(list(var_name=v, statement=s))
    }
  }
  return(NULL)
}

find_answers <- function(code) {
  t <- lapply(code, is_answer)
  t <- t[which(!sapply(t, is.null))]
  return(t)
}

process_script = function() {
  fn <- "~/Documents/_Code/practice-info201/working.R"
  script = readLines(fn)
  x = parse(fn)
  s <- deparse(x)
  s <- paste0(s,collapse="")
  v <- str_split(s,",")
  t <- find_answers(v[[1]])
  #print(t)
  return(t)
}
