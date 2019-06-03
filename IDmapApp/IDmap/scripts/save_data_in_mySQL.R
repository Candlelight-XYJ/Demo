# mysql -h 127.0.0.1 -u idmap -p

###########################
setwd("/home/yjxiang/IDmap/")
allfiles = list.files(getwd())
for(i in 1:length(allfiles)){
  eval(parse(text = paste0("load(","\'",allfiles[i],"\'",")")))
}


library(RMySQL)
  host <<- "127.0.0.1"
  port <<- 3306
  user <<- "idmap"
  password <<-  "idmap_biotrainee"
  dbname <<- "idmap"
  db <- dbConnect(RMySQL::MySQL(), host=host,
                  dbname=dbname,port=port, 
                  user=user, password=password)

  zz <- dbWriteTable(conn = db,
                     name = "rat_lncRNA_anno",
                     value = rat_lncRNA_anno,
                     overwrite = F,
                     row.names = FALSE)
  #dbGetQuery(db, 'SELECT * FROM human_all_anno LIMIT 25')
  dbListTables(db)
  dbDisconnect(db)

