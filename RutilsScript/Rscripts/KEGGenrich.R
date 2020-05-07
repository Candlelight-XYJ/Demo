rm(list=ls())
setwd("C:/Users/Administrator/Desktop/KEGG/")
options(stringsAsFactors = F)
library(clusterProfiler)

## readfiles
dat <- read.table("id44",sep="\t")

## read all_GO files
#allGO <- read.table("kegg.k.format",sep="\t")
#go2geneid = data.frame(GOID=allGO$V2, GeneID=allGO$V1)
#go2description = data.frame(GOID=allGO$V2, description=allGO$V2)
#goRes <- enricher(dat[,1],TERM2GENE = go2geneid)
#goRes <- enricher(dat[,1],TERM2GENE = go2geneid,TERM2NAME = go2description)
#barplot(goRes)
#write.csv(goRes,"up_DEG.id_KEGG.csv")


#kk <- enrichKEGG(dat[,1], 
#                 organism="dosa", 
#                 keyType = "kegg",
#                 pvalueCutoff=0.05, 
#                 pAdjustMethod="BH", 
#                 qvalueCutoff=0.1)

kk <- enrichKEGG(dat[,1], 
                 organism="dosa", 
                 keyType = "kegg",
                 pvalueCutoff=0.05, 
                 pAdjustMethod="BH", 
                 qvalueCutoff=0.1)

barplot(kk,showCategory = 30)
write.csv(kk@result,"id44_KEGG.csv")
