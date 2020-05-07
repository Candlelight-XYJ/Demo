args <- commandArgs(T)

data <- read.table(args[1],row.names=1,head=T,sep="\t")

data <- as.matrix(data)

print (typeof(data))
print (mode(data))
#head(data)

#print (length(rownames(data)))
#print (length(colnames(data)))

#head <- matrix(c("pvalue(Z1Z2)","pvalue(Z1Z3)","pvalue(Z2Z3)","mean(Z1)","mean(Z2)","mean(Z3)","median(Z1)","median(Z2)","median(Z3)"),nrow=1)
#write.table(head,args[2],sep="\t",quote=F,row.names=F,col.names=F)
for (rn in rownames(data)){
	a1 <- as.numeric(data[rn,1:4])
	a2 <- as.numeric(data[rn,5:8])
	t12 <- t.test(a1,a2)
	p12 <- t12$p.value
	result <- matrix(c(rn,p12),nrow=1)
#	result <- matrix(c(rn,p12,p13,p23,mean(a1),mean(a2),mean(a3),median(a1),median(a2),median(a3)),nrow=1)
	write.table(result,args[2],sep="\t",quote=F,row.names=F,col.names=F,append=T)	
}

