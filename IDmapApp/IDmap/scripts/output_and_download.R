####################
##     output     ##
#################### 

output$viewBed <- renderPlot({
  plotBed(convertBamToGR())
  
})

#output$searchTable = DT::renderDataTable({
#  return(head(reactValues$searchRes))
#})
output$searchTable <- renderText({
  return(react_Values$searchRes)
})

output$annotable <- DT::renderDataTable({
  
  return(react_Values$annoRes)
})

output$progressBox <- renderInfoBox({
 
  infoBox(
    "Progress", paste0(react_Values$progress*100,"%"),icon = icon("list"),
    color = react_Values$progressColor
    )
  
})

######################
## download buttons ##
###################### 

output$downloadAnnotate <- downloadHandler(filename = "probeAnnotations.csv", content = function(file) {
  write.csv(getAnnotation(), file, row.names = F)
})

output$Annotation <- renderText(head(nrow(getAnnotation())))


