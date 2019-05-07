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
  
  return(react_Values$annoRes)
})

output$progressBox <- renderInfoBox({
  
  if(input$doAnnotate == 0) {
    infoBox("Status",
      "Annotate Not Started Yet!",icon = icon("flag", lib = "glyphicon"),
      color = "aqua",
      fill = TRUE) 
  }
  else if(input$doAnnotate > 0 & is.null(react_Values$annoRes) 
          | is.null(input$probeseq) 
          | is.null(input$gtf) 
          | is.null(input$genome)){
    infoBox("Status",
            "Annotate Not Started Yet!",icon = icon("flag", lib = "glyphicon"),
            color = "aqua",
            fill = TRUE)
    
  }
  else if(input$doAnnotate > 0 & is.null(react_Values$annoRes) & !is.null(input$probeseq) & !is.null(input$gtf) & !is.null(input$genome)){
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

