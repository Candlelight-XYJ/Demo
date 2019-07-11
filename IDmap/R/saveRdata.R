#' Save the Rdata into our package
#'
#' So far, we just have 6 files
#'
#'
#' @param refresh Don't use this function if not neccessary
#' @keywords refresh Rdata

refreshRdata <- function(refresh = F) {
  if (refresh) {
    #setwd("E:/学习资料存放处/IDmap/IDmap_edit/精简版注释/")
    allfiles = list.files(getwd())
    for(i in 1:length(allfiles)){
      print(i)
      eval(parse(text = paste0("load(","\'",allfiles[i],"\'",")")))
    }
    human_all_anno <- human_all_anno2
    mouse_all_anno <- mouse_all_anno2
    rat_all_anno <- rat_all_anno2
    human_lncRNA_anno <- human_lncRNA_anno2
    mouse_lncRNA_anno <- mouse_lncRNA_anno2
    rat_lncRNA_anno <- rat_lncRNA_anno2
    #load('../Annotations/human_all_anno.Rdata')
    #colnames(human_all_anno)
    #head(human_all_anno)

    #setwd("E:/学习资料存放处/IDmap/IDmap_edit/IDmap/")
    devtools::use_data(human_all_anno, overwrite = T)
    devtools::use_data(mouse_all_anno, overwrite = T)
    devtools::use_data(rat_all_anno, overwrite = T)
    devtools::use_data(human_lncRNA_anno, overwrite = T)
    devtools::use_data(mouse_lncRNA_anno, overwrite = T)
    devtools::use_data(rat_lncRNA_anno, overwrite = T)
  }
  # hgu95av2_id[ match(c(probeList),hgu95av2_id$probe_id),]
}
