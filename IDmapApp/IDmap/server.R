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
#library(Sushi)
library(igvR)
library(openxlsx)
# library(IDmap)


## Limit the size of load data in 50M
options(shiny.maxRequestSize = 50 * 1024^2)

shinyServer(function(input, output, session) {
## setting reactive valuses for accessing data
react_Values <- reactiveValues(
    searchRes=NULL,
    annoRes=NULL,
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

#output$showIDnum <- renderText(
#  computeIDnum())  
  

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
source('scripts/annotate_probe.R', local = TRUE)

##########################
##   event actions   ##
########################## 
source('scripts/eventAction.R', local = TRUE)

##############################
##     output & download    ##
##############################
source('scripts/output_and_download.R', local = TRUE)


######################
## download buttons ##
###################### 
    

    
####################
## select gpl acc ##
####################
gplname = read.xlsx("data/gpl_list.xlsx")
updateSelectizeInput(session, 'selectGPL', choices = as.vector(gplname$gpl),
                     options = list(render = I(
                       "{
                       option: function(item, escape) {
                        return '<div> <strong>' + item.label + '</div>';
                       }}")),
                     server = TRUE)
  
})














