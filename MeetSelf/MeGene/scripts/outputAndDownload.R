output$report <- downloadHandler(
  # For PDF output, change this to "report.pdf"
  filename = "report.html",
  content = function(file) {
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
    tempReport <- file.path(tempdir(), "MeGeneSports.Rmd")
    file.copy("MeGeneSports.Rmd", tempReport, overwrite = TRUE)
    
    # Set up parameters to pass to Rmd document
    params <- list(suggestions = sportValues$suggestions,
                   relaKnowledge = sportValues$relaKnowledge,
                   detectGenes = sportValues$detectGenes,
                   detectRsId = sportValues$detectRsId,
                   citations = sportValues$citations
                   )
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv()),
                      encoding = 'UTF-8'
    )
  }
)

#output$report <- downloadHandler(
  # For PDF output, change this to "report.pdf"
#  filename = "report.html",
#  content = function(file) {
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
#    tempReport <- file.path(tempdir(), "report.Rmd")
#    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    
    # Set up parameters to pass to Rmd document
#    params <- list(n = input$selectSpe)
    
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
#    rmarkdown::render(tempReport, output_file = file,
#                      params = params
                      #envir = new.env(parent = globalenv()
#                                      )
    
#  })

