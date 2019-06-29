####################
##     output     ##
#################### 

output$viewBed <- renderPlot({
  plotBed(convertBamToGR())
  
})

#output$bowtie <- renderText({
#  react_Values$bowtieIndex
#})

#output$searchTable = DT::renderDataTable({
#  return(head(react_Values$searchRes))
#})
output$searchTable <- DT::renderDataTable({
  searchRes <- react_Values$searchRes
  if(!is.null(searchRes)){
    tmp1 <- with(searchRes, data.frame(probe_id = probe_id, pipeAnno = pipeAnno,
                                       biocAnno = biocAnno, ensembl_id = ensembl_id, biotype = biotype))
    tmp1$GPL <- createLink(paste0("https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=",searchRes$gpl),searchRes$gpl)
    
    #genome=ifelse(glob_values$species=='human','hg38','mm10')
    #UCSC_link=createLink(paste0( "http://dc2.cistrome.org/api/hgtext/", tmp1$sampleID,
    #                             "/?db=",genome,
    #                             "&position=",  tmp1$chrom,":",tmp1$start-1000,"-",tmp1$end+1000
    #)
    #,'UCSC')
    return(tmp1) 
  }
  
  
})



output$annotable <- DT::renderDataTable({
  if(!is.null(react_Values$annoRes)){
    showAnnoRes <- react_Values$annoRes[,c(6,1,2,3,5,12)]
    #colnames(showAnnoRes)=c("probe_id","chr","start","end","strand","gene_symbol")
    showAnnoRes
  }
})

output$no_results <- renderText({
  if(is.null(react_Values$annoRes)){
    return("No Results")
  }
})

output$progressBox <- renderInfoBox({
  
  if(input$doAnnotate == 0) {
    infoBox("Status",
            "Annotate Not Started Yet!",icon = icon("flag", lib = "glyphicon"),
            color = "aqua",
            fill = TRUE) 
  }
  else if(input$doAnnotate > 0 & is.null(react_Values$annoRes) 
          | is.null(input$probeFileType) 
          | is.null(input$customedGTF) 
          | is.null(input$customedGenome)
          | is.null(input$selectGTF)
          | is.null(input$selectGenome)){
    infoBox("Status",
            "Annotate Not Started Yet!",icon = icon("flag", lib = "glyphicon"),
            color = "aqua",
            fill = TRUE)
    
  }
  else if(input$doAnnotate > 0 & is.null(react_Values$annoRes) & !is.null(input$probeFileType) & !is.null(input$customedGTF) & !is.null(input$customedGenome)){
    infoBox("Status",
            "Annotating ... please wait!",icon = icon("flag", lib = "glyphicon"),
            color = "red",
            fill = TRUE)
  }
  else if(input$doAnnotate > 0 & is.null(react_Values$annoRes) & !is.null(input$probeFileType) & !is.null(input$selectGTF) & !is.null(input$selectGenome)){
    infoBox("Status",
            "Annotating ... please wait!",icon = icon("flag", lib = "glyphicon"),
            color = "red",
            fill = TRUE)
  }
  else if(input$doAnnotate > 0 & !is.null(react_Values$annoRes)){
    infoBox("Status",
            "Done!",icon = icon("thumbs-up", lib = "glyphicon"),
            color = "green",
            fill = TRUE) 
  }else{
    
    infoBox("Status",
            "Annotate Not Started Yet!",icon = icon("flag", lib = "glyphicon"),
            color = "green",
            fill = TRUE)  
    
  }
})

######################
## download buttons ##
###################### 

output$downloadAnno <- downloadHandler(
  filename = "probeAnnotations.csv", 
  content = function(file) {
    write.csv(react_Values$annoRes, file, row.names = F)
  })


output$downloadGPL <- downloadHandler(
  filename = function() {
    paste(input$selectGPL,
          'anno', Sys.Date(), '.csv', sep='-')
  },
  content = function(file) {
    res=react_Values$searchRes
    write.csv(res, file)
  }
) 

##########
## plot ##
##########

## plot probe num
output$plot_geneProbeRela <- renderPlot({
  if(!is.null(react_Values$annoRes)){
    df <- react_Values$annoRes
    genePerProbeNum = df %>% dplyr::count(df[,ncol(df)])
    head(df)
    colnames(genePerProbeNum) <- c("gene_symbol","probe_num")
    print(input$select_numRanges)
    tmp <- genePerProbeNum[order(genePerProbeNum$probe_num,decreasing = T),]
    p <- ggplot(tmp[input$select_numRanges[1]:input$select_numRanges[2],], aes(x = gene_symbol, y = probe_num)) +
      geom_bar(stat = "identity",fill = "lightblue", colour = "black")
    p <- p + theme(axis.text.x = element_text(size = 10, color = "black", vjust = 0.5, hjust = 0.5, angle = 90),panel.grid =element_blank(),panel.border = element_blank())
    p
    
  }else{
    df <- read.table("data/sampledata/samplebed.anno",stringsAsFactors = F,sep="\t")
    #df <- df[order(df$V7),]
    genePerProbeNum = df %>% dplyr::count(df$V7)
    colnames(genePerProbeNum) <- c("gene_symbol","probe_num")
    tmp <- genePerProbeNum[order(genePerProbeNum$probe_num,decreasing = T),]
    ## only show top 100 probeSets   
    p <- ggplot(tmp[input$select_numRanges[1]:input$select_numRanges[2],]
                , aes(x = gene_symbol, y = probe_num)) +
      geom_bar(stat = "identity",fill = "lightblue", colour = "black")
    p <- p + theme(axis.text.x = element_text(size = 10, color = "black", vjust = 0.5, hjust = 0.5, angle = 90),panel.grid =element_blank(),panel.border = element_blank())
    p
    
  }
})



##### Visual probe mapping results


output$plot_probeMapping <- renderPlot({
  if(!is.null(react_Values$Bam2GR)){
    chrom = paste0("chr",input$select_chr)
    chromstart = IRanges::start(react_Values$Bam2GR[chrom])
    chromend = IRanges::end(react_Values$Bam2GR[chrom])
    
    ## plot bed 
    plotBed(beddata = react_Values$Bam2GR,chrom = input$select_chr,
            chromstart = chromstart,chromend =chromend ,colorby = react_Values$Bam2GR$strand,
            colorbycol = SushiColors(2),row = "auto",wiggle=0.001,splitstrand=TRUE)
    ## label genome
    labelgenome(input$select_chr,chromstart,chromend,n=12,scale="Mb")
    ## add legend
    legend("topright",inset=0,legend=c("reverse","forward"),fill=SushiColors(2)(2),
           border=SushiColors(2)(2),text.font=2,cex=0.75)
  }else{
    print("ok")
    sampleDat <- read.table("data/sampledata/samplebed.anno",sep="\t",stringsAsFactors = F)
    GRobject <- with(sampleDat,GRanges(seqnames = V1,strand=V5,
                                       ranges = IRanges(start = V2, end =V3)))
    chrom = paste0("chr",input$select_chr)
    chromstart = sort(IRanges::start(GRobject),decreasing=F)[1]
    chromend = sort(IRanges::end(GRobject),decreasing=T)[1]
    print(chrom)
    ## plot bed 
    plotBed(beddata = sampleDat,chrom = chrom,#input$select_chr,
            chromstart = chromstart,chromend =chromend,
            colorby = sampleDat$V5,
            colorbycol = SushiColors(2),
            row = "auto",wiggle=0.001,splitstrand=TRUE)
    ## label genome
    labelgenome(chrom,chromstart,chromend,n=12,scale="Mb")
    ## add legend
    legend("topright",inset=0,legend=c("forward","reverse"),fill=SushiColors(2)(2),
           border=SushiColors(2)(2),text.font=2,cex=0.75)
    
  }
  
  
})


#zz <- read.csv("probeAnnotations.csv")
#plotBed(beddata = zz,chrom = c("chr1","chr2"),chromstart = 1,
#        chromend =40000,
#        colorbycol = SushiColors(2),row = "auto",wiggle=0.001)
#labelgenome(c("chr1","chr2"),1,40000,n=2,scale="Kb")

