######################
## For sports genes ##
######################

observeEvent(input$generateReport,{
  if(!is.null(input$inputVcf$datapath)){
    vcf <- read.csv(input$inputVcf$datapath,stringsAsFactors = F)
    tmpUsr <- data.frame(rsId = vcf$ID, genotype = vcf$GenoType)
    sportGenesUsr <- tmpUsr[tmpUsr$rsId %in% SportGeneInfo$rsId,]
    ## remove replicated rows
    sportGenesUsr <- sportGenesUsr[!duplicated(sportGenesUsr),]
    reportSportGenes(sportGenesUsr)
  }

})


reportSportGenes <- function(data){
  #querySQL1 <- paste0("select * from SportGeneInfo"," where rsId = ",shQuote(data$rsId))
  #querySQL2 <- paste0("select * from SportItem"," where rsId = ",shQuote(data$rsId))
  #geneInfo <- getSQLitedata(querySQL1)
  #sportItem <- getSQLitedata(querySQL2)
  mer1 <- merge(data,SportGeneInfo, by="rsId",all.x=T)
  mer2 <- merge(mer1,SportItem, by="rsId",all.x=T)
  
  sportValues$suggestions = mer2$suggestion
  sportValues$relaKnowledge = mer2$suggestion
  sportValues$detectGenes = paste(mer2$gene," ",mer2$geneinfo)
  sportValues$detectRsId = data$rsId
  sportValues$citations = mer2$citation
  print("ok")
}


