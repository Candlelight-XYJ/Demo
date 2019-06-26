#######################################################
## step1 - use Rbowtie::bowtie_build to build index  ##
#######################################################
getBowtieIndex <- function(UsrGenome){
  indexDir <- tempdir()
  tmp <- Rbowtie::bowtie_build(references = UsrGenome, outdir = indexDir, prefix = "index", 
                               force = TRUE)
  return(indexDir)
}

#################################################
## step2 - use Rbowite::bowtie to align reads  ##
#################################################
getBowtieAlign <- function(probeSeq, indexDir){
  readsFiles <- probeSeq
  ## use tempfile to save sam files created by bowtie
  samFile <- tempfile()
  ## align probe sequences to genome
  Rbowtie::bowtie(sequences = readsFiles, index = file.path(indexDir, "index"), outfile = samFile, 
                  type = "single", S = TRUE, f = TRUE, n = 0, force = TRUE)
  return(samFile)
}

  
#################################################  
## step3 - read GTF file into ensemblGenome object ens <- ensemblGenome()
## read.gtf(ens,useBasedir = F,filename =
## 'C:/Users/Administrator/Desktop/testBowtie/test.gtf',sep = '\t') gtfFile =
## 'C:/Users/Administrator/Desktop/testBowtie/test.gtf' gtf <- fread(gtfFile,sep = '\t')
## zz <- read.gtf(ens,useBasedir = F,filename="E:\\test.gtf",sep="\t")
preprocessGTF <- function(gtf){
  gtf_genes <- gtf[which(gtf[, 3] == "gene"), ]
  tmp <- separate(gtf_genes, col = V9, into = c("gene_id", "gene_type", "gene_name", "other"), 
                  sep = ";")
  my_gene <- separate(tmp, col = gene_name, into = c("zz", "gene_name"), sep = "gene_name", 
                      quote = F)
  ## delete quotes in gene symbol
  gene_name <- str_replace(my_gene$gene_name,"\"","")
  gene_name <- str_replace(gene_name,"\"","")
  gene_name <- str_trim(gene_name)
  my_gene$gene_name <- gene_name
  
  gtf2GR <- with(my_gene, GRanges(V1, IRanges(V4, V5), V7, id = gene_name))
  return(gtf2GR)
}

#############################################
## step4 - convert bam into Ranges Object  ##
#############################################
convertBamToGR <- function(samFile){
  bamtemp <- tempdir()
  bamFile <- Rsamtools::asBam(file = samFile, destination = bamtemp, overwrite = T)
  bam <- scanBam(bamFile)
  # names(bam[[1]])
  tmp = as.data.frame(do.call(cbind, lapply(bam[[1]], as.character)), stringsAsFactors = F)
  tmp = tmp[tmp$flag != 4, ]
  tmp$end = as.numeric(tmp$pos) + as.numeric(tmp$qwidth)
  # create .bam GRanges Objects
  Bam2GR <- with(tmp, GRanges(as.character(rname), IRanges(as.numeric(pos), end), as.character(strand), 
                              id = as.character(qname)))
  return(Bam2GR)
}

#################################################  
## step5 - intersect() on two GRanges objects  ##
#################################################
getAnnotation <- function(Bam2GR,gtf2GR){
  gr3 = intersect(Bam2GR, gtf2GR)
  o = findOverlaps(Bam2GR, gtf2GR)
  lo = cbind(as.data.frame(Bam2GR[queryHits(o)]), as.data.frame(gtf2GR[subjectHits(o)]))
  # head(lo)
  colnames(lo) <- c("probe_chr", "probe_start" ,"probe_end","probe_width","probe_strand" 
                    ,"probe_id" ,"gencode_chr","gencode_start" ,"gencode_end" 
                    ,"gencode_width","gencode_strand","gene_name")
  return(lo)
}

  
  
