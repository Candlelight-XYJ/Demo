setwd("E:/GitHub/Demo/scRNA-seq/")
## read FACS Smartseq2 data
dat = read.delim("FACS/FACS_tissue/Kidney-counts.csv", sep=",", header=TRUE)
dat[1:5,1:5]
dim(dat)
## add rownames, and delete the first col
rownames(dat) <- dat[,1]
dat <- dat[,-1]

## check if has ERCC seq
rownames(dat)[grep("^ERCC-", rownames(dat))]

## extract much of the metadata for this data from the column names
cellIDs <- colnames(dat)
cell_info <- strsplit(cellIDs, "\\.")
Well <- lapply(cell_info, function(x){x[1]})
Well <- unlist(Well)
Plate <- unlist(lapply(cell_info, function(x){x[2]}))
Mouse <- unlist(lapply(cell_info, function(x){x[3]}))

## check the distributions of each of these metadata classifications
summary(factor(Mouse))
# summary(factor(Plate))
table(Mouse, Plate)
##  read the computationally inferred cell-type annotation 
##  and match them to the cell in our expression matrix
ann <- read.table("FACS/annotations_FACS.csv", sep=",", header=TRUE)
ann <- ann[match(cellIDs, ann[,1]),]
celltype <- ann[,3]




