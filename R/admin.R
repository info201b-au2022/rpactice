# Admin ----
#----------------------------------------------------------------------------#
# Admin functions - very useful for debugging
#----------------------------------------------------------------------------#

admin <- function() {
  cat("Function             Purpose\n")
  cat("admin.ls()           List installed practice sets\n")
  cat("admin.prompts(short) List the practice prompts\n")
  cat("admin.vars()         List the live variables")
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
    cat(paste0(k, ": [",v[k], "]: ", num_prompts, "\n"))
  }
}

#----------------------------------------------------------------------------#
# List the prompts and some basic information for a practice set
#----------------------------------------------------------------------------#
admin.prompts <- function (short) {
  practice.begin(short)
  ps <- ps_get_by_short(short)
  if (is.null(ps)) {
    stop(past0("Error. Practice set not found (",short,")"))
  }
  cat("\014") # Clear screen
  cat("[",short, "]: ", ps$ps_descr, "\n", sep="")
  cat("Prompts: ", length(ps$task_list), ".\n", sep="")
  cat("ID\t\tValue\t\t\t\t\tCode\n")
  k = 1
  for(task in ps$task_list) {
    if (task$is_note_msg) {
      m <- task$prompt_msg
      if (nchar(m) > 39) {
        m <- substr(m, 1, 40)
        m <- paste0("\t\t", m, "...")
      }
      cat(k, "[-] \t\t\t\t\t\t\t", m, sep="")
    } else {
      r <- eval_string(task$expected_answer)
      if(nchar(r) > 23){
        r <- substr(r, 1, 20)
        r <- paste0(r, "...")
      }
      r <- sprintf("%-25s",r)
      cat(k, ":", task$prompt_id,"[", task$assignment_var, "]: \t\t\t\t\t\t", task$prompt_msg, "\n\t\t",
          r, "\t\t",  task$expected_answer, "\n", sep="")
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
