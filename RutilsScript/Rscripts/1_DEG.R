###########################
## Last update at oct 15 ##
## by Xiang Yujia        ##   
###########################

##' Differential genes analysis use DESeq
##' @param DESeqMat a numeric raw counts matrix. It rownames are gene ids, colnames are sample info .
##' @param condition a factor indicating the groups of samples
##' @param outputPath output path 
##' @import DESeq
##' @example 
##' 
##' condition <- factor(c("R6547", "R6547_24h")) ## 建立环境
diffDESeq <- function(DESeqMat, condition, outputPath=NULL, 
                      method="blind", 
                      sharingMode="fit-only",
                      fitType=NULL ){
  cds <- newCountDataSet(DESeqMat, condition)
  cds <- estimateSizeFactors(cds)
  cds <- estimateDispersions(cds, 
                             method=method, 
                             sharingMode=sharingMode, 
                             fitType=fitType) # fitType="local"
  res <- nbinomTest(cds,as.vector(condition)[1], as.vector(condition)[2])
  res <- res[order(res$padj),]
  if(length(outputPath)!=0){
    write.csv(res,outputPath,row.names = F)
  }else{
    return(res)
  }
}

##' Differential genes analysis use DESeq2
##' @param DESeqMat
##' @param condition
##' @import DESeq2
##' @example 
##' 



##' Unmodel species GO enrich
##' @param DESeqMat
##' @param condition
##' @import DESeq2
##' @example 




##' Split GO list
##' @param filterRawGO
##' @import tidyverse separate
##' @example 
##' rawGO <- read.csv("allGO_CC.csv",header=T)
##' rawGO <- na.omit(rawGO)
##' filterRawGO <- separate(rawGO, col="go_c", into = paste0(c(1:50)), sep="[+++]")
splitGO <- function(filterRawGO){
  res <- data.frame()
  for(i in 1:nrow(filterRawGO)){
    # i=1
    print(i)
    tmp <- as.vector(filterRawGO[i,])
    nanum<-length(tmp)+1
    compId <- as.vector(unlist(rep(tmp[1],times=(nanum-2))))
    GO_tmp <- as.vector(unlist(tmp[1,2:(nanum-1)]))
    tmp_res <- data.frame(compId=compId,GoId=as.vector(GO_tmp))
    res <-rbind(res,tmp_res)
  }
  res <- na.omit(res)
  delnum <- which(nchar(res$GoId)==0)
  if(length(delnum)!=0){
  res <- res[-c(delnum),]
  }
  return(res)
}


