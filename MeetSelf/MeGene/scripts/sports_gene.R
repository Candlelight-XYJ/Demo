######################
## For sports genes ##
######################

observeEvent(input$generateReport,{
  if(!is.null(input$inputVcf)){
    vcf <- read.csv(input$inputVcf,stringsAsFactors = F)
    tmpUsr <- data.frame(rsId = vcf$ID, genotype = vcf$GenoType)
    sportGenesUsr <- tmpUsr[tmpUsr$rsId %in% SportGeneInfo$rsId,]
    ## remove replicated rows
    sportGenesUsr <- sportGenesUsr[!duplicated(sportGenesUsr),]
    
  }

})


reportSportGenes <- function(data){
  #querySQL1 <- paste0("select * from SportGeneInfo"," where rsId = ",shQuote(data$rsId))
  #querySQL2 <- paste0("select * from SportItem"," where rsId = ",shQuote(data$rsId))
  #geneInfo <- getSQLitedata(querySQL1)
  #sportItem <- getSQLitedata(querySQL2)
  
  
  mer1 <- merge(data,SportGeneInfo, by="rsId",all.x=T)
  mer2 <- merge(mer1,SportItem, by="rsId",all.x=T)
  
 for(i in 1:nrow(mer2)){
    if(grep(mer2$alt[i], mer2$genotype[i]) ){
      
      sportValues$suggestions = NULL
      sportValues$relaKnowledge = "zzz"
      sportValues$detectGenes = NULL
      sportValues$detectRsId = NULL
      sportValues$citations = NULL
      
    }else{
      
      
      
    }
    
  }
  
}


