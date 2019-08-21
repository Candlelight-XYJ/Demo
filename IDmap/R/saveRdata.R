#' Save the Rdata into our package
#'
#' So far, we just have 6 files
#'
#'
#' @param refresh Don't use this function if not neccessary
#' @keywords refresh Rdata

refreshRdata <- function(refresh = F) {
  #setwd("E:/GitHub/Demo/IDmap/")
  if (refresh) {
    allfiles = list.files(getwd())
    for(i in 1:length(allfiles)){
      print(i)
      eval(parse(text = paste0("load(","\'",allfiles[i],"\'",")")))
    }

    devtools::use_data(human_all_anno, overwrite = T)
    devtools::use_data(mouse_all_anno, overwrite = T)
    devtools::use_data(rat_all_anno, overwrite = T)
    devtools::use_data(human_lncRNA_anno, overwrite = T)
    devtools::use_data(mouse_lncRNA_anno, overwrite = T)
    devtools::use_data(rat_lncRNA_anno, overwrite = T)
  }
  # hgu95av2_id[ match(c(probeList),hgu95av2_id$probe_id),]
}
