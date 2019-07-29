#####################
## do search MySQL ##
#####################  
observeEvent(input$searchGPL,{
  #querySQL="select * from"
  querySQL <- paste0("select * from ",input$selectSpe,"_all_anno"," where gpl = ",shQuote(input$selectGPL),
                     " and ","biotype = ",shQuote(input$selectType))
  #print(querySQL)
  #tmp <- getSQLitedata(querySQL)
  tmp <- getMySQLdata(querySQL)
  react_Values$searchRes <- tmp
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
                 
               react_Values$bowtieIndex = paste0("/data/genome_index/",input$selectGenome)
               react_Values$samFile = getBowtieAlign(loadProbeSeq(),indexDir)
               react_Values$gtfFile = data.table::fread(paste0("/data/genome_index/",input$selectGTF),
                                                                    sep = "\t",skip="##",header = F)
               ## preprocess gtf files
               react_Values$gtf2GR = preprocessGTF(react_Values$gtfFile)
               ## Bam2Ranges  
               react_Values$Bam2GR = convertBamToGR(react_Values$samFile)  
               ## get Annotation
               react_Values$annoRes = getAnnotation(react_Values$Bam2GR,react_Values$gtf2GR)
               
               }
               
               # if load customed genome file
               if(F){
                if(input$checkGenome && (!is.null(as.character(parseFilePaths(volumes, input$customedGenome)$datapath)))){
                 
                 ## it may take a long time ---
                 progress$set(value = .1, detail = "Building index ...")
                 ## build index
                 react_Values$bowtieIndex = getBowtieIndex(loadUsrGenome())
                 #print(react_Values$bowtieIndex)
                 ## set align progress
                 progress$set(value = 0.2, detail = "Aligning reads ...")
                 ## align reads
                 react_Values$samFile = getBowtieAlign(loadProbeSeq(),react_Values$bowtieIndex)  
                 }
                }
                 
               ## access index stored in Server
               react_Values$bowtieIndex = loadStoredGenome()
               
               ## align reads
               react_Values$samFile = getBowtieAlign(loadProbeSeq(),react_Values$bowtieIndex)
              
               ## if load customed gtf file 
               if(input$checkGTF && (!is.null(input$customedGTF$datapath))){
                 ## set overlapping progress
                 progress$set(value = 0.8, detail = "overlapping ...")
                 ## preprocess gtf files
                 react_Values$gtf2GR = preprocessGTF(loadUsrGTF()) 
                 
               }else{
                 ## access gtf files stored in Server
                 ## set overlapping progress
                 progress$set(value = 0.8, detail = "overlapping ...")
                  
                 ## preprocess gtf files
                 react_Values$gtf2GR = processStoredGTF(loadStoredGTF())
               }
                 
               ## set overlapping progress
               progress$set(value = 0.8, detail = "overlapping ...")
               
               ## Bam2Ranges  
               react_Values$Bam2GR = convertBamToGR(react_Values$samFile)  
               
               ## get Annotation
               react_Values$annoRes = getAnnotation(react_Values$Bam2GR,react_Values$gtf2GR)
               
               progress$set(value = 1, detail = "Done!")
               #setProgress(value = 1, detail = "Done!") 
               Sys.sleep(0.5)
              
})



