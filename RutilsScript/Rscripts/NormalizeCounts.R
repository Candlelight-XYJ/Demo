##'@details https://hbctraining.github.io/DGE_workshop/lessons/02_DGE_count_normalization.html

rm(list=ls())
library(DESeq2)
countsDat <- read.table("C:/Users/Administrator/Desktop/Common.peak.id.counts",sep="\t",header=T,row.names = 1)

countsDat<-round(countsDat,digits=0) 
#化作矩阵格式
countsDat<-as.matrix(countsDat) 

#建立环境
condition<-factor(c(rep("CK",4), rep("CK_m6A",4),rep("RSV",4),rep("RSV_m6A",4))) 
coldata<-data.frame(row.names=colnames(countsDat),condition) 

#coldata
#condition

##构建dds矩阵
dds<-DESeqDataSetFromMatrix(countsDat, coldata, design=~condition)
## 标准化
dds <- estimateSizeFactors(dds)
sizeFactors(dds)
normalized_counts <- counts(dds, normalized=TRUE)
write.table(normalized_counts,"normalized_counts.Common.peak.id.counts.txt", sep="\t",quote=F)

