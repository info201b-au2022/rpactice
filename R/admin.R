admin <- function() {
  cat("Function             Purpose\n")
  cat("admin.ls()           List installed practice sets\n")
  cat("admin.prompts(short) List the practice prompts\n")
  cat("admin.vars()         List the live variables")
}

admin.ls <- function (detailed=TRUE) {
  v <- ps_get_all()
  cat("Practice sets:", str_trim(length(v)), "\n")
  for (k in 1:length(v)) {
    ps <- ps_get_by_short(v[k])
    num_prompts <- length(ps$task_list)
    cat(paste0(k, ": [",v[k], "]: ", num_prompts, "\n"))
  }
}

admin.prompts <- function (short) {
  ps <- ps_get_by_short(short)
  if (is.null(ps)) {
    stop(past0("Error. Practice set not found (",short,")"))
  }
  cat("[",short, "]:Prompts: ", length(ps$task_list), "\n", sep="")
  cat("\t\texpected_answer\n")
  k = 1
  for(task in ps$task_list) {
    if (task$is_note_msg) {
      m <- task$prompt_msg
      if (nchar(m) > 39) {
        m <- substr(m, 1, 40)
        m <- paste0("\tNote: ", m, "...")
      }
      cat(k, ":[-] \t", m, sep="")
    } else {
      cat(k, ":", task$prompt_id,":[", task$assignment_var, "]:\t", task$expected_answer, sep="")
    }
    k <- k + 1
    cat("\n")
  }
}

admin.vars <- function() {
  v <- get_live_var_names()
  cat("Live variables: ", length(get_live_var_names()), "\n", sep="")
  for (k in 1: length(v)) {
    cat(k, ":[", v[k], "]:\t", sep="")
    cat("\n")
  }
}
