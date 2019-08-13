##' @importFrom utils packageDescription
.onAttach <- function(libname, pkgname) {
  pkgVersion <- packageDescription(pkgname, fields="Version")
  msg <- paste0(pkgname, " v", pkgVersion, "  ",
                "wellcome to use AnnoProbe !", "\n\n")

  citation <- paste0("If you use ", pkgname, " in published research, please cite:\n",
                     "AnnoProbe:An R/Bioconductor package for probe annotating .",
                     "BMC Bioinformatics 2019, XXXXXXXX")

  packageStartupMessage(paste0(msg, citation))

  options('download.file.method.GEOquery'='auto')
  options('GEOquery.inmemory.gpl'=FALSE)

  #packageStartupMessage(paste0(msg, citation))
}
