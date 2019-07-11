########################################
##                                    ##
## code last update: June 19, 2019    ##
##                                    ##
########################################

##' Download probe annotations from GEO
##'
##'
##' \code{getGPLsoft} download probe annotation from GEO database for the input GPL Accession Number
##' @param GPL,destDir
##'
##' @return {getGPLsoft} will download probe annotations from GEO ,then the output will be a dataframe
##'
##' @examples
##' getGPLsoft("GPL13607", destdir=getwd())
##'
##' @importFrom GEOquery getGEO
##' @export

get_geo <- function(GPL,destDir=getwd()){
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
