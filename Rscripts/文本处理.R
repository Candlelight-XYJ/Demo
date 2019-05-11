## merge
library(openxlsx)
options(stringsAsFactors = F)
z<- read.csv("E:\\IOZ_lab\\yangby\\添加KO注释\\AddKO_diff_10C12h_vs_RTF.csv")
KO_zongku <- read.xlsx("E:\\IOZ_lab\\公共数据\\KO总库.xlsx")

test <- merge(z,KO_zongku,by.x="KO",by.y ="ko", all.x = T)

write.csv(test,"E:\\IOZ_lab\\yangby\\ko_match_diff.csv")


## 

setwd("E:\\学习资料存放处\\贝叶斯网络\\2019_04_19_数据格式模型整理\\输出数据\\第二次卡阈值_0.55_0.45\\")
tabuRes <- read.xlsx("第二次卡阈值_tabu_0.55_0.45.xlsx") 
tpdaRes <- read.xlsx("第二次卡阈值_tpda_0.55_0.45.xlsx",colNames = F)
addinfo <- read.csv("E:\\学习资料存放处\\贝叶斯网络\\2019_04_19_数据格式模型整理\\输出数据\\addinfo.csv")
colnames(addinfo) <- c("pheno","snp","chr","pos","R2","p_value")
tabuAddInfo <- merge(tabuRes, addinfo, by.x="V1",by.y = "pheno")
tpdaAddInfo <- merge(tpdaRes, addinfo, by.x="X1",by.y = "pheno")
write.xlsx(tabuAddInfo,"E:\\学习资料存放处\\贝叶斯网络\\2019_04_19_数据格式模型整理\\输出数据\\第二次卡阈值_添加snp信息\\第二次结果tabu_添加snp信息.xlsx")
write.xlsx(tpdaAddInfo,"E:\\学习资料存放处\\贝叶斯网络\\2019_04_19_数据格式模型整理\\输出数据\\第二次卡阈值_添加snp信息\\第二次结果tpda_添加snp信息.xlsx")

