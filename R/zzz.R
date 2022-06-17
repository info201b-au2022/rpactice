#----------------------------------------------------------------------------#
# .onLoad() is automatically called when the package is loaded. By convention,
# .onLoad() is generally placed into a file call ZZZ.R
# see: https://r-pkgs.org/r.html?q=zzz#when-you-do-need-side-effects
#----------------------------------------------------------------------------#
.onLoad <- function(libname,pkgname) {
  ps_load_internal_ps()
  cat(paste0("Welcome to ", pkgname,"\n"))
  cat(paste0("", getwd(),"\n"))
}

.onUnload <- function(libname,pkgname) {
  NULL
}
