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
  selectizeInput("selectType", "Select type", choices=c("protein-coding" = "protein" , "non-coding" = "nonc"), selected = NULL, multiple = FALSE,
                 options = NULL),
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
    textOutput("showIDnum"),
    
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
      infoBoxOutput("progressBox")
      # Clicking this will increment the progress amount
      #box(width = 4, actionButton("count", "Increment progress"))
    ),
    fluidRow(
    box(title = strong("Annotations table"), status = "warning",width = "100%",height="600px",
    DT::dataTableOutput("annotable"))
    ),
    fluidRow(
      box(title = strong("plot_geneProbeRela"), status = "primary", 
          plotOutput("plot_geneProbeRela", width = "100%")),
      box(title = strong("plot_probeMapping"), status = "warning", 
          plotOutput("plot_probeMapping", width = "100%"),
          sliderInput("select_chr", "Please choose chromosome to visual",
                      min = 1, max = 20, value = 20
          )
          )
    )
  )
)

## body - DEG
DEG <- tabPanel(
  "DEG",icon = icon("bar-chart-o")
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
