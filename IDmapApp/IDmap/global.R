##################################

getMySQLdata <- function(querySQL){
  host <<- "127.0.0.1"
  port <<- 3306
  user <<- "idmapuser"
  password <<-  "idmap123"
  dbname <<- "idmapDB"
  library(RMySQL)
  db <- dbConnect(RMySQL::MySQL(), host=host,dbname=dbname,port=port, user=user, password=password)
  #querySQL="select * from human_All_anno where gpl = \"GPL1352\" and biotype = \"protein\""
  dat=dbGetQuery(db,querySQL)
  dbDisconnect(db)
  return(head(dat))
  #return(paste0(querySQL))
}
  
  
## install packages
#BiocManager::install(c("shinydashboard","shinyFiles","DT",
#                       "Rbowtie",
#                       "data.table",
#                       "Rsamtools",
#                       "refGenome",
#                       "GenomicRanges",
#                       "tidyverse",
#                       "Sushi",
#                       "openxlsx"))
options(shiny.sanitize.errors = FALSE)

## convert csv2fasta
csv2fasta <- function(csvPath){
  csv <- read.csv(csvPath)
  fasta=paste(apply(csv,1,function(x) paste0('>',x[1],'\n',x[2])),collapse = '\n')
  return(fasta)
}

