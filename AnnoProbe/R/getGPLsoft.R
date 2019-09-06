##########################################
##                                      ##
## code last update: August 13, 2019    ##
##                                      ##
##########################################

##' Download probe annotations from GEO
##'
##'
##' \code{getGPLsoft} download probe annotations from GEO database for the input GPL Accession Number
##' @param GPL GPL(GEO platform) number, eg: GPL570
##' @param destDir The destination directory for any downloads. Defaults is the currently used directory . You may want to specify a different directory if you want to save the file for later use.
##'
##' @return {getGPLsoft} will download probe annotations from GEO ,then the output will be a dataframe
##'
##' @examples
##' getGPLsoft("GPL13607", destdir=getwd())
##'
##' @importFrom GEOquery getGEO
##' @export

getGPLsoft <- function(GPL,destDir=getwd()){
  pkg <- "GEOquery"
  require(pkg, character.only=TRUE)
  getGEO <- eval(parse(text="getGEO"))
  #Meta <- eval(parse(text="Meta"))
  destdir="geo_soft"
  if (!file.exists(destdir)) {
    dir.create(destdir)
  }
  info <- getGEO(GPL, destdir=destdir)
  ## http://www.ncbi.nlm.nih.gov/geo/info/soft2.html
  res <- Table(info)
  return(res)
}
