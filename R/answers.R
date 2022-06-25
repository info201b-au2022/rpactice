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

library(rlang)
library(lobstr)


r_code <- function() {
 t <- c(
   "# A commment",
   "t <- 1",
   "x <- t + 1",
   "y <- x + 1"
 )
 return(t)
}

# expr()

# enexpr()
x <- expr("y <- 1 +2")
ast(!!x)

# ast

# !!

# parse -- from strings to expressions
e <-parse(text="y <- 1 + 2")
t <- as.list(e)
t


# Parse_expr
x <- "a <- 1; a + 1"
t <- rlang::parse_exprs(x)
t

# Base parse as list
x <- "a <- 1; a + 1"
t <- as.list(parse(text = x))
t

# rlang::expr_text()
x <- expr(y <- x + 10)
expr_text(x)

# eval

# quote
x <- quote(y <- 1 + 2)
ast(!!x)



expr_type <- function(x) {
  if (rlang::is_syntactic_literal(x)) {
    "constant"
  } else if (is.symbol(x)) {
    "symbol"
  } else if (is.call(x)) {
    "call"
  } else if (is.pairlist(x)) {
    "pairlist"
  } else {
    typeof(x)
  }
}

switch_expr <- function(x, ...) {
  switch(expr_type(x),
         ...,
  stop("Don't know how to handle type ", typeof(x), call. = FALSE)
  )
}

tryit <- function(x, ...) {
switch (x,
       a = "aaa",
       b = "bbb")
}


