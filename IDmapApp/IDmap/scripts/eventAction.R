#####################
## do search MySQL ##
#####################  
observeEvent(input$searchGPL,{
  #querySQL="select * from"
  querySQL <- paste0("select * from ",input$selectSpe,"_All_anno"," where gpl = ",shQuote(input$selectGPL),
                     " and ","biotype = ",shQuote(input$selectType))
  #print(querySQL)
  react_Values$searchRes <- getMySQLdata(querySQL)
  
})

#################
## do annotate ##
#################
observeEvent(input$doAnnotate,{
  ## build genome index
  react_Values$bowtieIndex = getBowtieIndex(loadUsrGenome())
  ## align reads
  react_Values$samFile = getBowtieAlign(loadProbeSeq(),react_Values$bowtieIndex)
  ## preprocess gtf files
  react_Values$gtf2GR = preprocessGTF(loadUsrGTF())
  ## Bam2Ranges  
  Bam2Ranges = convertBamToGR(react_Values$samFile)  
  ## get Annotation
  react_Values$annoRes = getAnnotation(Bam2Ranges,react_Values$gtf2GR)
})

