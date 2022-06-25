# expr_type <- function(x) {
#   if (rlang::is_syntactic_literal(x)) {
#     "constant"
#   } else if (is.symbol(x)) {
#     "symbol"
#   } else if (is.call(x)) {
#     "call"
#   } else if (is.pairlist(x)) {
#     "pairlist"
#   } else {
#     typeof(x)
#   }
# }
#
# switch_expr <- function(x, ...) {
#   switch(expr_type(x),
#          ...,
#          stop("Don't know how to handle type ", typeof(x), call. = FALSE)
#   )
# }
#
# recurse_call <- function(x) {
#   switch_expr(x,
#               # Base cases
#               symbol = ,
#               constant = ,
#
#               # Recursive cases
#               call = ,
#               pairlist =
#   )
# }
#
# logical_abbr_rec <- function(x) {
#   switch_expr(x,
#               constant = FALSE,
#               symbol = as_string(x) %in% c("F", "T")
#   )
# }
#
# logical_abbr <- function(x) {
#   logical_abbr_rec(enexpr(x))
# }
#
# logical_abbr_rec(expr(TRUE))
# logical_abbr_rec(expr(T))
# logical_abbr_rec(expr(S))
#
#
#
#
# ------
#
# walk3 <- function(e, level = 1) {
#   t <- str_sub("...............", 1, (level - 1) * 2)
#   if (rlang::is_syntactic_literal(e)) {
#     cat(paste0(t, " ", "(constant: '", as.character(e), "')\n"), sep = "")
#     return(TRUE)
#   } else if (rlang::is_symbol(e)) {
#     if (as.character(e) == "<-") {
#       cat(paste0(t, " ", "(<-: '", as.character(e), "')\n"), sep = "")
#   }
#     level <- level + 1
#     for (k in 1:length(e)) {
#       cat(paste(t, "walk"))
#       walk2(e[[k]], level)
#     }
#   }
#   return(TRUE)
# }
#
#
#
#
# switch_expr2 <- function(x, ...) {
#   switch(x,
#     "a" = paste0("a >>", ..., collapse = " - "),
#     "b" = paste("b >>", ..., collpase = " - "),
#     ...
#   )
# }
#
#
#
#
# # https://stackoverflow.com/questions/60083614/how-to-get-ast-as-a-list-in-r
#
# getAST <- function(ee) purrr::map_if(as.list(ee), is.call, getAST)
#
# # Example usage on expressions:
# getAST(quote(log10(a + 5) / b))
# # List of 3
# #  $ : symbol /
# #  $ :List of 2
# #   ..$ : symbol log10
# #   ..$ :List of 3
# #   .. ..$ : symbol +
# #   .. ..$ : symbol a
# #   .. ..$ : num 5
# #  $ : symbol b
#
# # Example usage on strings:
# getAST(str2lang("(media.urin_A + media.urin_B)/2"))
# # List of 3
# #  $ : symbol /
# #  $ :List of 2
# #   ..$ : symbol (
# #   ..$ :List of 3
# #   .. ..$ : symbol +
# #   .. ..$ : symbol media.urin_A
# #   .. ..$ : symbol media.urin_B
# #  $ : num 2
