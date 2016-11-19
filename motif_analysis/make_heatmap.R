library(gplots)
args <- commandArgs(TRUE)
file<-args[1]
motmat<-read.table(paste(file,"_motif_matrix.csv",sep=""),,header=T)
df<-data.matrix(motmat)
rownames(df)<-df[,1]
df<-df[,-c(1,2)]
my_palette <- colorRampPalette(c("lightgrey","cornflowerblue"))
#Remove singletons
df = df[,colSums(df) > 1]
pdf(paste(file,".pdf",sep=""),width=9, height=8)
motif_hm<-heatmap.2(df,trace="none",col=my_palette,margins=c(12,8),Rowv=TRUE,Colv=TRUE,dendrogram='column')
dev.off()
