library(shiny)
library(openxlsx)
library(rmarkdown)
shinyServer(function(input, output,session) {

globalValues <- reactiveValues(
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

    
})
