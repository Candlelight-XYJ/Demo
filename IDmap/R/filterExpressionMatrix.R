########################################
##                                    ##
## code last update: July 25, 2019    ##
##                                    ##
########################################

##' Filter expression matrix
##'
##' \code{filterEM} returns
##' @param matrix is an expression matrix which rownames are probe ids and every column is a sample
##' @param probe2gene is a data frame which includes probe ids and corresponding gene Symbols
##' @param omitNA omit NA symbol rows in matrix
##' @return filter ids expression ma
##'
##' @examples
##' eMatrix <- system.file("extdata", "matrixData.Rdata", package="IDmap")
##' allMapIds <- system.file("extdata", "probe2gene.Rdata", package="IDmap")
##' load(eMatrix)
##' load(allMapIds)
##' ## head(matrixData)
##' ## head(probe2gene)
##' res <- filterEM(matrixData,probe2gene,omitNA=T)
##' @export
filterEM <- function(matrix,probe2gene,omitNA=T){
  ids <- probe2gene
  colnames(ids) <- c("probeid","symbol")
  # computing median values of expression matrix
  ids$EMmedian <- apply(matrix,1,median)
  # ordering matrix by median values
  ids=ids[order(ids$EMmedian,decreasing = T),]
  # filter duplicated symbols
  ids <- ids[!duplicated(ids[,2]),]
  #
  res <- matrix[which(rownames(matrix) %in% ids[,1]),]
  res <- as.data.frame(res)
  res$probeid <- rownames(res)
  res <- merge(res,ids,by="probeid",all=F)
  if(omitNA){
  res <- na.omit(res)
  }
  return(res)
}





