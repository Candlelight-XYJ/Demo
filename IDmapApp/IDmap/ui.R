
library(shiny)
library(shinydashboard)
library(shinyFiles)
library(DT)

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

sidebar <- dashboardSidebar(
  width = 270,
  sidebarMenu(
    menuItem("About",
             tabName = "about",
             icon = icon("info")),
    menuItem("Load Data",
             tabName = "loaddata",
             icon = icon("folder-open"),
             badgeLabel = "step 1"
    ),
    menuItem("Mapping",
             tabName = "mapping",
             icon = icon("bullseye"),
             badgeLabel = "step 2"
    ),
    menuItem("VisualMapping",
             tabName = "visualmap",
             icon = icon("picture-o"),
             badgeLabel = "step 3"
    ),
    menuItem("Download",
             tabName = "download",
             icon = icon("download"),
             badgeLabel = "step 4",
             badgeColor = "red"
    ),
    menuItem(
      actionButton("buttonstop", strong("Click to Exit Shiny App")),
      icon = icon("sign-out")
    )
  ) 
)


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "about",
            DT::dataTableOutput("mytable")
    ),
    tabItem(tabName = "loaddata",
            fluidRow(
              ## Load Probe sequence
              box(width = 270,
                  title = strong("Load your sequence data in fasta format"),
                  fileInput("probeseq", "Choose FASTA File",
                            accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
              ), 
              ## Load GTF 
              box(
                width = 270,
                title = strong("Load your GTF data "),
                fileInput("gtf", "Choose GTF File",
                          accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))),
              
              box(
                width = 270,
                shinyFilesButton("genome", "Choose a Genome file" ,
                                 title = "Please select a file:", multiple = FALSE,
                                 buttonType = "default", class = NULL),
                textOutput("showGenomePath"))
            )),
    
    tabItem(tabName = "mapping",
            valueBox(
              uiOutput("orderNum"), "New Orders", icon = icon("credit-card"),
              href = "http://google.com"
            ),
            valueBox(
              tagList("60", tags$sup(style="font-size: 20px", "%")),
              "Approval Rating", icon = icon("line-chart"), color = "green"
            ),
            valueBox(
              htmlOutput("progress"), "Progress", icon = icon("users"), color = "purple"
            ),
            box(
              plotOutput("viewBed",height="300px")
            )
            ),
    tabItem(tabName = "visualmap",
            h2("Widgets tab content")
    ),
    tabItem(tabName = "download",
            box(
              downloadButton("downloadAnnotate", "Download")),
            box(textOutput("Annotation"))
    ))
)


shinyUI(
  dashboardPage(
    headerbar,
    sidebar,
    body
  )
)
