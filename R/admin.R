# Admin ----
#----------------------------------------------------------------------------#
# Admin functions - very useful for debugging
#----------------------------------------------------------------------------#

admin <- function() {
  cat("Function             Purpose\n")
  cat("admin.ls()           List installed practice sets\n")
  cat("admin.prompts(short) List the practice prompts\n")
  cat("admin.vars()         List the live variables")
  cat("admin.check_ps       Check practice set")
}

#----------------------------------------------------------------------------#
# List all the practice sets that have been loaded
#----------------------------------------------------------------------------#
admin.ls <- function (detailed=TRUE) {
  v <- ps_get_all()
  cat("\014") # Clear screen
  cat("Practice sets:", str_trim(length(v)), "\n")
  for (k in 1:length(v)) {
    ps <- ps_get_by_short(v[k])
    num_prompts <- length(ps$task_list)
    cat(paste0(k, ": [",v[k], "]: ", ps$ps_title, " (Prompts: ", num_prompts, ")\n"))
    cat(paste0("   Filename: ", ps$ps_filename, "\n"))
  }
}

#----------------------------------------------------------------------------#
# List the prompts and some basic information for a practice set
#----------------------------------------------------------------------------#
admin.prompts <- function (short) {
  practice.begin(short)
  ps <- ps_get_by_short(short)
  if (is.null(ps)) {
    stop(paste0("Error. Practice set not found (",short,")"))
  }
  cat("\014") # Clear screen
  cat("[",short, "]: ", ps$ps_title, " (Prompts: ", length(ps$task_list), ")\n", sep="")

  v <- get_env_vars(short)
  t <- paste0(v, collapse="\n")
  cat("Envir Variables\n  ", t, "\n")

  cat("ID\n")
  k = 1
  for(task in ps$task_list) {
    if (task$is_note_msg) {
      m <- task$prompt_msg
      if (nchar(m) > 39) {
        m <- substr(m, 1, 40)
        m <- paste0(" ", m, "...")
      }
      cat(k, "[-] ", m, sep="")
    } else {
      r <- eval_string_and_format(task$expected_answer)
      if(nchar(r) > 65){
        r <- substr(r, 1, 60)
        r <- paste0(r, "...")
      }

      cat(k, ":", task$prompt_id,"[", task$assignment_var, "]: ", task$prompt_msg, "\n", sep="")
      t1 <- sprintf("%-60s", format_code2(task$expected_answer))
      cat(t1, "\n", sep="")
      cat("", crayon::red(r), "\n", sep="")
    }
    k <- k + 1
    cat("\n")
  }
}

#----------------------------------------------------------------------------#
# List all the variable names that are current alive in the practice set
#----------------------------------------------------------------------------#
admin.vars <- function() {
  v <- ps_get_live_var_names()
  cat("Live variables: ", "\n", sep="")
  for (k in 1: length(v)) {
    cat("   ", k, ":[", v[k], "]:\t", sep="")
    cat("\n")
  }
  cat("Number: ", length(v), "\n")
  cat("Callbacks loaded:\n")
  any <- 0
  for (k in 1:length(v)) {
    if (is_callback_loaded(v[k])) {
      cat("   ", k, ":CALLBACK:", v[k], "_Check(internal_id, result)\n", sep="")
      any <- any + 1
    }
  }
  if (any > 0) {
    cat("Number:", any)
  } else {
    cat("No callbacks.")
  }
  cat("\n")
}

admin.run_answers <- function(fn) {
  print("run_answers")
}

admin.check_ps <- function (fn) {
  temp_ps <- load_ps(fn, silent=FALSE)
}
