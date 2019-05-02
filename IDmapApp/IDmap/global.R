##################################

getMySQLdata <- function(querySQL){
  host <<- "127.0.0.1"
  port <<- 3306
  user <<- "idmapuser"
  password <<-  "idmap123"
  dbname <<- "idmapDB"
  #library(RMySQL)
  #db <- dbConnect(RMySQL::MySQL(), host=host,dbname=dbname,port=port, user=user, password=password)
  #querySQL="select * from human_All_anno where gpl = \"GPL1352\" and biotype = \"protein\""
  #dat=dbGetQuery(db,querySQL)
  #dbDisconnect(db)
  #return(head(dat))
  return(paste0(querySQL,"待部署_shiny-server"))
}
  
  
  
  