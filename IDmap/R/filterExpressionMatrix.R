########################################
##                                    ##
## code last update: July 12, 2019    ##
##                                    ##
########################################

##' Filter expression matrix
##'
##' \code{filterEM} returns
##' @param matrix
##' @param
##'
##' @return
##'
##' @examples
##' @export
filterEM <- function(matrix,probeIdCol,){




}

#dat[1:4,1:4]
dat=dat[ids$probe_id,]
ids$median=apply(dat,1,median) #ids新建median这一列，列名为median，同时对dat这个矩阵按行操作，取每一行的中位数，将结果给到median这一列的每一行
ids=ids[order(ids$symbol,ids$median,decreasing = T),]#对ids$symbol按照ids$median中位数从大到小排列的顺序排序，将对应的行赋值为一个新的ids
ids=ids[!duplicated(ids$symbol),]#将symbol这一列取取出重复项，'!'为否，即取出不重复的项，去除重复的gene ，保留每个基因最大表达量结果s
dat=dat[ids$probe_id,] #新的ids取出probe_id这一列，将dat按照取出的这一列中的每一行组成一个新的dat
rownames(dat)=ids$symbol#把ids的symbol这一列中的每一行给dat作为dat的行名
dat[1:4,1:4]  #保留每个基因ID第一次出现的信息





