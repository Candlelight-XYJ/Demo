setwd("E:\\IOZ_lab\\yangby\\")
library(openxlsx)
options(stringsAsFactors = F)
## read diff genes
diffgenes <- read.csv("all_deseq_C12h_vs_RTF.csv")
## read annotations from fbgn
dmelanno <- read.csv("E:\\IOZ_lab\\公共数据\\dmelFBgn注释.csv")
dmelannotmp <-data.frame(symbol=dmelanno$gene_symbol,fbgn=dmelanno$primary_FBgn) 
## read GO annotations
goAnno <- read.csv("E:\\IOZ_lab\\公共数据\\fbgn的GO注释\\fbgn的GO注释.csv",header=F)

## read KO annotations
koAnno <- read.csv("E:\\IOZ_lab\\公共数据\\dmel_kegg处理后可使用的注释.csv")
#kosplit <- separate(koAnno,col=X,into=c("symbol","description"),sep=" ")
#kosplit2 <- separate(kosplit,col=X.1,into=c("KO","KO description"),sep=";")
#write.csv(kosplit2,"E:\\IOZ_lab\\公共数据\\dmel_kegg暂时注释.csv")

## 去重fbgn的注释
diffAnno <- merge(diffgenes,dmelannotmp,by.x="Row.names",by.y="fbgn",all=F)
allres <- diffAnno[!duplicated(diffAnno),]

## add GO annotation
resAddGO <- merge(allres,goAnno,by.x="Row.names",by.y="V2",all.x = T)
write.csv(resAddGO,"diffAddGO_C12h_vs_RTF.csv",row.names = F)

## add KO
## 用模式pattern识别去找
resAddKO <- data.frame()
for(i in 1:nrow(allres)){
  print(i)
  tmppos <- grep(allres[i,16],koAnno$X8,value=F)
  tmpData <- koAnno[tmppos,]
  tmpData$fbgn <- rep(allres[i,1],times=nrow(tmpData))
  tmpData$symbol <- rep(allres[i,16],times=nrow(tmpData))
  resAddKO <- rbind(resAddKO, tmpData)
}
write.csv(resAddKO,"diffAddKO_C12h_vs_RTF.csv")

## diff anno
diffgenes <- read.csv("E:\\IOZ_lab\\yangby\\10C12h_vs_RTF_all_diff.csv")
#xres <- merge(diffgenes,resAddGO,by.x = "Row.names",by.y="Row.names",all.x = T)
xres <- merge(allres,koAnno,by.x = "symbol",by.y = "symbol",all.x = T)
xxres <- merge(xres,koAnno,by.x = "symbol",by.y = "description",all.x = T)
koXres <- xxres[!duplicated(xxres),]
koXres1 <- koXres
koXres2 <- koXres

unionKO <- outer_join()


write.csv(koXres,"allDeseq_AddKO_C12h_vs_RTF.csv")


## 



