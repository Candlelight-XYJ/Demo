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
               style="color: #fff; background-color: #104E8B; border-color: #1874CD")

  ),
  mainPanel(
    fluidRow(
      box(
        title = strong("Species"),width = 4,solidHeader = TRUE,status = "primary" , ##status is color
        "Now,we have stored human, mouse, rat probe annotations"
      ),
      valueBox(
        "163",icon = icon("list"),color="light-blue",
        strong("GPL annotaions")
      )
    ),
    
    fluidRow(
      #DT::dataTableOutput("searchTable") 
      textOutput("searchTable")
    )
    
  )
) 


## body - pipeline
pipeline <- tabPanel(
  "Pipeline", icon = icon("home"),
  sidebarPanel(
    fileInput("probeseq", "Choose FASTA File",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    fileInput("gtf", "Choose GTF File",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
  
  shinyFilesButton("genome", "Choose a Genome file" ,
                   title = "Please select a file:", multiple = FALSE,
                   buttonType = "default", class = NULL),
  textOutput("showGenomePath"),
  br(),
  actionButton("doAnnotate","Start Annotating",icon("play"),
               style="color: #fff; background-color: #104E8B; border-color: #1874CD")
  ),
  mainPanel(
    fluidRow(
      infoBoxOutput("progressBox")
      # Clicking this will increment the progress amount
      #box(width = 4, actionButton("count", "Increment progress"))
    ),
    fluidRow(
    DT::dataTableOutput("annotable") 
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
    id = "tabset1", height = "800px",width = 12,
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
