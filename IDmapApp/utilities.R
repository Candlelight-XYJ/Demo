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
load("mouse_lncRNA_anno.Rdata")

##datNames <- names(affy_human_anno)
##allRes <- data.frame()
#gpl <- allXres[!duplicated(allXres$gpl),14]
#tmpHead <- data.frame()
#for(i in 1:length(gpl)){
#  print(i)
#  tmp <- allXres[which(allXres$gpl==gpl[i]),]
#  tmpHead <- rbind(head(tmp,n=30),tmpHead)
  
#}

gpl <- lncRNA[!duplicated(lncRNA$gpl),14]
tmpHead <- data.frame()
for(i in 1:length(gpl)){
  print(i)
  tmp <- lncRNA[which(lncRNA$gpl==gpl[i]),]
  tmpHead <- rbind(head(tmp,n=30),tmpHead)
  
}

write.csv(tmpHead,"check_mouse_lncRNA注释.csv")

tmp <- lncRNA[which(lncRNA$gpl=="GPL22755"),]

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




