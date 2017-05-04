#Make gene lists to use with GO analysis
#Takes in the *csv file of unique or shared genes, and the prokka2group.txt file, and the percentage sample cutoff (i.e. do these genes need to be present in 100% of the samples?) as well as the outname 
#Extracts genes that are in X percent of the samples

args = commandArgs(trailingOnly = T)
roaryfn = args[[1]]
prok2group = args[[2]]
cutoff = as.integer(args[[3]])
outname = args[[4]]

p2g<-read.table(prok2group,header=T)
fn<-read.csv(roaryfn,header=T,row.names=1)
n<-max(fn$No..isolates)
n_include<-ceiling((cutoff*n)/100)
fn_subset<-subset(fn,No..isolates>n_include)
merged<-merge(p2g,fn_subset,by.x="Chr",by.y="row.names")
gene_list<-data.frame(unique(merged$GeneID))
write.table(t(gene_list), file=paste0(outname,".csv"), quote=F,row.names=FALSE,sep=",",col.names=FALSE)


