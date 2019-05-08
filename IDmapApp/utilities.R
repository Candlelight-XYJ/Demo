setwd("E:\\学习资料存放处\\IDmap\\pipeAnno\\")

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


##### 仅按物种分类，将公司加在后面
rm(list=ls())
setwd("E:\\学习资料存放处\\IDmap\\mySQL_table\\整理表格_仅按物种分类\\")

allfiles <- list.files(getwd())
options(stringsAsFactors = F)
affy <- read.csv("affy_rat_AllData.csv")
illumina <- read.csv("illumina_rat_AllData.csv")
agilent <- read.csv("agilent_rat_AllData.csv")
lncRNA <- read.csv("lncRNA_rat_AllData.csv")


## add company
affy$company <- rep("affymetrix",times=nrow(affy))
illumina$company <- rep("illumina",times=nrow(illumina))
agilent$company <- rep("agilent",times=nrow(agilent))
lncRNA$company <- rep("lncRNA",times=nrow(lncRNA))


## bind all files
tmpRes <- rbind(affy,illumina)
tmpRes2 <- rbind(agilent,lncRNA)
allXres <- rbind(tmpRes,tmpRes2)

write.csv(allXres,"rat_All_anno.csv")






