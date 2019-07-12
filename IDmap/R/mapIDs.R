########################################
##                                    ##
## code last update: July 12, 2019    ##
##                                    ##
########################################

##' Get Annotation
##'
##' \code{getAnno} returns annotations for target gpl
##' @param gplnum,source,biotype,lncRNA
##'
##' @return
##'
##' @examples
##' probeids <- c("A_23_P101521","A_33_P3695548","A_33_P3266889")
##' gplnum <- "GPL10332"
##' humanAnno <- getAnno(gplnum)
##' head(humanAnno)
##' @export
getAnno <- function(gplnum, source="pipe", biotype="protein_coding", lncRNA=F){
  if (missing(gplnum)){
    stop("No valid gplnum passed in !")
  }
  flag <- checkGPL(gplnum)
  if(!flag){
    stop("please check your platform is in our gpl list \t
         or you can use function `getGPLsoft()` to download soft annotations from GEO \t
         or you can use our shinyAPP to custom annotate your probe sequences!")
  }
  gplList <- getGPLlist()
  ## check species
  species <- switch(gplList[gplList$gpl == gplnum, 3],
                    "Homo sapiens" = "human" ,
                    "Mus musculus" = "mouse"  ,
                    "Rattus norvegicus" = "rat"
  )
  ## load annotations
  if(lncRNA==T){
  annoData <- paste0(species, "_lncRNA_anno")
  }else{
  annoData <- paste0(species, "_all_anno")
  }
  if(!(annoData %in% ls())){
  eval(parse(text = paste0("tryCatch(utils::data( ",annoData,", package = 'IDmap'))")))
    }
  res = eval(parse(text = paste0(annoData,"$",gplnum)))
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
  biotypeFilter <- eval(parse(text=paste0("sourceFilter[sourceFilter$biotype==","\'",biotype,"\'",",]")))
  biotypeFilter <- biotypeFilter[,-ncol(biotypeFilter)]
  biotypeFilter <- biotypeFilter[!duplicated(biotypeFilter),]
  return(biotypeFilter)
}

##' Mapping probeIds to gene symbols
##'
##' \code{probeIdmap} returns a list of gene ids for the input probe ids
##' @param probeids,gplnum,biotype,source
##'
##' @return if the input dataset is in our platform list(see our manual) ,then the output will be a dataframe,
##' which includes a list of gene ids mapping to probe ids
##'
##' @example
##' probeids <- c("A_23_P101521","A_33_P3695548","A_33_P3266889","A_33_P3266886")
##' gplnum <- "GPL10332"
##' source <- "pipe"
##' biotypr <- "protein_coding"
##' lncRNA <- FALSE
##' datasets <- getAnno(gplnum,source, biotype,lncRNA)
##' mapRes <- probeIdmap(probeids, datasets)
##' head(mapRes)
##' @export
probeIdmap <- function(probeids, datasets){
  if (missing(probeids)){
    stop("No valid probeids passed in !")
  }
  ## ids mapping results
  res <- datasets[match(probeids,datasets$probe_id),]
  missIds <- probeids[!(probeids %in% res$probe_id)]
  if(length(missIds)!=0){
   warning(paste0("probeid ",missIds ," are missing in datasets \n"))
  }

  rownames(res) <- NULL
  return(res)
}

#probeIdmap <- function(probeids, gplnum, source, biotype, lncRNA=F){
#  if (missing(probeids)){
#    stop("No valid probeids passed in !")
#  }
#  flag <- checkGPL(gplnum)
#  if(!flag){
#    stop("please check your platform is in our gpl list \t
#         or you can use function `getGPLsoft()` to download soft annotations from GEO")
#  }
#  ## load data
#  datasets <- getAnno(gplnum, source, biotype, lncRNA)
#  ## ids mapping result
#  res <- datasets[match(probeids,datasets),]
#  return(res)
#}

##' Get GPL info
##'
##' \code{getGPLinfo} returns a list of gene ids for the input probe ids.input
##' @param gplnum
##' @return
##' @examples
getGPLinfo <- function(gplnum){
  allgpl <- getGPLlist()
  return(allgpl[match(gplnum,allgpl$gpl), ])
}


##' Check the input gpl if in our platform list
##' @param gplnum
##' @return returns a boolean value
##' @export
checkGPL <- function(gplnum){
  allgpl <- getGPLlist()
  flag = (gplnum %in% allgpl$gpl)
  return(flag)
}

##' Get GPL list
##'
##' \code{getGPLinfo} returns a list of gene ids for the input probe ids.input
##' @param gplnum
##' @return
##' @examples
getGPLlist <- function(){
  tryCatch(utils::data("ALL_GPL_LIST", package = "IDmap"))
  gplList <- ALL_GPL_LIST
  return(gplList)
}

