# "E:/学习资料存放处/IDmap/IDmap_edit/精简版注释/v2/"
#rm(list=ls())
#load("E:/学习资料存放处/IDmap/IDmap_edit/精简版注释/v2/mouse_lncRNA_anno.Rdata")
#gplNum = names(mouse_lncRNA_anno2)
#for(i in 1:length(gplNum)){
#  print(gplNum[i])
  #i=1
#  eval(parse(text=paste0(gplNum[i]," = mouse_lncRNA_anno2$",gplNum[i])))
#  eval(parse(text=paste0("usethis::use_data(",gplNum[i],",overwrite = T)")))
#}

#setwd("E:/学习资料存放处/IDmap/IDmap_edit/精简版注释/v2/")
#allfiles=list.files()
#allfiles=allfiles[-c(7,8)]
#for(i in 1:length(allfiles)){
#  eval(parse(text=paste0("load('",allfiles[i],"')")))
#}

#length(human_all_anno)+length(human_lncRNA_anno2)+length(mouse_all_anno)
#+length(mouse_lncRNA_anno2)+length(rat_all_anno)+length(rat_lncRNA_anno2)



