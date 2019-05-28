## sqlite
rm(list=ls())
setwd("E:/GitHub/Demo/IDmapApp/IDmap/")
library(RSQLite)
sqlitePath <- "data/idmap.sqlite"
loadDataPath <- "E:/学习资料存放处/IDmap/注释存放处/8_MySQL_table最新版/human_all_anno.Rdata"
load(loadDataPath)

# Connect to the database
idmapdb <- dbConnect(SQLite(), dbname=sqlitePath)
zz <- dbWriteTable(conn = idmapdb,
                        name = "human_all_anno",
                        value = allXres,
                        overwrite = T,
                        row.names = FALSE)

dbListTables(idmapdb)
##dbGetQuery(idmapdb, 'SELECT * FROM human_all_anno LIMIT 25')
## delete table
##dbGetQuery(idmapdb,"DROP TABLE tmpRes")
dbDisconnect(idmapdb)





