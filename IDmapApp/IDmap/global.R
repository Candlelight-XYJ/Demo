##################################

getMySQLdata <- function(querySQL){
  host <<- "127.0.0.1"
  port <<- 3306
  user <<- "idmap_workflow"
  password <<-  'idmap123'
  library(RMySQL)
  db <- dbConnect(RMySQL::MySQL(), host=host, port=port, user=user, password=password)
  dat=dbGetQuery(db,querySQL)
  dbDisconnect(db)
  return(dat)
}
  
  
  
  