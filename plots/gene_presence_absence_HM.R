library(gplots)
tab<-read.table("gene_presence_absence.Rtab",header=T,row.names=1)

nonzero<-tab[rowSums(tab)!="0",]

#Min resence in at least X isolates
#x=0
#nonzero<-tab[rowSums(tab)>x,]

diff<-nonzero[rowSums(nonzero)!=ncol(nonzero),]
dat<-as.matrix(diff)
my_palette <- colorRampPalette(c("lightgray", "cornflowerblue"))(n = 2)

pdf("gene_presence_absense_HM.pdf",width=9, height=8)
hm<-heatmap.2(dat,main = "Difference in gene presence", density.info="none", trace="none", margins =c(12,9), col=my_palette) 
dev.off()

#Get genes corresponding to the dendogram clusters
hc <- as.hclust( hm$rowDendrogram )
pdf("gene_dendogram_HM.pdf",width=9, height=8)
plot(hc)
dev.off()

#Decide what level of dendogram to separate genes
subgroup<-cutree( hc, h=3.5)[hc$order]
mat_subgroups<-as.matrix(subgroup)
sub_1<-as.matrix(mat_subgroups[mat_subgroups[,1] =="2",])
sub_2<-as.matrix(mat_subgroups[mat_subgroups[,1] =="1",])



