#################################
#### last update in April 27 #### 
#################################

library(shiny)
library(shinydashboard)
library(shinyFiles)
library(DT)
library(Rbowtie)
library(data.table)
library(Rsamtools)
library(refGenome)
library(GenomicRanges)
library(tidyverse)
library(Sushi)
# library(IDmap)


## Limit the size of load data in 50M
options(shiny.maxRequestSize = 50 * 1024^2)

##############################
#### Load files from path #### 
##############################

## Load GPL list
shinyServer(function(input, output, session) {
    
    output$mytable = DT::renderDataTable({
        return(mtcars)
    })
    
    volumes = getVolumes()
    
    ## Load users` fasta files
    loadProbeSeq <- reactive({
        req(input$probeseq$datapath)
        # seqfa <- read.table(input$probeseq$datapath, sep = '\n')
        return(input$probeseq$datapath)
    })
    
    ## Load Genome
    loadUsrGenome <- reactive({
        shinyFileChoose(input, "genome", roots = volumes, session = session)
        req(as.character(parseFilePaths(volumes, input$genome)$datapath))
    })
    output$showGenomePath <- renderText(loadUsrGenome())
    
    ## Load GTF
    loadUsrGTF <- reactive({
        req(input$gtf)
        gtfFile <- data.table::fread(input$gtf$datapath, sep = "\t")
        return(gtfFile)
    })
    
    
##########################
## steps for annotating ##
##########################    

## step1 - use Rbowtie to build index & align reads
    getBowtieIndex <- reactive({
        req(loadUsrGenome())
        indexDir <- tempdir()
        tmp <- Rbowtie::bowtie_build(references = loadUsrGenome(), outdir = indexDir, prefix = "index", 
            force = TRUE)
        return(indexDir)
    })
    
    getBowtieAlign <- reactive({
        req(loadProbeSeq())
        readsFiles <- loadProbeSeq()
        samFile <- tempfile()
        Rbowtie::bowtie(sequences = readsFiles, index = file.path(getBowtieIndex(), "index"), outfile = samFile, 
            type = "single", S = TRUE, f = TRUE, n = 0, force = TRUE)
        return(samFile)
    })
    
    
    
    ## step2 - read GTF file into ensemblGenome object ens <- ensemblGenome()
    ## read.gtf(ens,useBasedir = F,filename =
    ## 'C:/Users/Administrator/Desktop/testBowtie/test.gtf',sep = '\t') gtfFile =
    ## 'C:/Users/Administrator/Desktop/testBowtie/test.gtf' gtf <- fread(gtfFile,sep = '\t')
    preprocessGTF <- reactive({
        gtf <- loadUsrGTF()
        gtf_genes <- gtf[which(gtf[, 3] == "gene"), ]
        tmp <- separate(gtf_genes, col = V9, into = c("gene_id", "gene_type", "gene_name", "other"), 
            sep = ";")
        my_gene <- separate(tmp, col = gene_name, into = c("zz", "gene_name"), sep = "gene_name", 
            quote = F)
        my_gr <- with(my_gene, GRanges(V1, IRanges(V4, V5), V7, id = gene_name))
        return(my_gr)
    })
    
    
    ## step3 - convert bam into Ranges Object
    convertBamToGR <- reactive({
        bamtemp <- tempdir()
        bamFile <- Rsamtools::asBam(file = getBowtieAlign(), destination = bamtemp, overwrite = T)
        bam <- scanBam(bamFile)
        # names(bam[[1]])
        tmp = as.data.frame(do.call(cbind, lapply(bam[[1]], as.character)), stringsAsFactors = F)
        tmp = tmp[tmp$flag != 4, ]
        tmp$end = as.numeric(tmp$pos) + as.numeric(tmp$qwidth)
        # create .bam GRanges Objects
        my_seq <- with(tmp, GRanges(as.character(rname), IRanges(as.numeric(pos), end), as.character(strand), 
            id = as.character(qname)))
        return(my_seq)
    })
    
    
    ## step4 - intersect() on two GRanges objects.
    
    getAnnotation <- reactive({
        gr3 = intersect(convertBamToGR(), preprocessGTF())
        o = findOverlaps(convertBamToGR(), preprocessGTF())
        lo = cbind(as.data.frame(convertBamToGR()[queryHits(o)]), as.data.frame(preprocessGTF()[subjectHits(o)]))
        # head(lo)
        return(lo)
    })
    
####################
##     output     ##
####################  
    
    output$viewBed <- renderPlot({
        plotBed(convertBamToGR())
        
    })
    
    
######################
## download buttons ##
###################### 
    
    output$downloadAnnotate <- downloadHandler(filename = "probeAnnotations.csv", content = function(file) {
        write.csv(getAnnotation(), file, row.names = F)
    })
    
    output$Annotation <- renderText(head(nrow(getAnnotation())))
    
    
#####################
## do search MySQL ##
#####################   
observeEvent(input$searchGPL,{
  
  
  
  
  
})
    
    
        
    
####################
## select gpl acc ##
####################
updateSelectizeInput(session, 'foo', choices = data, server = TRUE)
    
    
    
    
    
})



