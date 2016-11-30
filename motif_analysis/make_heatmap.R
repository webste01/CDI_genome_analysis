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
motif_hm<-heatmap.2(df,trace="none",col=my_palette,margins=c(12,8),Rowv=TRUE,Colv=TRUE)
dev.off()
mo<-as.hclust(motif_hm$colDendrogram)
ord<-mo$order
df_ordered<-df[,c(mo$order)]
write.csv(df_ordered,"ordered_motif_matrix.csv",quote=F)
