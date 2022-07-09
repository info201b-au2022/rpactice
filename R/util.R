# AST functions ----
# This function returns a vector of the line numbers, where each statement matches
# a particular function call. It can be used to answer questions such as:
#
#   1. Find all assignment statements -- ast_scan (e, "<-", TRUE)
#   2. Find all print or cat statements -- ast_scan(e, c("print", "cat"), TRUE)
#
# When the argument in_statement is FALSE, the function  will return all line numbers that
# do NOT satisfy the condition.
#
# Example:
#   t <- "m<-1; print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- 1; print('hello')"
#   ast_scan(parse(text=t))
#   2 3 4 6
ast_scan <- function(e, s, in_statement = TRUE) {
  lines_true <- c()
  lines_false <- c()

  # print(">>>>>>")
  # print(s)
  # print(str(e))
  # print(">>>>>")

  if (length(e) > 0) {
    for (k in 1:length(e)) {
      if (length(e[[k]]) > 0) {
        if (as.character(e[[k]][[1]]) %in% s) {
          lines_true <- append(lines_true, k)
        } else {
          lines_false <- append(lines_false, k)
        }
      }
    }
  }

  if (in_statement) {
    return(lines_true)
  } else {
    return(lines_false)
  }
}

# All statements denoted by the line numbers in x will be removed and a
# new expression will be returned
ast_rm <- function(e, x) {
  e1 <- list()
  if (length(e) > 0) {
    for (k in 1:length(e)) {
      if (!(k %in% x)) {
        e1 <- append(e1, e[k]) # Check: Why not [[k]] here?
      }
    }
  }
  return(e1)
}

# In a block of code, return all assignment statements
ast_get_assignments <- function(e1) {
  result <- list()

  if (is.null(e1)) {
    return(result)
  }

  line_nums <- ast_scan(e1, "<-", FALSE)
  e2 <- ast_rm(e1, line_nums)

  for (k in 1:length(e2)) {

    # This is the usual case: x <- val -- we want to return x
    var_name <- e2[[k]][[2]]
    e_t <- e2[[k]][[3]]

    # For these sub-select cases, we need to return X:as
    #    X[blah] <- val
    #    X$blah% <- val
    #    X[[blah]] <- val
    if (length(e2[[k]][[2]]) > 2) {
      if (e2[[k]][[2]][[1]] == "[" ||
          e2[[k]][[2]][[1]] == "[[" ||
          e2[[k]][[2]][[1]] == "$") {
        var_name <- e2[[k]][[2]][[2]]
        e_t <- e2[[k]][[3]]
      }
    }

    t <- list(r = list(lhs = deparse(var_name), rhs = deparse(e_t), e = NULL))
    result <- append(result, t)
  }
  return(result)
}

ast_get_begin2 <- function(e1) {
  line_nums <- ast_scan(e1, "practice.begin")
  if (length(line_nums) == 0) {
    return(NULL)
  }

  begin_expr <- e1[[line_nums[length(line_nums)]]]
  if (length(begin_expr) == 0) {
    return(NULL)
  }
  else {
    return(begin_expr)
  }
}

ast_get_begin <- function(e1) {
  line_nums <- ast_scan(e1, "practice.begin")
  if (length(line_nums) == 0) {
    return(list())
  }

  begin_expr <- e1[[line_nums[length(line_nums)]]]
  if (length(begin_expr) == 0) {
    return(list())
  }


  e2 <- ast_rm(e1, line_nums)


  for (k in 1:length(e2)) {
    t <- list(r = list(lhs = deparse(e2[[k]][[2]]), rhs = deparse(e2[[k]][[3]]), e = e2[[k]][[3]]))
    result <- append(result, t)
  }
  return(result)
}

# In a block of code, return the last assignment statement
ast_last_assignment <- function(e1) {
  r <- ast_get_assignments(e1)
  k <- length(r)
  if (k != 0) {
    return(r[[k]])
  } else {
    return(list())
  }
}

# t <- parse(text="t<-(a+b) / (c+d); print(0); u <- t[(a+b)/(c+d)]")
# walk2(t)
# Find all assignments at level-1
# Choose the last assignment
ast_walk <- function(e, level = 1) {
  t <- str_sub("...............", 1, (level - 1) * 2)
  if (rlang::is_syntactic_literal(e)) {
    cat(paste0(t, " ", "(constant: '", as.character(e), "')\n"), sep = "")
    return(TRUE)
  } else if (rlang::is_symbol(e)) {
    if (as.character(e) == "<-") {
      cat(paste0(t, " ", "(Got: '", as.character(e), "')\n"), sep = "")
      return(TRUE)
    } else if (as.character(e) == "print") {
      cat(paste0(t, " ", "(Got:", as.character(e), ")\n", sep = ""))
      return(TRUE)
    } else {
      cat(paste0(t, " ", "('", as.character(e), "')\n", sep = ""))
      return(TRUE)
    }
  }
  cat(paste(t, "walk\n"))
  level <- level + 1
  for (k in 1:length(e)) {
    ast_walk(e[[k]], level)
  }
  return(TRUE)
}


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



ast_test <- function() {
  t <-
    "
t <- 1
u <- 2; v <-3
cat(t, u)
w<- x <- 4
y<-5
"
  e <- parse(text = t)
  r <- ast_get_assignments(e)
  print(r)


  return(TRUE)
}


ast_code <- function() {
  t <- parse(text = "t<-(a+b) / (c+d); print(g(x,b)); cat(10, 'aaa'); print('aa'); u <- t[(a+b)/(c+d)]; print('hello')")
  return(t)
}


get_example_script <- function() {
  script <- readLines(
    textConnection(
      "

# Answers to P01

practice.begin(\"P01\", learner=\"Anonymous\")

X <- 10
Y <- c(1,2,3)

# a: Add ten, nine, and eight together. (t_01)
t_01 <- 10 + 9 + 8

# b: What is 111 divided by 9? (num)
num <- 111 / 9 + 10 -
1 * 10 +
f(10,101)

#b.a
t_01a <- t_01 <- 1 + 2

t_01b <- 1; t_01c <- t_01b + 1

# c: What is the average of 1, 17, 19, and 31? (t_03)
t_03 <- (1 + 17 + 19 + 31) / 4

# d: What is the average of these Celsius temperatures: -5C, -10C, -12C (t_04)
t_04 <- (-5 + -10 + -12) / 3

# e: Use the exponent operator (^ or **) to compute 2 to the 20th power. (t_05)
t_05 <- 2^20

# f: What is 3.4 cubed? (t_06)
t_06 <- 3.4**3

# g: Compute the reciprocal 2 to 8th power (2^(-8) or 1 / 2^8). (t_07)
t_07 <- 2^-8

# h: Use the modulus operator (%%) to compute the remainder of 111 divided by 4. (t_08)
t_08 <- 111 %% 4

# i: Use integer division (%/%) to compute the quotient of 111 divided by 3. (t_09)
t_09 <- 111 %/% 3

# j: In R, pi is a built-in constant (3.141593). Given a circle with radius 4 (r),
#    what is its area? (Recall: A = pi*r^2) (A)
A <- pi * 4^2

# k: In R, Inf means 'positive infinity.' What is 7 / 0? (t_10)
t_10 <- 7 /0

# l: In R, -Inf means 'negative infinity.' What is -7 / 0? (t_11)
t_11 <- -7 / 0

# m: In R, NaN means 'Not a Number'. What is 0 / 0? (t_12)
t_12 <- 0 / 0

library(xxxx)
"
    )
  )
  return(script)
}

parse_script <- function(code_v) {
  t <- as.list(parse(text = code_v))
  return(t)
}

show_ast <- function(expressions_v, k) {
  print(as.list(expressions_v[[k]]))
  lobstr::ast(!!expressions_v[[k]])
}

show_as_string <- function(expressions_v, k) {
  return(deparse(expressions_v[[k]]))
}
