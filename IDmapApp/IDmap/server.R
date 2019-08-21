#################################
#### last update in May 19 #### 
#################################

library(shiny)
library(shinydashboard)
library(shinyFiles)
library(DT)
library(Rbowtie)
library(data.table)
library(Rsamtools)
#library(refGenome)
library(GenomicRanges)
library(tidyverse)
library(Sushi)
#library(igvR)
library(openxlsx)
#library(GEOmetadb)
library(GEOquery)
library(RSQLite)
## Limit the size of load data in 50M
options(shiny.maxRequestSize = 50 * 1024^2)

shinyServer(function(input, output, session) {
## setting reactive valuses for accessing data
react_Values <- reactiveValues(
    searchRes=NULL,
    annoRes=NULL,
    gtfFile=NULL,
    bowtieIndex=NULL,
    samFile=NULL,
    Bam2GR=NULL,
    gtf2GR=NULL
)
volumes = getVolumes()

##############################
#### Load files from path #### 
##############################

## Load users` fasta files

loadProbeSeq <- reactive({
  req(input$probeFileType)
  if(input$probeFileType=="fasta"){
    probeFastaFile <- req(input$inputFasta$datapath)
    return(probeFastaFile)
  }
  if(input$probeFileType=="csv"){
  ## if input is csv table ,convert csv2fasta
  tempPath <- tempdir()
  tempPath <- csv2fasta(input$inputCsv$datapath)
  return(file.path(tempPath))
  }
})

#computeIDnum <- reactive({
#    seq <- read.table(loadProbeSeq(),sep="\n",fill=TRUE)
    #head(seq)
#    nrow(seq)
    #ID_num=count(seq,vars=">")
#    return(nrow(seq))
#})


## Load Customed Genome
loadUsrGenome <- reactive({
   shinyFileChoose(input, "customedGenome", roots = volumes, session = session)
   req(as.character(parseFilePaths(volumes, input$customedGenome)$datapath))
})
output$showGenomePath <- renderText(loadUsrGenome())
    
## Load Customed GTF
loadUsrGTF <- reactive({
   req(input$customedGTF)
   gtfFile <- data.table::fread(input$customedGTF$datapath, sep = "\t"
                                ,skip="##",header = F)
   return(gtfFile)
})

## Load GPL info files
#loadGPLinfo <- reactive({
#  openxlsx::read.xlsx("data/gpl_list.xlsx")
#})
#react_Values$GPLinfo = loadGPLinfo()

######################################
#### Load files from stored files #### 
######################################

## Load Stored Genome File
loadStoredGenome <- reactive({
  ## use absolute path instead of relative path
  indexPath <- paste0(getwd(),"/genome_index/",input$selectGenome)
  return(indexPath)
})
output$showBowtiePath <- renderText(loadStoredGenome())


## Load Stored GTF File
loadStoredGTF <- reactive({
  req(input$selectGTF)
  if(is.null(input$customedGTF$datapath)){
  ## use absolute path instead of relative path
  gtfFile <- data.table::fread(paste0(getwd(),"/gtf/",input$selectGTF),
                               sep = "\t",header = F)
  return(gtfFile)
  }
})
    
    
##########################
## steps for annotating ##
##########################    
source('scripts/probeAnnotate.R', local = TRUE)

##########################
##   event actions   ##
########################## 
source('scripts/eventAction.R', local = TRUE)

##############################
##     output & download    ##
##############################
source('scripts/output_and_download.R', local = TRUE)


##############################
##     DEG    ##
##############################
source('scripts/doDEG.R', local = TRUE)

##############################
##     select species &   ##
##############################
source('scripts/getAttribute.R', local = TRUE)



######################
## download buttons ##
###################### 
    

    
####################
## select gpl acc ##
####################
GPLinfo = loadGPLinfo()
#gplnum <- loadGPLinfo()
#head(gplnum)
updateSelectizeInput(session, 'selectGPL', choices = as.vector(GPLinfo$gpl),
                     options = list(render = I(
                       "{
                       option: function(item, escape) {
                        return '<div> <strong>' + item.label + '</div>';
                       }}")),
                     server = TRUE)
  
})





