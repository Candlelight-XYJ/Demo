library(shiny)
library(shinydashboard)
library(shinyFiles)
library(DT)
library(shinythemes)
library(knitr)
## head 
headerbar <- dashboardHeader(
  title = "IDmap Workflow",
  titleWidth = 270,
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "Plots might take some time to display",
      icon("truck"),
      status = "warning"
    )
  )
)


## sidebar
sidebar <- dashboardSidebar(
  disable = TRUE
)

## body - Home
home <- tabPanel(
  "Home",icon = icon("home"),
  sidebarPanel(
  selectizeInput("selectSpe", "Select Species", choices=c("human","mouse","rat"), selected = NULL, multiple = FALSE,
                   options = NULL),
  selectizeInput("selectType", "Select biotype", 
                 choices=c("protein_coding" = "protein_coding" 
                           ,"non_coding"="non_coding"
                           ,"lincRNA"="lincRNA",
                           "all" = "*"), selected = NULL, multiple = FALSE,options = NULL),
  selectizeInput("selectGPL", 
                 label = "Please input geo platform number(GPL)", 
                 choices = NULL ,
                 multiple = FALSE,
                 options = list(placeholder = "eg: GPL570",
                                maxOptions = 10)),
  actionButton("searchGPL","Search",icon("search"),
               style="color: #fff; background-color: #104E8B; border-color: #1874CD"),
  br(),
  br(),
  downloadButton("downloadGPL", "Download",icon("download"))
  ),
  mainPanel(
    fluidRow(
      box(
        title = strong("3 Species"),width = 4,solidHeader = TRUE,status = "primary" , ##status is color
        "Now,we have stored human, mouse, rat probe annotations"
      ),
      valueBox(
        "163",icon = icon("list"),color="light-blue",
        strong("GPL annotations")
      )
    ),
    
    fluidRow(
      DT::dataTableOutput("searchTable") 
      #textOutput("searchTable")
      
    )
    
  )
) 


## body - pipeline
pipeline <- tabPanel(
  "Pipeline", icon = icon("home"),
  sidebarPanel(
    selectInput("probeFileType", "Probe Sequences File Type",
                c(fasta = "fasta", csv = "csv")
    ),
    conditionalPanel(
      condition = "input.probeFileType == 'fasta'",
      fileInput("inputFasta", "Choose FASTA File",
                accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
      ),
    # Only show this panel if CSV is selected
    conditionalPanel(
        condition = "input.probeFileType == 'csv'",
        fileInput("inputCsv", "Choose .CSV table",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
      ),
    #textOutput("showIDnum"),
   
   ## input GTF 
   # fileInput("gtf", "Choose GTF File",
   #          accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
   
   
   
   ## choose GTF file  
   selectizeInput("selectGTF", "Select GTF File", 
                  choices=c("gencode_human_v30.gtf" = "gencode_human_v30.gtf" 
                            ,"gencode_mouse_v21.gtf"="gencode_mouse_v21.gtf"
                            ,"rat"="rat",
                            "other" = "other"), selected = NULL, multiple = FALSE,options = NULL),
   checkboxInput("checkGTF", "I want to input customed GTF", FALSE),
   conditionalPanel(
     condition = "input.checkGTF",
     fileInput("customedGTF", "Load your GTF file",
                      accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
   ),
   ## choose genome
   selectInput("selectGenome", "Choose Genome File",
                c("Human Genome" = "human",
                  "Mouse Genome" = "mouse",
                  "Rat Genome" = "rat")),
   
  checkboxInput("checkGenome", "I want to input customed Genome", FALSE),  
  conditionalPanel(
    condition = "input.checkGenome",
    shinyFilesButton("customedGenome", "Load your Genome file" ,
                     title = "Please select a file:", multiple = FALSE,
                     buttonType = "default", class = NULL),
    textOutput("showGenomePath")
    
  ),
  #shinyFilesButton("genome", "Choose a Genome file" ,
  #                 title = "Please select a file:", multiple = FALSE,
  #                 buttonType = "default", class = NULL),
  #textOutput("showGenomePath"),
  textOutput("showBowtiePath"),
  
  br(),
  actionButton("doAnnotate","Start Annotating",icon("play"),
               style="color: #fff; background-color: #104E8B; border-color: #1874CD"),
  br(),
  br(),
  downloadButton("downloadAnno", "Download",icon("download"))
  ),
  mainPanel(
    fluidRow(
      infoBoxOutput("progressBox",width=4)
    ),
   fluidRow(
    box(title = strong("annotation results"), status = "primary",
    DT::dataTableOutput("annotable"),
    textOutput(strong("no_results")))
  
   ),
   fluidRow(
      box(title = strong("Probe Sets"), status = "primary",plotOutput("plot_geneProbeRela"),
          sliderInput("select_numRanges", "Please choose Genomic Ranges",
                      min = 1, max = 100, value = c(1,50)),
          downloadButton("download_probe_genes", "Download",icon("download"))
          ),
      box(title = strong("probe Mapping"), status = "warning",plotOutput("plot_probeMapping"),
          sliderInput("select_chr", "Please choose chromosome to visualize",
                          min = 1, max = 22, value = 1))
    )
))

## body - DEG
DEG <- tabPanel(
  "DEG",icon = icon("bar-chart-o"),
  sidebarPanel(
    selectInput("expFileType", "Expression File Type",
                c(chip = "chip", rnaseq = "rnaseq")),
    fileInput("inputExpData", "Input Expression Data",
                accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    
    actionButton("doDEG","Start DEG analysis",icon("play"),
                 style="color: #fff; background-color: #104E8B; border-color: #1874CD")            
  ),
  mainPanel(
    
    
  )
)

## body - Help&About Us

about <- tabPanel(
  "Help & About Us",icon = icon("table")
  # ,includeMarkdown("help.Rmarkdown") 
)


##
body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
fluidRow(
  tabBox(
    id = "tabset1", height = "12000px",width = 12,
    home,
    pipeline,
    DEG,
    about
    )
))


shinyUI(
  dashboardPage(
    skin = "blue",
    headerbar,
    sidebar,
    body
  )
)
