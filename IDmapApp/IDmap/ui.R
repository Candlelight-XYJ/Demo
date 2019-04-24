
library(shiny)
library(shinydashboard)
library(shinyFiles)
library(DT)
library(shinythemes)

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

## body - about

about <- tabPanel(
  "About",
  sidebarPanel(
  selectizeInput("selectSpe", "Select Species", choices=c("human","mouse","rat"), selected = NULL, multiple = FALSE,
                   options = NULL)
  

  ),
  mainPanel(
     
  )
) 


## body - pipeline
pipeline <- tabPanel(
  "Pipline", icon = icon("home"),
  sidebarPanel(
    fileInput("probeseq", "Choose FASTA File",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    fileInput("gtf", "Choose GTF File",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
  
  shinyFilesButton("genome", "Choose a Genome file" ,
                   title = "Please select a file:", multiple = FALSE,
                   buttonType = "default", class = NULL),
  textOutput("showGenomePath")
  
  ),
  mainPanel(
    DT::dataTableOutput("mytable") 
     
  )
)

## body - DEG
DEG <- tabPanel(
  "DEG"
     )


## body - More




##
body <- dashboardBody(

fluidRow(
  tabBox(
    id = "tabset1", height = "800px",width = 12,
    about,
    pipeline,
    DEG
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
