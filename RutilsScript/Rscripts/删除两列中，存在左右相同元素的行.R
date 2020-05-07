pearsonRes <- read.csv("C:/Users/Administrator/Desktop/pearsonJSPR.csv")

Rownum1=grep("c__",pearsonRes$geneName)
Rownum2=grep("c__",pearsonRes$geneName2)
delRownum = intersect(Rownum1, Rownum2)

res = pearsonRes[-delRownum,]

