##' Heatmap
##' @import gplots
##' @import RColorBrewer
##' @import ComplexHeatmap
library(gplots)
library(RColorBrewer)
iPSexpTotal<-openxlsx::read.xlsx("C:/Users/Administrator/Desktop/mi.xlsx", sheet=2,rowNames=T)
#iPSexp<-iPSexpTotal[,1:15]
iPSexp<-as.matrix(iPSexpTotal)
hclust2 <- function(x, method="average", ...){hclust(x, method=method, ...)}
dist2 <- function(x, ...){as.dist(1-cor(t(x), method="pearson"))}
heatmap.2(iPSexp,col=rev(colorRampPalette(brewer.pal(5, "RdBu"))(20)),
          margin=c(10,8),Rowv=T, Colv=T,scale="row",key=T,
          keysize=1.5,trace="none")
# lmat=iPSexp, lhei = 10, lwid = 5
iPSexp<-as.matrix(iPSexpTotal)
hclust2 <- function(x, method="average", ...){hclust(x, method=method, ...)}
dist2 <- function(x, ...){as.dist(1-cor(t(x), method="pearson"))}
heatmap.2(iPSexp,col=rev(colorRampPalette(brewer.pal(5, "RdBu"))(20)),
          margin=c(8,15),Rowv=T, Colv=F,labRow = NULL,scale="row",key=T,
          keysize=1.5,trace="none")

## complex heatmap
library(ComplexHeatmap)
library(circlize)
iPSexpTotal<-openxlsx::read.xlsx("C:/Users/Administrator/Desktop/mi.xlsx", sheet=2,rowNames=T)
iPSexp<-as.matrix(iPSexpTotal)
Heatmap(iPSexp,c("blue","red"),
        cluster_columns=F,
        heatmap_legend_param = list(title = "counts")) #调用Heatmap函数展示前50个基因表达量的热图



##' Plot multiple lines in one window
##'

drawGeneLine <- function(expMat, geneName, sample){
  if(length(geneName)>=100){
    stop("geneName's number must less than 100 !")
  }
  flag = which(rownames(expMat) %in% geneName)
  if(length(flag)==0){
    stop("geneName is not in input expression matrix's rownames!")
  }
  mappedIds = rownames(expMat)[which(rownames(expMat) %in% geneName)]
  drawMat = expMat[mappedIds,]
  missIds <- setdiff(geneName, mappedIds)
  missIdsPercentage = round((length(missIds)/length(geneName))*100,2)
  if(length(missIds)!=0){
    warning(
      paste0(missIdsPercentage ,
             "% of input gene IDs are fail to plot ...
             please check all of your input gene IDs are in the expression matrix!")
      # 5.29% of input gene IDs are fail to map...
      )
  }
  sampleName <- colnames(expMat)
  targetGeneExp <- expMat[flag, ]
  
  ## format exp for plot
  transGeneExp <- as.data.frame(t(targetGeneExp))
  transGeneExp$sample <- sampleName
  meltExp <- melt(transGeneExp,id.vars="sample")
  ggplot(meltcount,aes(x = id, y = value)) +
    geom_line(aes(color=variable,group=variable))
}


##' plot dot
##' plot multiple point groups in one window
##' @param data input file
##' @param geom_point plot points in a panel, if there are multiple groups then set multiple geom_point layers
##' @param scale_colour_manual set colors and labels by maunal
##' @param xlab setting the label of xlab
##' @param ylab setting the label of ylab
##' @param scale_x_continuous setting xlab margin
##' @param scale_y_continuous setting ylab margin
ggplot(data = diff_stat) +
  geom_point(aes(x=log10(FDR1),y=log10(log2FC1),colour=diff)) +
  geom_point(aes(x=log10(FDR2),y=log10(log2FC2),colour=diff)) +
  scale_colour_manual(limits = c('up', 'down', 'no'), 
                      values = c('red', 'blue', 'gray40'), 
                      labels = c('Up', 'Down', 'Stable')) +
  xlab("log10(Ein expression)") + ylab("log10(COL expression)") + ggtitle("") +
  scale_x_continuous(limits = c(-1,6)) +
  scale_y_continuous(limits = c(-5,6))


##' plot pie
##' plot pie in one window
##' @param diffPie input file
##' @param blank_theme setting blank themes of plot, 先设置空白主题,这样背景也是白色的
##' @param scale_fill_manual set colors and labels by maunal, 设置饼图中各个成分的颜色
##' @param coord_polar 极坐标变换, 这样就可以把条形图转换为饼图
##' @param scale_fill_brewer 通过调色盘来设置颜色分布
##' @param geom_text 设置饼图中的label, 但是坐标有些复杂, 可以暂时不管
##' @source https://zhuanlan.zhihu.com/p/25234546, https://blog.csdn.net/Bone_ACE/article/details/47455363,https://blog.csdn.net/Bone_ACE/article/details/47427453
##'  
diffPie <- data.frame(types=c("down","up","no"), num=c(8,43,37))
blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )
p <- ggplot(data = diffPie, mapping = aes(x = 'Content', y = num, fill = types)) + geom_bar(stat = 'identity', position = 'stack', width = 1)
p <- p + scale_fill_manual(limits = c('up', 'down', 'no'), 
                           values = c("red", 'blue', 'gray'), 
                           labels = c('Up', 'Down', 'Stable'))
p <- p + coord_polar(theta = 'y')
p <- p + blank_theme + labs(x = '', y = '', title = '')
#p <- p + scale_fill_brewer("Blues")
p <- p + theme(axis.text = element_blank()) 
#p <- p + geom_text(aes(y = diffPie$num/2 + c(0, cumsum(diffPie$num)[-length(diffPie$num)]), 
#                        x= sum(diffPie$num)/80, label = diffPie$num, size=1))  
p
