test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

test_that("trim_comment - 1", {
  expect_equal(trim_comment("#' bhah   "), " bhah")
})

test_that("trim_comment - 2", {
  expect_equal(trim_comment("#'bhah"), "bhah")
})

test_that("trim_comment - 3", {
  expect_equal(trim_comment("#bhah"), "#bhah")
})

test_that("get_var_lhs - 1", {
  expect_equal(get_var_lhs("X<-f(xxx)"), "X")
})

test_that("get_var_lhs - 2", {
  expect_equal(get_var_lhs(" X   <-  f(xxx)"), "X")
})

test_that("get_var_lhs - 3", {
  expect_equal(get_var_lhs("<-  f(xxx)"), "")
})

test_that("get_var_lhs - 4", {
  expect_equal(get_var_lhs("f(xxx)"), NULL)
})

test_that("url read works", {
  url <- "https://raw.githubusercontent.com/info201B-2022-Autumn/practice-sets/main/PS-T10.R"
  expect_equal(RCurl::url.exists(url),TRUE)
  ps <- create_ps_from_url(url)
  expect_equal(ps$ps_short, "PS-T10")
  expect_equal(length(ps$task_list), 10)
})





create_ps_from_url

# A practice set with no prompts - a degenerate case: no prompt
s <-
"#' Practice Set Example
#' @short P03
#' @title This is a title
#' @descr
#' * Line 1: xxx
#' * Line 2: yyy
#' * Line 3: zzz
#' @end

"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])

test_that("parse_ps - 1", {
  expect_equal(ps$ps_short, "P03")
  expect_equal(ps$ps_title, "This is a title")
  expect_equal(length(ps$ps_descr),1)
})

# A practice set with no prompts - a degenerate case: very short
s <-
"
#' @short P03
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])

test_that("parse_ps - 2", {
  expect_equal(ps$ps_short, "P03")
  expect_equal(ps$ps_title, "")
  expect_equal(ps$ps_descr, "")
})

# A typical case
s <-
"
#' Practice Set Example
#' @short P03
#' @title This is a title
#' @descr
#' * Line 1: xxx
#' * Line 2: yyy
#' * Line 3: zzz
#' @end
#' @initial-vars
X <<- c(1,2,3,4)
Y <<- c('a', 'b', 'c', 'd')
X1 <<- c(1,2,3,4)
Y1 <<- c('a', 'b', 'c', 'd')
#' @end

# Prompt #1
#' @id a
#' @msg Add ten, nine, and eight together.
#' @var t_01
#' @code
10 + 9 + 8
#' @end

# Prompt #2
#' @id b
#' @msg Add ten, nine, and eight together.
#' @var t_02
#' @code
10 + 9 + 8 + 7 + 6 + 5
#' @end
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])

test_that("parse_ps - 3", {
  expect_equal(ps$ps_short, "P03")
  expect_equal(ps$ps_title, "This is a title")
  expect_equal(length(ps$ps_initial_vars),4)
  expect_equal(ps$ps_initial_vars[1],"X <<- c(1,2,3,4)")
  expect_equal(ps$ps_initial_vars[2],"Y <<- c('a', 'b', 'c', 'd')")

  expect_equal(length(ps$task_list), 2)
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[2]]$prompt_id,"b")

  expect_equal(ps$task_list[[1]]$assignment_var,"t_01")
  expect_equal(ps$task_list[[2]]$assignment_var,"t_02")

  expect_equal(ps$task_list[[1]]$expected_answer,"10 + 9 + 8")
  expect_equal(ps$task_list[[2]]$expected_answer,"10 + 9 + 8 + 7 + 6 + 5")
})

# A typical case
s <-
  "
#' Practice Set Example
#' @short P03
#' @title This is a title
#' @descr
#' * Line 1: xxx
#' * Line 2: yyy
#' * Line 3: zzz
#' @end
#' @initial-vars
X <<- c(1,2,3,4)
Y <<- c('a', 'b', 'c', 'd')
X1 <<- c(1,2,3,4)
Y1 <<- c('a', 'b', 'c', 'd')
#' @end

# Prompt #1
#' @id a
#' @msg Add ten, nine, and eight together.
#' @var t_01
#' @code
10 + 9 + 8
#' @end

# Prompt #1
#' @id -
#' @msg This is note; not a prompt.

# Prompt #2
#' @id b
#' @msg Add ten, nine, and eight together.
#' @var t_02
#' @code
10 + 9 + 8 + 7 + 6 + 5
#' @end
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])

test_that("parse_ps - 3", {
  expect_equal(ps$ps_short, "P03")
  expect_equal(ps$ps_title, "This is a title")
  expect_equal(length(ps$ps_initial_vars),4)
  expect_equal(ps$ps_initial_vars[1],"X <<- c(1,2,3,4)")
  expect_equal(ps$ps_initial_vars[2],"Y <<- c('a', 'b', 'c', 'd')")

  expect_equal(length(ps$task_list), 3)
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[3]]$prompt_id,"b")

  expect_equal(ps$task_list[[1]]$assignment_var,"t_01")
  expect_equal(ps$task_list[[3]]$assignment_var,"t_02")

  expect_equal(ps$task_list[[1]]$expected_answer,"10 + 9 + 8")
  expect_equal(ps$task_list[[3]]$expected_answer,"10 + 9 + 8 + 7 + 6 + 5")
})

# Test the automatic assignment of prompt IDs - question mark
s <-
"
#' @short P03
#' @title This is a title

# Prompt #1
#' @id a
#' @msg Add ten, nine, and eight together.
#' @var t_01
#' @code
10 + 9 + 8
#' @end

# Prompt #2
#' @id ?
#' @msg Add ten, nine, and eight together.
#' @var t_02
#' @code
10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #3
#' @id x
#' @msg Add ten, nine, and eight together.
#' @var t_03
#' @code
10 + 9 + 8 + 7 + 6 + 5
#' @end
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - 4", {
  expect_equal(ps$ps_short, "P03")

  expect_equal(length(ps$task_list), 3)
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[2]]$prompt_id,"b")
  expect_equal(ps$task_list[[3]]$prompt_id,"c")
})

# Test the automatic assignment of variable names
s <-
  "
#' @short P03
#' @title This is a title

# Prompt #1
#' @id ?
#' @code
t_01 <- 10 + 9 + 8
#' @end

# Prompt #2
#' @id ?
#' @code
t_02 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #3
#' @id ?
#' @code
t <- 1 + 4
s <- t - 10
t_03 <- 10 + 9 + 8 + 7 + 6 + 5
print(s)
print(t_03)
#' @end
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - 4", {
  expect_equal(ps$ps_short, "P03")

  expect_equal(length(ps$task_list), 3)
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[2]]$prompt_id,"b")
  expect_equal(ps$task_list[[3]]$prompt_id,"c")

  expect_equal(ps$task_list[[1]]$assignment_var,"t_01")
  expect_equal(ps$task_list[[2]]$assignment_var,"t_02")
  expect_equal(ps$task_list[[3]]$assignment_var,"t_03")
})


s <-
  "
#' @short P03
#' @title This is a title

# Prompt #1
#' @id ?
#' @code
t_01 <- 10 + 9 + 8
#' @end

# Prompt #2
#' @id ?
#' @code
t_02 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #3
#' @id ?
#' @code
t_03 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #4
#' @id ?
#' @code
t_04 <- 10 + 9 + 8
#' @end

# Prompt #5
#' @id ?
#' @code
t_05 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #6
#' @id ?
#' @code
t_06 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #7
#' @id ?
#' @code
t_07 <- 10 + 9 + 8
#' @end

# Prompt #8
#' @id ?
#' @code
t_08 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #9
#' @id ?
#' @code
t_09 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #10
#' @id ?
#' @code
t_10 <- 10 + 9 + 8
#' @end

# Prompt #11
#' @id ?
#' @code
t_11 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #12
#' @id ?
#' @code
t_12 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #13
#' @id ?
#' @code
t_13 <- 10 + 9 + 8
#' @end

# Prompt #14
#' @id ?
#' @code
t_14 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #15
#' @id ?
#' @code
t_15 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #16
#' @id ?
#' @code
t_16 <- 10 + 9 + 8
#' @end

# Prompt #17
#' @id ?
#' @code
t_17 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #18
#' @id ?
#' @code
t_18 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #19
#' @id ?
#' @code
t_19 <- 10 + 9 + 8
#' @end

# Prompt #20
#' @id ?
#' @code
t_20 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #21
#' @id ?
#' @code
t_21 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #22
#' @id ?
#' @code
t_22 <- 10 + 9 + 8
#' @end

# Prompt #23
#' @id ?
#' @code
t_23 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #24
#' @id ?
#' @code
t_24 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #25
#' @id ?
#' @code
t_25 <- 10 + 9 + 8
#' @end

# Prompt #26
#' @id ?
#' @code
t_26 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #27
#' @id ?
#' @code
t_27 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #28
#' @id ?
#' @code
t_28 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #29
#' @id ?
#' @code
t_29 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #30
#' @id ?
#' @code
t_30 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - 5", {
  expect_equal(ps$ps_short, "P03")

  expect_equal(length(ps$task_list), 30)
  expect_equal(ps$task_list[[1]]$prompt_id,"1")
  expect_equal(ps$task_list[[10]]$prompt_id,"10")
  expect_equal(ps$task_list[[30]]$prompt_id,"30")

  expect_equal(ps$task_list[[1]]$assignment_var,"t_01")
  expect_equal(ps$task_list[[10]]$assignment_var,"t_10")
  expect_equal(ps$task_list[[30]]$assignment_var,"t_30")
})


# A typical case
s <-
  "
#' Practice Set Example
#' @short P03
#' @title This is a title
#' @descr
#' * Line 1: xxx
#' * Line 2: yyy
#' * Line 3: zzz
#' @end
#' @initial-vars
X <<- c(1,2,3,4)
Y <<- c('a', 'b', 'c', 'd')
#' @end

# Prompt #1
#' @id a
#' @msg Add ten, nine, and eight together.
#' @var t_01
#' @code
10 + 9 + 8
#' @end

# Prompt #2
#' @id -
#' @msg A note message

# Prompt #2
#' @id b
#' @msg Add ten, nine, and eight together.
#' @var
#' @code
t_02 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$ps_short, "P03")
  expect_equal(ps$ps_title, "This is a title")
  expect_equal(length(ps$ps_initial_vars),2)
  expect_equal(ps$ps_initial_vars[1],"X <<- c(1,2,3,4)")
  expect_equal(ps$ps_initial_vars[2],"Y <<- c('a', 'b', 'c', 'd')")

  expect_equal(length(ps$task_list), 3)
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[2]]$prompt_id,"-")
  expect_equal(ps$task_list[[3]]$prompt_id,"b")

  expect_equal(ps$task_list[[1]]$is_note_msg,FALSE)
  expect_equal(ps$task_list[[2]]$is_note_msg,TRUE)
  expect_equal(ps$task_list[[3]]$is_note_msg,FALSE)

  expect_equal(ps$task_list[[1]]$assignment_var,"t_01")
  expect_equal(ps$task_list[[2]]$assignment_var,"")
  expect_equal(ps$task_list[[3]]$assignment_var,"t_02")

  expect_equal(ps$task_list[[1]]$expected_answer,"10 + 9 + 8")
  expect_equal(ps$task_list[[2]]$expected_answer,c())
  expect_equal(ps$task_list[[3]]$expected_answer,"t_02 <- 10 + 9 + 8 + 7 + 6 + 5")
})

# A typical case
s <-
  "
#' Practice Set Example
#' @short P03
#' @title This is a title
#' @descr
#' * Line 1: xxx
#' * Line 2: yyy
#' * Line 3: zzz
#' @end
#' @initial-vars
X <<- c(1,2,3,4)
Y <<- c('a', 'b', 'c', 'd')
#' @end

# Prompt #1
#' @id a
#' @msg Add ten, nine, and eight together.
#' @var t_01
#' @code
10 + 9 + 8
#' @end

# Prompt #2
#' @id -
#' @msg A note message

# Prompt #3
#' @id -
#' @msg A secon message

# Prompt #4
#' @id b
#' @msg Add ten, nine, and eight together.
#' @var
#' @code
t_02 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #5
#' @id -
#' @msg A third message
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[2]]$prompt_id,"-")
  expect_equal(ps$task_list[[5]]$prompt_id,"-")

  expect_equal(ps$task_list[[1]]$is_note_msg,FALSE)
  expect_equal(ps$task_list[[2]]$is_note_msg,TRUE)
  expect_equal(ps$task_list[[5]]$is_note_msg,TRUE)

  expect_equal(ps$task_list[[1]]$assignment_var,"t_01")
  expect_equal(ps$task_list[[2]]$assignment_var,"")
  expect_equal(ps$task_list[[4]]$assignment_var,"t_02")

  expect_equal(ps$task_list[[1]]$expected_answer,"10 + 9 + 8")
  expect_equal(ps$task_list[[2]]$expected_answer,c())
  expect_equal(ps$task_list[[4]]$expected_answer,"t_02 <- 10 + 9 + 8 + 7 + 6 + 5")
})

# A typical case
s <-
  "
#' Practice Set Example
#' @version ps-1
#' @short P03
#' @title This is a title

# Prompt #1
#' @id -
#' @msg A note message

# Prompt #2
#' @id ?
#' @msg Add ten, nine, and eight together.
#' @var
#' @code
t_02 <- 10 + 9 + 8 + 7 + 6 + 5
#' @end

# Prompt #3
#' @id -
#' @msg A note message
"
t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$task_list[[1]]$prompt_id,"-")
  expect_equal(ps$task_list[[2]]$prompt_id,"a")

  expect_equal(ps$task_list[[1]]$is_note_msg,TRUE)
  expect_equal(ps$task_list[[2]]$is_note_msg,FALSE)
})

s <-
"
#' @version ps-1
#' @short PS-T10
#' @title Test example in public on GitHub
#' @descr
#' Some simple tests
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id ?
#' @msg Basic expressions

#' @id -
#' @msg An expression
#' @code
t01 <- sqrt((1+2+3)^2)*2  # 12
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$task_list[[1]]$prompt_id,"-")
  expect_equal(ps$task_list[[2]]$prompt_id,"-")

  expect_equal(ps$task_list[[1]]$is_note_msg,TRUE)
  expect_equal(ps$task_list[[2]]$is_note_msg,TRUE)
})

s <-
  "
#' @version ps-1
#' @short PS-T10
#' @title Test example in public on GitHub
#' @descr
#' Some simple tests
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id a
#' @msg An expression
#' @code
t01 <- sqrt((1+2+3)^2)*2  # 12
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[1]]$is_note_msg,FALSE)
})

s <-
  "
#' @version ps-1
#' @short PS-T10
#' @title Test example in public on GitHub
#' @descr
#' Some simple tests
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id ?
#' @msg An expression
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$task_list[[1]]$prompt_id,"-")
  expect_equal(ps$task_list[[1]]$is_note_msg,TRUE)
})

s <-
  "
#' @version ps-1
#' @short PS-T10
#' @title Test example in public on GitHub
#' @descr
#' Some simple tests
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' @id -
#' @msg An expression
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$task_list[[1]]$prompt_id,"-")
  expect_equal(ps$task_list[[1]]$is_note_msg,TRUE)
})

#----------------------------------------------------------------------------#
# ??
#----------------------------------------------------------------------------#
s <-
  "
#' @version ps-1
#' @short PS-T10
#' @title Test example in public on GitHub
#' @descr
#' Some simple tests
#' @end
#' @initial-vars
X <- c(1,2,3)
#' @end

#' #' @id -
#' @msg An expression

#' @id a
#' @msg An expression
#' @code
t01 <- sqrt((1+2+3)^2)*2  # 12
#' @end

#' #' @id b
#' @msg An expression
#' @code
t02 <- sqrt((1+2+3)^2)*2  # 12
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - note messages", {
  expect_equal(ps$task_list[[1]]$prompt_id,"-")
  expect_equal(ps$task_list[[1]]$is_note_msg,TRUE)

  expect_equal(ps$task_list[[2]]$prompt_id,"a")
  expect_equal(ps$task_list[[3]]$prompt_id,"b")
})

#----------------------------------------------------------------------------#
# Check for tag checks_for_f
#----------------------------------------------------------------------------#
s =
"
#' @id a
#' @msg A  function
#' @check c(1, 1000, 10, 0, -1, NA)
#' @var f1
#' @code
function(x) {
  t <- x + 1
  return(t)
}
#' @end

#' @id b
#' @msg A  function
#' @check c()
#' @var f2
#' @code
function(x) {
  t <- x + 1
  return(t)
}
#' @end

#' @id c
#' @msg A  function
#' @check
#' @var f3
#' @code
function(x) {
  t <- x + 1
  return(t)
}
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - @check input for functions", {
  expect_equal(ps$task_list[[1]]$prompt_id,"a")
  expect_equal(ps$task_list[[1]]$checks_for_f,"c(1, 1000, 10, 0, -1, NA)")
  expect_equal(ps$task_list[[2]]$prompt_id,"b")
  expect_equal(ps$task_list[[2]]$checks_for_f,"c()")
  expect_equal(ps$task_list[[3]]$prompt_id,"c")
  expect_equal(ps$task_list[[3]]$checks_for_f,"")
})

#----------------------------------------------------------------------------#
# Correct duplicate variable names (explicitly set)
#----------------------------------------------------------------------------#
s =
  "
#' @id a
#' @msg An assignment
#' @var t01
#' @code
1
#' @end

#' @id b
#' @msg An assignment duplicate
#' @var t01
#' @code
1
#' @end

#' @id c
#' @msg An assignment duplicate
#' @var t01
#' @code
1
#' @end

#' @id c
#' @msg An assignment duplicate
#' @var t01
#' @code
1
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - @check input for functions", {
  expect_equal(ps$task_list[[1]]$assignment_var,"t01")
  expect_equal(ps$task_list[[2]]$assignment_var,"t01.a")
  expect_equal(ps$task_list[[3]]$assignment_var,"t01.ab")
})

#----------------------------------------------------------------------------#
# Correct duplicate variable names (implicitly set)
#----------------------------------------------------------------------------#
s =
  "
#' @id a
#' @msg An assignment
#' @code
t01 <- 1
#' @end

#' @id b
#' @msg An assignment duplicate
#' @code
t01 <- 1
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - @check input for functions", {
  expect_equal(ps$task_list[[1]]$assignment_var,"t01")
  expect_equal(ps$task_list[[2]]$assignment_var,"t01.a")
})

s <-
"
#' @version ps-1
#' @short T03
#' @title Test cases: Functions
#' @descr
#' @end
#' @initial-vars
g <- function(x) {return(x+1)}
#' @end

#' @id ?
#' @msg Call function that is pre-installed
#' @code
t01 <- g(10)  #A: 11
#' @end

#' @id ?
#' @msg Create a function that squares a number
#' @var squared
#' @code
squared <- function(x) {
  xx <- x^2
  return(t)
}
#' @end
"

t <- str_split(s,"\n")
ps <- parse_ps(t[[1]])
ps <- check_ps(ps)

test_that("parse_ps - @check input for functions", {
  expect_equal(ps$task_list[[1]]$assignment_var,"t01")
  expect_equal(ps$task_list[[2]]$assignment_var,"squared")
})
