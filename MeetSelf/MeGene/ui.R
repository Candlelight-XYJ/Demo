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
    type = "notifications"
  )
)

## sidebar
sidebar <- dashboardSidebar(
  disable = TRUE
)

## body - Home
home <- tabPanel(
  strong("运动基因报告"),icon = icon("table-tennis"),
  sidebarPanel(
    fileInput("inputVcf", "输入VCF文件",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    actionButton("generateReport","生成报告",icon("rocket"),
                 style="color: #fff; background-color: #104E8B; border-color: #1874CD"),
    br(),
    br(),
    downloadButton("downloadReport", "下载报告")
  ),
  mainPanel(
    fluidRow(
      box(
        title = strong("运动基因"),width = 4,solidHeader = TRUE,status = "primary" , ##status is color
        "现在我们提供12个运动基因检测项目",
        "定制专属于您的MeGene基因检测报告"
      ),
      valueBox(
        "100",icon = icon("list"),color="light-blue",
        strong("SNP位点")
      )
    ),
    
    fluidRow(
     #includeMarkdown("MeGeneIntro.md")
      h3("欢迎来到MeGene报告生成系统，使用方法如下："),
      p("step1:在左侧输入MeGene专享vcf格式文件"),
      p("step2:点击生成报告，约等待10s"),
      p("step3:点击下载报告 即可下载")
    )
    
  )
)


## body - pipeline
pipeline <- tabPanel(
  strong("营养搭配推荐"), icon = icon("utensils"),
  sidebarPanel(
    selectInput("selectNutrition", "选择营养指标",
                c("水分" = "水分", "油脂" = "油脂")
    )
  ),
  mainPanel(
    fluidRow(
      infoBoxOutput("progressBox",width=4)
    ),
    fluidRow(
      h3("MeGene Developing  . . .")
    )
  ))

## body - DEG
DEG <- tabPanel(
  "系统使用说明",icon = icon("bar-chart-o"),
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
