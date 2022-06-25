# The function returns the left- and right-hand side of an assignment
# statement. For parsing errors, the function returns an empty list.
#
# In each of these cases, "t" is the lft  (see test-eval.R)
#    "t <- 1"
#    "t <- s <- 1"
#    "s <-1; t <- 1"
#    "s <-1\n t <- 1"
#    "t <- function(a,b) {p <- 10; s <-100}"
#    "t <- { s <- 1}"

get_var_name <- function(s) {
  tryCatch(
    expr = {
      list_e <- as.list(parse(text = s))
      e <- list_e[[length(list_e)]]
      if (length(e) == 3) {
        if (as.character(e[[1]]) == "<-") {
          return(list(lhs = as.character(e[[2]]), rhs = e[[3]]))
        }
      }
    }, error = function(e) {
      return(list())
    }
  )
  return(list())
}

parse_script <- function(code_v) {
  t <- as.list(parse(text = code_v))
  return(t)
}

show_ast <- function(expressions_v, k) {
  print(as.list(expressions_v[[k]]))
  ast(!!expressions_v[[k]])
}

show_as_string <- function(expressions_v, k) {
  return(deparse(expressions_v[[k]]))
}

walk2 <- function(e, level = 1) {
  t <- str_sub("...............", 1, (level - 1) * 2)
  if (rlang::is_syntactic_literal(e)) {
    cat(paste0(t, " ", "(constant: '", as.character(e), "')\n"), sep = "")
    return(TRUE)
  } else if (rlang::is_symbol(e)) {
    if (as.character(e) == "<-") {
      cat(paste0(t, " ", "(<-: '", as.character(e), "')\n"), sep = "")
    }
    level <- level + 1
    for (k in 1:length(e)) {
      cat(paste(t, "walk"))
      walk2(e[[k]], level)
    }
  }
  return(TRUE)
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
1 * 10
+ f(10,101)

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
