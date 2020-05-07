###########################
## Last update at oct 16 ##
## by Xiang Yujia        ##   
###########################

##' Calculate mutual info of two vectors
##' @import infotheo
##' @example 
##' data<-read.csv("E:\\qq\\alarm_data\\Alarm1_s500_v1.csv",header = F)
##' pvalue<-mi(tmp=discretize(allnormalfpkmTrans),discretize(normalGeneFpkmTrans))#测试
mutualInfo <- function(mylist1,mylist2){
  return(entropy(mylist1)+entropy(mylist2)-entropy(cbind(mylist1,mylist2)))
}

##' Calculate conditional mutual info of two vectors
##' @import infotheo
##' @example 
##' data<-read.csv("E:\\qq\\alarm_data\\Alarm1_s500_v1.csv",header = F)
##' pvalue1<-cmi(data[,5],data[,13],data[,c(7,8)])
conMutualInfo<-function(mylist1,mylist2,mylist3){
  return(entropy(cbind(mylist1,mylist3))+entropy(cbind(mylist2,mylist3))-entropy(mylist3)-entropy(cbind(mylist1,mylist2,mylist3)))
}

##' Calculate pearson correlation values of two matrixs or vectors 
##' @param mat1 a numeric matrix which column is the gene, row is sample info 
##' @param mat2 a numeric matrix which column is the gene, row is sample info 
##' @param method
##' @example 
##' 
calPearson <- function(mat1, mat2, method){
  pearsonRes <- cor(mat1, mat2, method = "pearson")
}


##' Convert pearson correlation matrix result to data.frame
##' pearson correlation function will return a matrix, but it is not friendly for us to deal with,
##' so this function covert matrix result to a data.frame which contains three columns (node1, node2, pearson values, abs pearson values)
##' @param pearsonMat the pearson matrix result
##' @param filterVal the threshold value to cut pearson res
##' @example 
pearsonMat2Df <- function(pearsonMat, filterVal=0.5){
  relationTable <- data.frame()
  geneName2 <- rownames(pearsonMat)
  for(i in 1:ncol(pearsonMat)){
    # i=1
    print(i)
    relationPair = data.frame(geneName1=rep(colnames(pearsonMat)[i],times=nrow(pearsonMat)),
                              geneName2,
                              pearsonRes=pearsonRes[,i])
    relationPair = na.omit(relationPair)
    relationPair$absRes <- abs(relationPair$pearsonRes)
    filterPair <- relationPair[which(relationPair$absRes > filterVal),]
    relationTable <- rbind(relationTable, filterPair)  
  }
  return(relationTable)
}

