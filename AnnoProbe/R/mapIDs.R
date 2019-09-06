#####################################
##                                 ##
## code last update: Sep 05, 2019  ##
##                                 ##
#####################################

##' Get Probe Annotation
##'
##' \code{getAnno} returns annotations for target gpl
##' @param gplnum GPL(GEO platform) number, eg: GPL570
##' @param source source of probe anntation stored, one of "pipe", "bioc", "soft", "all"
##' @param biotype GENCODE biotypes,eg:"protein_coding","non_coding","pseudogene" ...
##' @param lncRNA default is FALSE,lncRNA microarrays only have pipe annotation, if choose lncRNA microarray, the parameter must set as TRUE
##' @return probe annotaions
##'
##' @examples
##' gplnum <- "GPL10332"
##' source <- "pipe"
##' biotype <- "protein_coding"
##' humanAnno <- getAnno(gplnum, source, biotype)
##' head(humanAnno)
##'
##' @export
getAnno <- function(gplnum, source="pipe", biotype="protein_coding"){
  if(missing(gplnum)){
    stop("No valid gplnum passed in !")
  }
  flag <- checkGPL(gplnum)
  if(!flag){
    stop("please check your platform is in our gpl list \t
         or you can use function `getGPLsoft()` to download soft annotations from GEO \t
         or you can use our shinyAPP to custom annotate your probe sequences!")
  }
  eval(parse(text = paste0("tryCatch(utils::data( ",gplnum,", package = 'AnnoProbe'))")))
  res = eval(parse(text = paste0(gplnum)))
  ## filter annotations by source type
  sourceFilter <- switch(source,
                               "pipe" = na.omit(res[c(1,2,5)]),
                               "soft" = na.omit(res[c(1,3,5)]),
                               "bioc" = na.omit(res[c(1,4,5)]),
                               "all" = res
  )
  #sourceFilter <- sourceFilter[!duplicated(sourceFilter),]
  #head(sourceFilter)
  ## filter annotations by biotype
  if(biotype != "all"){
  biotypeFilter <- eval(parse(text=paste0("sourceFilter[sourceFilter$",source,"Biotype==","\'",biotype,"\'",",]")))
  biotypeFilter <- biotypeFilter[,-ncol(biotypeFilter)]
  biotypeFilter <- biotypeFilter[!duplicated(biotypeFilter),]
  return(biotypeFilter)
  }else{
  return(sourceFilter)
  }
}

##' Mapping probeIds to gene symbols
##'
##' \code{probeIdmap} returns a list of gene ids for the input probe ids
##' @param probeids input probe ids
##' @param datasets a dataframe which contains probe annotaions
##' @param probeIdcol the column name of probe ids in annotation datasets
##'
##' @return a dataframe of gene ids mapping to probe ids
##'
##' @examples
##' probeids <- c("A_23_P101521","A_33_P3695548","A_33_P3266889","A_33_P3266886")
##' gplnum <- "GPL10332"
##' source <- "pipe"
##' biotype <- "protein_coding"
##' lncRNA <- FALSE
##' datasets <- getAnno(gplnum, source, biotype, lncRNA)
##' mapRes <- probeIdmap(probeids, datasets)
##' head(mapRes)
##' @export
probeIdmap <- function(probeids, datasets, probeIdcol){
  if (missing(probeids)){
    stop("No valid probeids passed in !")
  }
  ## ids mapping results
  res <- datasets[match(probeids, eval(parse(text = paste0("datasets$",probeIdcol)))),]
  missIds <- probeids[!(probeids %in% eval(parse(text = paste0("res$",probeIdcol))))]
  missIdsPercentage = round((length(missIds)/length(probeids))*100,2)
  if(length(missIds)!=0){
   warning(
     paste0(missIdsPercentage ,"% of input probe IDs are fail to map... ")
     # 5.29% of input gene IDs are fail to map...
     # write.csv(missIds, file = paste0(getwd(), "/missing-probe-ids-", Sys.time()))
     )
  }
  rownames(res) <- NULL
  return(res)
}

##' Get GPL info
##'
##' @param gplnum GPL(GEO platform) number, eg: GPL570
##' @return detail information of the GEO platform
getGPLinfo <- function(gplnum){
  allgpl <- getGPLlist()
  return(allgpl[match(gplnum,allgpl$gpl), ])
}


##' Check the input gpl if in our platform list
##' @param gplnum GPL(GEO platform) number, eg: GPL570
##' @return returns a boolean value
##' @export
checkGPL <- function(gplnum){
  allgpl <- getGPLlist()
  flag = (gplnum %in% allgpl$gpl)
  return(flag)
}

##' Get GPL list
##'
##' \code{getGPLlist} returns a GPL number checklist stored in package
##' @param gplnum GPL(GEO platform) number, eg: GPL570
##' @return a dataframe which contains 146 GEO platform information .
getGPLlist <- function(){
  tryCatch(utils::data("ALL_GPL_LIST", package = "AnnoProbe"))
  gplList <- ALL_GPL_LIST
  return(gplList)
}

