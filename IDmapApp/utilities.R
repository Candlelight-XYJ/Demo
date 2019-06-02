##setwd("E:\\学习资料存放处\\IDmap\\pipeAnno\\")
setwd("E:\\学习资料存放处\\IDmap\\注释存放处\\7_添加坐标后的最终注释\\")

## Load all data from dir
allfiles = list.files(getwd())
for(i in 1:length(allfiles)){
  eval(parse(text = paste0("load(","\'",allfiles[i],"\'",")")))
}

## covert .Rdata to .csv
datasets <- ls()
datasets <- datasets[c(-13,-14)] ## delete the element in vector
datasets

## 
 proteinDat <- lncRNA_human_protein
 noncDat <- lncRNA_human_nonc
 datNames <- names(proteinDat)
 allRes <- data.frame()

 for(j in 1:length(datNames)){
 print(j)      
 ## protein
 pAnno <- eval(parse(text = paste0("proteinDat","$",datNames[j])))
 pAnno$gpl <- rep(datNames[j],times=nrow(pAnno))
 pAnno$biotype <- rep("protein",times=nrow(pAnno))
 ## non-coding
 nAnno <- eval(parse(text = paste0("noncDat","$",datNames[j])))
 nAnno$gpl <- rep(datNames[j],times=nrow(nAnno))
 nAnno$biotype <- rep("nonc",times=nrow(nAnno))
 ## combine protein & non-coding
 combineRes <- rbind(pAnno,nAnno)
 allRes <- rbind(allRes,combineRes)
 }
write.csv(allRes,"E:\\学习资料存放处\\IDmap\\mySQL_table\\lncRNA_human_AllData.csv",row.names=F)


###################################
##### 将Rdata数据转为csv输出
##### 仅按物种分类，将公司加在后面

rm(list=ls())
setwd("E:\\学习资料存放处\\IDmap\\注释存放处\\7_添加坐标后的最终注释\\")
## Load all data from dir
allfiles = list.files(getwd())
for(i in 1:length(allfiles)){
  print(i)
  eval(parse(text = paste0("load(","\'",allfiles[i],"\'",")")))
}

## covert .Rdata to .csv
datasets <- ls()
datasets <- datasets[c(-7,-8,-10,-19)] ## delete the element in vector
datasets

datNames <- names(illumina_rat_anno)
allRes <- data.frame()

for(j in 1:length(datNames)){
  print(j)      
  ## Anno
  Anno <- eval(parse(text = paste0("illumina_rat_anno","$",datNames[j])))
  Anno$gpl <- rep(datNames[j],times=nrow(Anno))
  allRes <- rbind(allRes,Anno)
}
write.csv(allRes,"E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\Illumina_rat_anno.csv",row.names=F)



#allfiles <- list.files(getwd())
setwd("E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\")
options(stringsAsFactors = F)
affy <- read.csv("affy_rat_anno.csv")
illumina <- read.csv("illumina_rat_anno.csv")
agilent <- read.csv("agilent_rat_anno.csv")
lncRNA <- read.csv("lncRNA_rat_anno.csv")


## add company
#affy$company <- rep("affymetrix",times=nrow(affy))
#illumina$company <- rep("illumina",times=nrow(illumina))
#agilent$company <- rep("agilent",times=nrow(agilent))
#lncRNA$company <- rep("lncRNA",times=nrow(lncRNA))


## bind all files
tmpRes <- rbind(affy,illumina)
allXres <- rbind(agilent,tmpRes)
##allXres <- rbind(tmpRes,tmpRes2)

save(allXres,file="rat_all_anno.Rdata",overwrite=T)
save(lncRNA,file="rat_lncRNA_anno.Rdata",overwrite=T)



###########################
###  check annotations  ###
###########################
rm(list=ls())
setwd("E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\rdata\\")
## Load all data from dir
#allfiles = list.files(getwd())
#for(i in 1:length(allfiles)){
#  print(i)
#  eval(parse(text = paste0("load(","\'",allfiles[i],"\'",")")))
#}
load("human_all_anno.Rdata")

##datNames <- names(affy_human_anno)
##allRes <- data.frame()
#gpl <- allXres[!duplicated(allXres$gpl),14]
#tmpHead <- data.frame()
#for(i in 1:length(gpl)){
#  print(i)
#  tmp <- allXres[which(allXres$gpl==gpl[i]),]
#  tmpHead <- rbind(head(tmp,n=30),tmpHead)
  
#}

#gpl <- lncRNA[!duplicated(lncRNA$gpl),14]
#tmpHead <- data.frame()
#for(i in 1:length(gpl)){
#  print(i)
#  tmp <- lncRNA[which(lncRNA$gpl==gpl[i]),]
#  tmpHead <- rbind(head(tmp,n=30),tmpHead)
#  
#}

#write.csv(tmpHead,"check_rat_lncRNA注释.csv")

tmp <- lncRNA[which(lncRNA$gpl=="GPL22613"),]

#############
##-- LOG --##
#############

## human
## GPL8179 & GPL8178 softAnno is probe id
## GPL93,94,92,95,97 softAnno NA的地方变成了 --- ,要改成NA

## mouse
## GPL8180 ,8181, softAnno is probe id
## GPL82, softAnno NA的地方变成了 --- ,要改成NA

## rat
## GPL1355 pipeAnno and biotype has ;
## GPL14187 GPL16985, should be rearranged, pipeAnno is none
## GPL85,GPL86 ,GPL87,GPL89 should be rearranged and the softAnno --- should be change as NA

## human LncRNA
## GPL1783,GPL18084,softAnno 重新取
## GPL7850 softAnno has entrezId, can be convert2symbol 
## GPL19612 softAnno 重新取geneSymbol
## 19946 GB_accession
## GPL19920,softAnno GeneName ; 
## GPL21096 softAnno Target ID; GPL21047 softAnno GeneName;20115 softAnno GeneSymbol
## GPL22755 softAnno GeneSymbol; GPL23292 softAnno LncRNA_ID

## mouse LncRNA
## GPL21994,SoftAnno Symbol

## rat LncRNA
## GPL19503 Symbol


########################
## Change Annotations ##
########################

#tmp <- allXres[which(allXres$gpl=="GPL93"),]
#options(stringsAsFactors = F)
#softAnno <- read.csv("E:/学习资料存放处/IDmap/注释存放处/6_soft整理后的结构化注释存放处/humanAffy/GPL93.csv")
#tmp[which(tmp$softAnno=="---"),3] <- "NA"

rm(list=ls())
setwd("E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\rdata_AfterCheck\\")


#allXres[which(allXres$softAnno=="---"),3]<- NA
## rat
## GPL1355 pipeAnno and biotype has ; ok
## GPL14187 GPL16985, should be rearranged, pipeAnno is none
## GPL85,GPL86 ,GPL87,GPL89 should be rearranged and 
##【the softAnno --- should be change as NA,ok】

#tmp <- allXres[which(allXres$gpl=="GPL1355"),]
## GPL14187 GPL16985, should be rearranged, pipeAnno is none
#tmpzz <- rat_all_anno[which(rat_all_anno$gpl=="GPL14187"),]
library(tidyverse)
pipefile <- read.csv("E:/学习资料存放处/IDmap/注释存放处/5_所有自主注释存放处/rat_affy/GPL89anno.csv",head=F)
tmp <- pipefile

tmp <- separate(data = pipefile, col = V4, into = c("num", "spot_id","seq_name"), sep = ":")

chr <- rep("chr",times=nrow(tmp))
tmp$chr=paste0(chr,as.character(tmp$V1))

pipeAnno <- data.frame(spot_id = tmp$seq_name, gene_symbol = tmp$V11,
                       chr=tmp$chr,
                       probe_start=tmp$V2,probe_end=tmp$V3,strand=tmp$V6,
                       gencode_chr=paste0(chr,as.character(tmp$V7)),gencode_start=tmp$V8,gencode_end=tmp$V9,
                       ensembl_id=tmp$V10,biotype=tmp$V12
) 


softfile <- read.csv("E:/学习资料存放处/IDmap/注释存放处/6_soft整理后的结构化注释存放处/ratAffy/GPL89.csv")
softfile[softfile==""]<-NA


softAnno <- data.frame(probeid = softfile$Probe.Set.ID,
                       gene_symbol = softfile$Gene.Symbol) 


removeRep <- function(df){
  dupProbe <- df[!duplicated(df),]
}
load("E:\\学习资料存放处\\IDmap\\注释存放处\\7_添加坐标后的最终注释\\all_probeid2symbol.Rdata")
biocAnno <- rat_dat[rat_dat$gpl=="GPL89",]

## merge
#tmpdf <- data.frame()
#tmpdf <- merge(pipeAnno, softAnno, by.x = "spot_id", by.y = "probeid", all = T)
#tmpdf <- removeRep(tmpdf)
#res_df <- data.frame(probe_id = tmpdf$spot_id, 
#                     pipeAnno = tmpdf$gene_symbol.x, 
#                     softAnno = tmpdf$gene_symbol.y,
#                     biocAnno = rep(NA,times=nrow(tmpdf)),
#                     chr=tmpdf$chr,probe_start=tmpdf$probe_start,probe_end=tmpdf$probe_end,strand=tmpdf$strand,
#                     gencode_chr=tmpdf$gencode_chr,gencode_start=tmpdf$gencode_start,gencode_end=tmpdf$gencode_end,
#                     ensembl_id=tmpdf$ensembl_id,biotype=tmpdf$biotype
#)
tmpdf <- data.frame()
tmpdf <- merge(pipeAnno, softAnno, by.x = "spot_id", by.y = "probeid", all = T)
# 加入biocAnno
tmpdf <- merge(tmpdf, biocAnno, by.x = "spot_id", by.y = "probe_id", all = T)
tmpdf <- removeRep(tmpdf)
res_df <- data.frame(probe_id = tmpdf$spot_id, 
                     pipeAnno = tmpdf$gene_symbol.x, 
                     softAnno = tmpdf$gene_symbol.y,
                     biocAnno = tmpdf$symbol,
                     chr=tmpdf$chr,probe_start=tmpdf$probe_start,probe_end=tmpdf$probe_end,strand=tmpdf$strand,
                     gencode_chr=tmpdf$gencode_chr,gencode_start=tmpdf$gencode_start,gencode_end=tmpdf$gencode_end,
                     ensembl_id=tmpdf$ensembl_id,biotype=tmpdf$biotype
)




res_df$gpl <- rep("GPL89",times=nrow(res_df))

GPL89 <- res_df
GPL89[which(GPL89$softAnno=="---"),3] <-NA
#rat_all_anno <- allXres
#save(rat_all_anno,file="E:/学习资料存放处/IDmap/注释存放处/8_MySQL_table最新版/rdata_AfterCheck/rat_all_anno.Rdata" )
save(GPL89,file="GPL89.Rdata")


################################
load("E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\rdata_AfterCheck\\rat_all_anno.Rdata")
load("GPL85.Rdata")
load("GPL86.Rdata")
load("GPL87.Rdata")
load("GPL89.Rdata")


tmp <- rat_all_anno[which(rat_all_anno$gpl=="GPL85"),]

#nrow(GPL85[!duplicated(GPL85$probe_id),])
#nrow(tmp[!duplicated(tmp$probe_id),])

## GPL85
tmpRat <- rat_all_anno[-which(rat_all_anno$gpl=="GPL85"),]
tmpRat <- rbind(tmpRat,GPL85)

## GPL86
tmpRat <- tmpRat[-which(tmpRat$gpl=="GPL86"),]
tmpRat <- rbind(tmpRat,GPL86)

## GPL87
tmpRat <- tmpRat[-which(tmpRat$gpl=="GPL87"),]
tmpRat <- rbind(tmpRat,GPL87)

## GPL89
tmpRat <- tmpRat[-which(tmpRat$gpl=="GPL89"),]
tmpRat <- rbind(tmpRat,GPL89)

nrow(tmpRat[!duplicated(tmpRat$gpl),])
#nrow(rat_all_anno[!duplicated(rat_all_anno$gpl),])

save(tmpRat,file="rat_all_anno.Rdata",overwrite=T)




###############################################################
## human LncRNA
## GPL17843,GPL18084,softAnno 重新取
## GPL7850 softAnno has entrezId, can be convert2symbol 
## GPL19612 softAnno 重新取geneSymbol
## 19946 GB_accession
## GPL19920,softAnno GeneName ; 
## GPL21096 softAnno Target ID; GPL21047 softAnno GeneName;20115 softAnno GeneSymbol
## GPL22755 softAnno GeneSymbol; GPL23292 softAnno LncRNA_ID
rm(list=ls())
load("E:/学习资料存放处/IDmap/注释存放处/8_MySQL_table最新版/rdata/human_lncRNA_anno.Rdata")
gpllist <- c("GPL17843","GPL18084","GPL17850","GPL19612",#"GPL19946",
             "GPL19920","GPL21096","GPL21047","GPL20115","GPL22755","GPL23292")
setwd("E:\\学习资料存放处\\IDmap\\注释存放处\\6_soft整理后的结构化注释存放处\\humanlncRNA\\")
options(stringsAsFactors = F)

for(i in 1:length(gpllist)){
  eval(parse(text=paste0(gpllist[i],"<-","lncRNA[which(lncRNA$gpl==","\'",gpllist[i],"\'","),]")))
}


softfile <- read.csv("GPL23292_probe_anno.csv")
softAnno <- data.frame(probeid = softfile$ID,
                       gene_symbol = softfile$lncRNA.ID) 

GPL23292$softAnno <- NULL
tmpdf<-merge(GPL23292,softAnno,by.x="probe_id",by.y = "probeid",all=T)

lncrnaRes <- data.frame(probe_id = tmpdf$probe_id, 
                                   pipeAnno = tmpdf$pipeAnno, 
                                   softAnno = tmpdf$gene_symbol,
                                   biocAnno = tmpdf$biocAnno,
                                   chr=tmpdf$chr,probe_start=tmpdf$probe_start,
                                   probe_end=tmpdf$probe_end,strand=tmpdf$strand,
                                   gencode_chr=tmpdf$gencode_chr,gencode_start=tmpdf$gencode_start,gencode_end=tmpdf$gencode_end,
                                   ensembl_id=tmpdf$ensembl_id,biotype=tmpdf$biotype)
GPL23292lncRNA <- lncrnaRes
save(GPL23292lncRNA,file="E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\rdata_AfterCheck\\GPL23292.Rdata")

##########################
##########################


setwd("E:/学习资料存放处/IDmap/注释存放处/8_MySQL_table最新版/rdata_AfterCheck/humanLncRNA/")
load("E:/学习资料存放处/IDmap/注释存放处/8_MySQL_table最新版/rdata/human_lncRNA_anno.Rdata")

allfiles = list.files(getwd())
for(i in 1:length(allfiles)){
  print(i)
  eval(parse(text = paste0("load(","\'",allfiles[i],"\'",")")))
}

for(j in 3:length(allfiles)){
  gplnum <- strsplit(allfiles[j],".Rdata")[[1]]
  print(gplnum)
  eval(parse(text = paste0(gplnum,"lncRNA$gpl <- ","rep(\'",gplnum,"\',times=nrow(",gplnum,"lncRNA","))")))
 
}

zz <-data.frame()
for(i in 3:length(allfiles)){
  gplnum <- strsplit(allfiles[i],".Rdata")[[1]]
  print(gplnum)
  gpldat <- paste0(strsplit(allfiles[i],".Rdata")[[1]],"lncRNA")
  eval(parse(text=paste0("zz<-rbind(zz",",",gpldat,")")))
}



##delete
#tmpHuman <- lncRNA[which(lncRNA$gpl=="GPL14187"),]
#tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL16985"),]
tmpHuman <- lncRNA[-which(lncRNA$gpl=="GPL17843"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL17850"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL18084"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL19612"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL19920"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL20115"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL21047"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL21096"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL22755"),]
tmpHuman <- tmpHuman[-which(tmpHuman$gpl=="GPL23292"),]

human_lncRNA_anno <- rbind(tmpHuman, zz)
save(human_lncRNA_anno,file="E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\rdata_AfterCheck\\human_lncRNA_anno.Rdata")
#[1] "GPL17843"
#[1] "GPL17850"
#[1] "GPL18084"
#[1] "GPL19612"
#[1] "GPL19920"
#[1] "GPL20115"
#[1] "GPL21047"
#[1] "GPL21096"
#[1] "GPL22755"
#[1] "GPL23292"


load("E:/学习资料存放处/IDmap/注释存放处/8_MySQL_table最新版/rdata_AfterCheck/rat_all_anno.Rdata")



## mouse LncRNA
## GPL21994,SoftAnno Symbol

## rat LncRNA
## GPL19503 Symbol

load("E:/学习资料存放处/IDmap/注释存放处/8_MySQL_table最新版/rdata/rat_lncRNA_anno.Rdata")
softfile <- read.csv("E:/学习资料存放处/IDmap/注释存放处/4_soft原始注释Anno存放处/ratlncRNA/GPL19503_probe_anno.csv")
softAnno <- data.frame(probeid = softfile$ID,
                       gene_symbol = softfile$GeneSymbol) 
GPL19503 <- lncRNA[which(lncRNA$gpl=="GPL19503"),]

GPL19503$softAnno <- NULL
tmpdf<-merge(GPL19503,softAnno,by.x="probe_id",by.y = "probeid",all=T)

lncrnaRes <- data.frame(probe_id = tmpdf$probe_id, 
                        pipeAnno = tmpdf$pipeAnno, 
                        softAnno = tmpdf$gene_symbol,
                        biocAnno = tmpdf$biocAnno,
                        chr=tmpdf$chr,probe_start=tmpdf$probe_start,
                        probe_end=tmpdf$probe_end,strand=tmpdf$strand,
                        gencode_chr=tmpdf$gencode_chr,gencode_start=tmpdf$gencode_start,gencode_end=tmpdf$gencode_end,
                        ensembl_id=tmpdf$ensembl_id,biotype=tmpdf$biotype)
GPL19503lncRNA <- lncrnaRes
GPL19503lncRNA$gpl <- rep("GPL19503",times=nrow(GPL19503lncRNA))


tmprat <- lncRNA[-which(lncRNA$gpl=="GPL19503"),]

rat_lncRNA_anno <- rbind(tmprat,GPL19503lncRNA)
save(rat_lncRNA_anno,file="E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\rdata_AfterCheck\\rat_lncRNA_anno.Rdata")


rat_all_anno <- tmpRat
colnames(rat_all_anno) <- c("probe_id", 
                            "pipeAnno", 
                            "softAnno",
                            "biocAnno",
                            "chr","probe_start",
                            "probe_end","strand",
                            "ensembl_chr","ensembl_start","ensembl_end",
                            "ensembl_id","biotype","gpl")
save(rat_all_anno,file="E:\\学习资料存放处\\IDmap\\注释存放处\\8_MySQL_table最新版\\rdata_AfterCheck\\rat_all_anno.Rdata")

