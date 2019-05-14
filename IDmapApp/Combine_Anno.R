#### 2019.05.11
#### 重新封装注释

rm(list = ls())
library(tidyverse)
library(openxlsx)
options(stringsAsFactors = F)
load("E:\\学习资料存放处\\IDmap\\注释存放处\\all_probeid2symbol.Rdata")
gpllist <- read.csv("E:\\学习资料存放处\\IDmap\\ALL_GPL_LIST.csv")

##########################
## judge if has spot id ##
##########################

judge_spotid <- function(df){
  flag = 0
  tmp <- separate(data = df, col = V4, into = c("num", "spot_id","seq_name"), sep = ":")
  if(tmp$spot_id[1]=="nospot"){
    flag = 1
  }
  if(nchar(tmp$spot_id[1]) == 0){
    flag = 1
  }
  return(flag)
}

##########################
##     去除重复探针     ##
##########################

removeRep <- function(df){
  dupProbe <- df[!duplicated(df),]
}

lncRNA_human_anno <- list()
lncRNA_mouse_anno <- list()
lncRNA_rat_anno <- list()

## 1.设置本次注释的目录，
setwd("E:\\学习资料存放处\\IDmap\\注释存放处\\5_所有自主注释存放处\\rat_lncRNA\\")
allfiles=list.files(getwd())

## 2.读入注释

for(i in 1:length(allfiles)){
  # i=1
  print(i)
  gplnum <- strsplit(allfiles[i],"_")[[1]][1]
  # 读入自主注释
  pipefile <- read.table(allfiles[i],stringsAsFactors = F,header = F,fill = T)
  # 自主注释数据预处理
  flag = judge_spotid(pipefile)
  tmp <- separate(data = pipefile, col = V4, into = c("num", "spot_id","seq_name"), sep = ":")
  
  ## 大鼠加上chr
  chr <- rep("chr",times=nrow(tmp))
  tmp$chr=paste0(chr,as.character(tmp$V1))
  
  if(flag == 1){
    #pipeAnno <- data.frame(spot_id = tmp$num, gene_symbol = tmp$V14,
    #                       chr=tmp$V1,probe_start=tmp$V2,probe_end=tmp$V3,strand=tmp$V6,
    #                       gencode_chr=tmp$V7,gencode_start=tmp$V8,gencode_end=tmp$V9,
    #                       ensembl_id=tmp$V10,biotype=tmp$V12
    #                       ) 
    pipeAnno <- data.frame(spot_id = tmp$num, gene_symbol = tmp$V12,
                           chr=tmp$chr,probe_start=tmp$V2,probe_end=tmp$V3,strand=tmp$V6,
                           gencode_chr=tmp$chr,gencode_start=tmp$V8,gencode_end=tmp$V9,
                           ensembl_id=tmp$V10,biotype=tmp$V14
                           ) 
    
    
  }else{
    #pipeAnno <- data.frame(spot_id = tmp$spot_id,  gene_symbol = tmp$V14,
    #                       chr=tmp$V1,probe_start=tmp$V2,probe_end=tmp$V3,strand=tmp$V6,
    #                       gencode_chr=tmp$V7,gencode_start=tmp$V8,gencode_end=tmp$V9,
    #                       ensembl_id=tmp$V10,biotype=tmp$V12) 
    
    pipeAnno <- data.frame(spot_id = tmp$seq_name,  gene_symbol = tmp$V12,
                           chr=tmp$chr,probe_start=tmp$V2,probe_end=tmp$V3,strand=tmp$V6,
                           gencode_chr=tmp$chr,gencode_start=tmp$V8,gencode_end=tmp$V9,
                           ensembl_id=tmp$V10,biotype=tmp$V14) 
    
  }
  
  # 读入soft注释
  softfile <- read.csv(paste0("E:\\学习资料存放处\\IDmap\\注释存放处\\4_soft原始注释Anno存放处\\ratlncRNA\\"
                              ,gplnum,"_probe_anno.csv"))
  softfile[softfile==""]<-NA
  ## merge pipeAnno and softAnno
  aname <- colnames(softfile)
  # judge the colname
  if("ID" %in% aname)
  {
    ID = softfile$ID
  }
  if("SPOT_ID" %in% aname)
  {
    SPOT_ID = softfile$SPOT_ID
  }else{
    SPOT_ID = rep("nospot",times=nrow(softfile))
  }
  if("NAME" %in% aname)
  {
    NAME = softfile$NAME 
    
  }else{
    NAME = rep("noname",times=nrow(softfile))
  }
  if("SEQUENCE" %in% aname){
    probeSEQUENCE = softfile$SEQUENCE
  }else{
    probeSEQUENCE = rep("noseq",times=nrow(softfile))
  }
  if("Symbol" %in% aname){
    gene_symbol = softfile$Symbol
  }
  if("GENE_SYMBOL" %in% aname){
    gene_symbol = softfile$GENE_SYMBOL
  }
  if("SYMBOL" %in% aname){
    gene_symbol = softfile$SYMBOL
  }
  if("GeneName" %in% aname){
    gene_symbol = softfile$GeneName
  }
  
  ## 判断soft的哪列与pipeAnno的探针id匹配
  IDlen <- length(intersect(ID, pipeAnno$spot_id))
  spotidlen <- length(intersect(SPOT_ID, pipeAnno$spot_id))
  namelen <- length(intersect(NAME, pipeAnno$spot_id))
  
  if(IDlen >= spotidlen & IDlen >= namelen){
    
    softAnno <- data.frame(probeid = ID,
                           gene_symbol = gene_symbol) 
  }
  
  
  if( spotidlen >= IDlen & spotidlen >= namelen){
    
    softAnno <- data.frame(probeid = SPOT_ID,
                           gene_symbol = gene_symbol) 
    
    # softAnno <- data.frame(probeid = SPOT_ID,
    #                        gene_symbol = softfile$GeneName) 
    
  }
  
  if( namelen >= IDlen & namelen >= spotidlen ){
    
    softAnno <- data.frame(probeid = NAME,
                           gene_symbol = gene_symbol) 
  }
  
  ############################
  ##  读入bioconductor注释  ##
  ############################
  
  # 判断是否有bioconductor注释
  # gplnum = gpl号码, ex : GPL10332
  # gpllist = gpl总版清单
  # gpl = colname ,含有gpl号码那一列的列名
  
  judge_biocpac <- function(gplnum,gpllist,gpl){
    flag = 1
    tmpbioc <- eval(parse(text = "gpllist[which(gpllist$gpl == gplnum),7]"))
    #print(tmpbioc)
    if(nchar(tmpbioc) == 0) {
      flag =0}
    return(flag)
  }
  
  # 读入注释，注意物种
  
  if(judge_biocpac(gplnum,gpllist,gpl)){
    
    # biocAnno <- human_dat[which(human_dat$gpl == gplnum),]  
    biocAnno <-rat_dat[grep(gplnum,rat_dat$gpl),]
    # biocAnno <- mouse_add_gpl[which(mouse_add_gpl$gpl == gplnum),] 
    # biocAnno <- rat_add_gpl[which(rat_add_gpl$gpl == gplnum),] 
    
  }else{
    biocAnno <- NA  
  }
  
  
  ########################################################
  ##   merge soft,bioconductor,pipeline  by probe name  ##
  ########################################################
  
  if(is.na(biocAnno)){
  
    tmpdf <- data.frame()
    tmpdf <- merge(pipeAnno, softAnno, by.x = "spot_id", by.y = "probeid", all = T)
    tmpdf <- removeRep(tmpdf)
    res_df <- data.frame(probe_id = tmpdf$spot_id, 
                         pipeAnno = tmpdf$gene_symbol.x, 
                         softAnno = tmpdf$gene_symbol.y,
                         biocAnno = rep(NA,times=nrow(tmpdf)),
                         chr=tmpdf$chr,probe_start=tmpdf$probe_start,probe_end=tmpdf$probe_end,strand=tmpdf$strand,
                         gencode_chr=tmpdf$gencode_chr,gencode_start=tmpdf$gencode_start,gencode_end=tmpdf$gencode_end,
                         ensembl_id=tmpdf$ensembl_id,biotype=tmpdf$biotype
                         )
  }else{
    ####### 如果有bioconductor注释 #########
    
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
  }
  eval(parse(text=paste0("lncRNA_rat_anno$",gplnum," <- res_df ")))
 
}
save(lncRNA_rat_anno,file = "E:\\学习资料存放处\\IDmap\\注释存放处\\lncRNA_rat.Rdata",overwrite=T)



