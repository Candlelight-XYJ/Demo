library(shiny)
library(shinydashboard)
library(shinyFiles)
library(DT)
library(shinythemes)
library(knitr)
## head 
headerbar <- dashboardHeader(
  title = strong("MeGene 报告生成系统"),
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
  strong("运动基因报告"),icon = icon("home"),
  sidebarPanel(
    selectizeInput("selectSpe", "Select Species", choices=c("human","mouse","rat"), selected = NULL, multiple = FALSE,
                   options = NULL),
    actionButton("searchGPL","Search",icon("search"),
                 style="color: #fff; background-color: #104E8B; border-color: #1874CD"),
    br(),
    br(),
    downloadButton("downloadGPL", "Download",icon("download"))
  ),
  mainPanel(
    fluidRow(
      box(
        title = strong("运动基因"),width = 4,solidHeader = TRUE,status = "primary" , ##status is color
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
  strong("营养搭配推荐"), icon = icon("home"),
  sidebarPanel(
    selectInput("probeFileType", "Probe Sequences File Type",
                c(fasta = "fasta", csv = "csv")
    ),

    fileInput("gtf", "Choose GTF File",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    
    ## choose genome
    #  selectInput("genome", "Choose Genome File",
    #              c("Human Genome" = "humanGenome",
    #                "Mouse Genome" = "mouseGenome",
    #                "Rat Genome" = "ratGenome")),
    
    shinyFilesButton("genome", "Choose a Genome file" ,
                     title = "Please select a file:", multiple = FALSE,
                     buttonType = "default", class = NULL),
    textOutput("showGenomePath"),
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
      h3("Developing  . . .")
    )
  ))

## body - DEG
DEG <- tabPanel(
  "DEG",icon = icon("bar-chart-o"),
  mainPanel(
    
  )
)

## body - Help&About Us

about <- tabPanel(
  strong("关于MeGene"),icon = icon("table"),
  h3("MeGene Bioinformatics Group")
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
