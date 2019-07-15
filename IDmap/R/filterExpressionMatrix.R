########################################
##                                    ##
## code last update: July 12, 2019    ##
##                                    ##
########################################

##' Filter expression matrix
##'
##' \code{filterEM} returns
##' @param dat dat is a expression matrix,which the first col must be probe ids and the second col must be gene symbols or entrez ids. Other cols should be expression values .
##'
##' @return filter ids expression ma
##'
##' @examples
##' probeid <- c("A_23_P101521","A_33_P3695548","A_33_P3266889")
##' symbol <- c("symbol1","symbol2","s)
##' dat <- data.frame
##' @export
filterEM <- function(dat){
  # computing median values of expression matrix
  dat$EMmedian <- apply(dat,1,median)
  # select probe ids, gene symbols and median values from dat
  ids <- with(dat,probeid=dat[,1],symbol=dat[,2],median=EMmedian)
  # ordering matrix by median values
  ids=ids[order(ids$median,decreasing = T),]
  # filter duplicated symbols
  ids <- ids[!duplicated(ids$symbol),]
  res <- dat[which(dat[,1] %in% ids$probeid),]
  return(res)
}





