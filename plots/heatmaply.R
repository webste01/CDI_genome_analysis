library("plotly",lib.loc="/hpc/users/webste01/R_libs")
library("ggplot2",lib.loc="/hpc/users/webste01/R_libs")
library("heatmaply",lib.loc="/hpc/users/webste01/R_libs")
library("htmlwidgets",lib.loc="/hpc/users/webste01/R_libs")

pr<-read.table("/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/gene_presence_absence.Rtab",header=T,row.names=1)
nonzero<-pr[rowSums(pr)!="0",]
pr_formatted<-nonzero[rowSums(nonzero)!=ncol(nonzero),]
mat<-as.matrix(pr_formatted)
hm<-heatmap(mat,main = "Difference in gene presence", density.info="none", trace="none")
dat_ordered<-mat[hm$rowInd,hm$colInd]


feat<-read.csv("/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/features.csv",head=T)
rownames(feat)<-feat$Max.ID
feat["CollectionYear"]<-as.Date(feat$Collectiondate)
feat["CollectionYear"]<-format(feat$CollectionYear,'%Y')

feat <- subset(feat,MaxID %in% colnames(mat))
feat[is.na(feat)] <- 0

annotation_row = data.frame(Year=feat$CollectionYear,Unit=feat$Unit,MLST=feat$MLST)
rownames(annotation_row) = feat$MaxID

Var1<-colorRampPalette(brewer.pal(11, "Spectral"))(length(unique(annotation_row$Year)))
names(Var1)<-unique(annotation_row$Year)
Var1<-as.matrix(Var1)
test<-merge(annotation_row,Var1,by.x="Year",by.y="row.names",all=TRUE)

Var2<-colorRampPalette(brewer.pal(11, "Spectral"))(length(unique(annotation_row$MLST)))
names(Var2)<-unique(annotation_row$MLST)
Var2<-as.matrix(Var2)
test2<-merge(test,Var2,by.x="MLST",by.y="row.names",all=TRUE)

ann_colors<-list(MLST=test2$V1.y,Year=test2$V1.x)



heatmaply(dat_ordered, Colv=FALSE,Rowv=FALSE,ylab = "Genes",xlab = "Isolate", main = "Gene presence/absence heatmap",margins = c(60,100,40,20),colors = c("white", "blue"),col_side_colors=ann_colors)  %>% saveWidget(file="192_presence_absence.html",selfcontained = FALSE)

