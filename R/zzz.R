#----------------------------------------------------------------------------#
# .onLoad() is automatically called when the package is loaded. By convention,
# .onLoad() is generally placed into a file call ZZZ.R
# see: https://r-pkgs.org/r.html?q=zzz#when-you-do-need-side-effects
#----------------------------------------------------------------------------#
.onLoad <- function(libname,pkgname) {
  ps_load_internal_ps()
  packageStartupMessage(paste0("Welcome to ", pkgname))
  packageStartupMessage(paste0("", getwd()))
}

.onUnload <- function(libname,pkgname) {
  NULL  # Not sure if there is any clean up to do
}
