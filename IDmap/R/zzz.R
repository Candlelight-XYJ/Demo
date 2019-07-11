##' @importFrom utils packageDescription
.onAttach <- function(libname, pkgname) {
  pkgVersion <- packageDescription(pkgname, fields="Version")
  msg <- paste0(pkgname, " v", pkgVersion, "  ",
                "wellcome to use IDmap !", "\n\n")

  options('download.file.method.GEOquery'='auto')
  options('GEOquery.inmemory.gpl'=FALSE)

  #packageStartupMessage(paste0(msg, citation))
}
