####################
##     output     ##
#################### 

output$viewBed <- renderPlot({
  plotBed(convertBamToGR())
  
})

#output$searchTable = DT::renderDataTable({
#  return(head(react_Values$searchRes))
#})
output$searchTable <- DT::renderDataTable({
  return(react_Values$searchRes)
})



output$annotable <- DT::renderDataTable({
  if(!is.null(react_Values$annoRes)){
  showAnnoRes <- react_Values$annoRes[,c(6,1,2,3,5,12)]
  colnames(showAnnoRes)=c("probe_id","chr","start","end","strand","gene_symbol")
  showAnnoRes
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
          | is.null(input$gtf) 
          | is.null(input$genome)){
    infoBox("Status",
            "Annotate Not Started Yet!",icon = icon("flag", lib = "glyphicon"),
            color = "aqua",
            fill = TRUE)
    
  }
  else if(input$doAnnotate > 0 & is.null(react_Values$annoRes) & !is.null(input$probeFileType) & !is.null(input$gtf) & !is.null(input$genome)){
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
    res=react_Valuse$searchRes
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
  genes=df[!duplicated(df[,12]),12]
  probeAndgenes=data.frame()
  for(i in 1:length(genes)){
    probe_id=df[grep(genes[i],df[,12]),]$id
    #tmp <- data.frame(probe_id=probe_id,
    #                  gene=rep(genes[i],times=length(probe_id)))
    tmp <- data.frame(gene_symbol=genes[i],probe_num=length(probe_id))
    probeAndgenes <- rbind(probeAndgenes,tmp)
  }
  ggplot(probeAndgenes , aes(x = gene_symbol, y = probe_num)) +
    geom_bar(stat = "identity",fill = "lightblue", colour = "black")
  }
})



##### Visual probe mapping results
output$plot_probeMapping <- renderPlot({
  if(!is.null(react_Values$Bam2GR)){
    chrom = input$select_chr
    chromstart = IRanges::start(react_Values$Bam2GR[chrom])
    chromend = IRanges::end(react_Values$Bam2GR[chrom])
    
    ## plot bed 
    plotBed(beddata = react_Values$Bam2GR,chrom = input$select_chr,
            chromstart = chromstart,chromend =chromend ,colorby = react_Values$Bam2GR$strand,
            colorbycol = SushiColors(2),row = "auto",wiggle=0.001,splitstrand=TRUE)
    ## label genome
    labelgenome(input$select_chr,chromstart,chromend,n=2,scale="Kb")
    ## add legend
    legend("topright",inset=0,legend=c("reverse","forward"),fill=SushiColors(2)(2),
           border=SushiColors(2)(2),text.font=2,cex=0.75)
  }
  
  
})


#zz <- read.csv("probeAnnotations.csv")
#plotBed(beddata = zz,chrom = c("chr1","chr2"),chromstart = 1,
#        chromend =40000,
#        colorbycol = SushiColors(2),row = "auto",wiggle=0.001)
#labelgenome(c("chr1","chr2"),1,40000,n=2,scale="Kb")

