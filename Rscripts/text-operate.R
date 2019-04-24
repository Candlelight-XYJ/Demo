library(openxlsx)
setwd("E:\\IOZ_lab\\ningjing\\")
diffgenesCK <- read.xlsx("Differential_expression.xlsx")
diffgenes1 <- read.xlsx("Differential_expression1.xlsx",sheet = 1)
diffgenes2 <- read.xlsx("Differential_expression1.xlsx",sheet = 2)
diffgenes3 <- read.xlsx("Differential_expression1.xlsx",sheet = 3)
diffgenes4 <- read.xlsx("Differential_expression1.xlsx",sheet = 4)

go <- read.csv("GO号.csv", head = F)
ko <- read.csv("KO号.csv", head = F)


tmp <- merge(diffgenesCK,diffgenes1,by.x="Gene_ID",by.y ="Gene_ID",all = T )
tmp1 <- merge(tmp,diffgenes2,by.x="Gene_ID",by.y ="Gene_ID",all = T)
tmp2 <- merge(tmp1,diffgenes3,by.x="Gene_ID",by.y ="Gene_ID",all = T)
tmp3 <- merge(tmp2,diffgenes4,by.x="Gene_ID",by.y ="Gene_ID",all = T)

## KO & GO


addko <- merge(tmp3,ko,by.x="Gene_ID",by.y ="V1",all = T)
addgo <- merge(addko,go,by.x="Gene_ID",by.y ="V1",all = T)

write.csv(addgo,"合并result.csv",row.names = F)



