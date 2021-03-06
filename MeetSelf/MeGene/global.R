##
##getMySQLdata <- function(querySQL){
##  host <<- "127.0.0.1"
##  port <<- 3306
##  user <<- "idmapuser"
##  password <<-  "idmap123"
##  dbname <<- "idmapDB"
##  library(RMySQL)
##  db <- dbConnect(RMySQL::MySQL(), host=host,dbname=dbname,port=port, user=user, password=password)
##  #querySQL="select * from human_All_anno where gpl = \"GPL1352\" and biotype = \"protein\""
##  dat=dbGetQuery(db,querySQL)
##  dbDisconnect(db)
##  return(head(dat))
##  #return(paste0(querySQL))
##}

## read data from xlsx
#geneInfo <- read.xlsx("E:/GitHub/Demo/MeetSelf/MeGene/data/geneinfo.xlsx")
getSQLitedata <- function(querySQL){
  sqlitePath <- "data/sportGenes.sqlite"
  sportDB <- dbConnect(RSQLite::SQLite(), sqlitePath)
  ##querySQL="select * from human_All_anno where gpl = \"GPL1352\" and biotype = \"protein\""
  dat=dbGetQuery(sportDB, querySQL)
  dbDisconnect(sportDB)
  return(dat)
}
