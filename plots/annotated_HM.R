library(ggdendro)
library(reshape)
library(gplots)
library(ggplot2)
library(NMF)
library(pheatmap)


pr<-read.table("gene_presence_absence.Rtab",header=T,row.names=1)
nonzero<-pr[rowSums(pr)!="0",]
pr_formatted<-nonzero[rowSums(nonzero)!=ncol(nonzero),]
mat<-as.matrix(pr_formatted)



hm<-heatmap.2(mat,main = "Difference in gene presence", density.info="none", trace="none")
dat_ordered<-mat[hm$rowInd,hm$colInd]
n=length(unique(c(dat_ordered)))
colors = structure(circlize::rand_color(n-2))



feat<-read.csv("features.csv",head=T)
rownames(feat)<-feat$Max.ID
feat["CollectionYear"]<-as.Date(feat$Collectiondate)
feat["CollectionYear"]<-format(feat$CollectionYear,'%Y')

feat <- subset(feat,MaxID %in% colnames(mat))

annotation_row = data.frame(Year=feat$CollectionYear,Unit=feat$Unit,MLST=feat$MLST)
rownames(annotation_row) = feat$MaxID

Var1<-colorRampPalette(brewer.pal(11, "Spectral"))(length(unique(annotation_row$Year)))
names(Var1)<-unique(annotation_row$Year)
Var2<-colorRampPalette(brewer.pal(11, "Spectral"))(length(unique(annotation_row$Unit)))
names(Var2)<-unique(annotation_row$Unit)
Var3<-colorRampPalette(brewer.pal(11, "Spectral"))(length(unique(annotation_row$MLST)))
names(Var3)<-unique(annotation_row$MLST)
ann_colors<-list(Var1 = Var1, Var2 = Var2,Var3=Var3)

#Rownames need to correspond to row names of mat
pdf("annotated_heatmap.pdf",height=10,width=10)
pheatmap(t(dat_ordered), Rowv = T, Colv = T,color=c("lightgrey","cornflowerblue"),legend=T,annotation_row = annotation_row,fontsize = 6.5,fontsize_row=6,fontsize_col = 6, gaps_col=50,layout = '_',annotation_colors = ann_colors)
dev.off()
