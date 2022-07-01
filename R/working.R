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



# <!DOCTYPE html>
#   <html>
#   <head>
#   <meta name="viewport" content="width=device-width, initial-scale=1">
#     <style>
#     .collapsible {
#       background-color: #777;
#         color: white;
#       cursor: pointer;
#       padding: 18px;
#       width: 100%;
#       border: none;
#       text-align: left;
#       outline: none;
#       font-size: 15px;
#     }
#
#   .active, .collapsible:hover {
#     background-color: #555;
#   }
#
#   .content {
#     padding: 0 18px;
#     display: none;
#     overflow: hidden;
#     background-color: #f1f1f1;
#   }
#   </style>
#     </head>
#     <body>
#
#     <h2>Collapsibles</h2>
#
#     <p>A Collapsible:</p>
#     <button type="button" class="collapsible">Open Collapsible</button>
#     <div class="content">
#     <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
#     </div>
#
#     <p>Collapsible Set:</p>
#     <button type="button" class="collapsible">Open Section 1</button>
#     <div class="content">
#     <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
#     </div>
#     <button type="button" class="collapsible">Open Section 2</button>
#     <div class="content">
#     <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
#     </div>
#     <button type="button" class="collapsible">Open Section 3</button>
#     <div class="content">
#     <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
#     </div>
#
#     <script>
#     var coll = document.getElementsByClassName("collapsible");
#   var i;
#
#   for (i = 0; i < coll.length; i++) {
#     coll[i].addEventListener("click", function() {
#       this.classList.toggle("active");
#       var content = this.nextElementSibling;
#       if (content.style.display === "block") {
#         content.style.display = "none";
#       } else {
#         content.style.display = "block";
#       }
#     });
#   }
#   </script>
#
#     </body>
#     </html>
