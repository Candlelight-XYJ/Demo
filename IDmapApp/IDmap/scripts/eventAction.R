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
  progress <- shiny::Progress$new(session, min=1, max=100)
  on.exit(progress$close())
  
  progress$set(message = 'Calculation in progress',
               detail = 'This may take a while...',value=0)
  
               ## build genome index
               if(F){
               ## if the genome index we have, then use the exist index  
                   
               }else{
               ## if input genome we don`t have index,then build index by Rbowtie
               ## it may take a long time ---
               progress$set(value = .1, detail = "Building index ...")
               #setProgress(value = .1, detail = "Building index ...")   
               react_Values$bowtieIndex = getBowtieIndex(loadUsrGenome())}
                 
               ## set align progress
               progress$set(value = 0.2, detail = "Aligning reads ...")
               ## align reads
               react_Values$samFile = getBowtieAlign(loadProbeSeq(),react_Values$bowtieIndex)
               
               ## set overlapping progress
               progress$set(value = 0.8, detail = "overlapping ...")
               ## preprocess gtf files
               react_Values$gtf2GR = preprocessGTF(loadUsrGTF())
               
               ## Bam2Ranges  
               Bam2Ranges = convertBamToGR(react_Values$samFile)  
               ## get Annotation
               react_Values$annoRes = getAnnotation(Bam2Ranges,react_Values$gtf2GR)
               
               progress$set(value = 1, detail = "Done!")
               #setProgress(value = 1, detail = "Done!") 
               Sys.sleep(0.5)
               
})

