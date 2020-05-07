library(countToFPKM)
## step1
# read counts data
file.readcounts <- system.file("extdata", "RNA-seq.read.counts.csv", package="countToFPKM")
# read 
file.annotations <- system.file("extdata", "Biomart.annotations.hg38.txt", package="countToFPKM")
file.sample.metrics <- system.file("extdata", "RNA-seq.samples.metrics.txt", package="countToFPKM")
