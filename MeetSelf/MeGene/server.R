library(shiny)
library(openxlsx)
library(rmarkdown)
shinyServer(function(input, output,session) {

sportValues <- reactiveValues(
    suggestions = NULL,
    relaKnowledge = "zzz",
    detectGenes = NULL,
    detectRsId = NULL,
    citations = NULL
)  
    
############################
## reporting sports genes ##
############################  
#includeMarkdown("reports/MeGeneReport.Rmd")  
source("scripts/outputAndDownload.R",local=TRUE)  
    
############################
## reporting sports genes ##
############################  
source('scripts/sports_gene.R', local = TRUE)

#######################################
## importing Sports gene information ##
#######################################

SportGeneInfo <- read.xlsx("data/SportGeneInfo.xlsx")
SportItem <-  read.xlsx("data/SportItem.xlsx")



    
})
