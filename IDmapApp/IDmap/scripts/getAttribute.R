loadGPLinfo <- function(){
  GPLinfo = openxlsx::read.xlsx("./data/gpl_list.xlsx")
  return(GPLinfo)
}

getSpecies <- function(GPLnum,GPLinfo){
  GPLspecie <- GPLinfo[which(GPLinfo$gpl==GPLnum),3]
  res <- switch(GPLspecie,
                "Homo sapiens" = "human",
                "Mus musculus" = "mouse",
                "Rattus norvegicus" = "rat")
  return(res)
}

getArrayType <- function(GPLnum,GPLinfo){
  GPLtype <- GPLinfo[which(GPLinfo$gpl==GPLnum),6]
  res <- switch(GPLtype,
                "Affy" = "exp",
                "gpl" = "exp",
                "lncRNA" = "lncRNA")
  return(res)
}