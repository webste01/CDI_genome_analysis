library("d3heatmap",lib.loc="/hpc/users/webste01/R_libs")
library("ggplot2", lib="~/R_libs/")
library("plotly", lib="~/R_libs/")
library("heatmaply", lib="~/R_libs/")
library("xtable", lib="~/R_libs/")
library("mime", lib="~/R_libs/")
library("crosstalk", lib="~/R_libs/")
library("DEoptimR", lib="~/R_libs/")
library("whisker", lib="~/R_libs/")
library("fpc", lib="~/R_libs/")
library("seriation", lib="~/R_libs/")
library("proto", lib="~/R_libs/")
library("htmlwidgets",lib="~/R_libs/")
library("httpuv",lib="~/R_libs/")
library("d3heatmap",lib="~/R_libs/")

ordered_gene_list <- read.table("/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/ordered_gene_list.txt")
pr<-read.table("/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/gene_presence_absence.Rtab",header=T,row.names=1)
nonzero<-pr[rowSums(pr)!="0",]
pr_formatted<-nonzero[rowSums(nonzero)!=ncol(nonzero),]
mat<-as.matrix(pr_formatted)
hm<-heatmap(mat,main = "Difference in gene presence", density.info="none", trace="none")
dat_ordered<-mat[hm$rowInd,hm$colInd]

header_col<-read.table("/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/header_cellnote.txt",header=F)
cellnote_tab<-read.table("/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/cell_note_file.txt",header=F)
colnames(cellnote_tab)<-header_col$V1
rownames(cellnote_tab)<-ordered_gene_list$V1

#Make sure the odering of dat_ordered and cellnote_tab are the same
cellnote_tab<-cellnote_tab[colnames(dat_ordered)]
test<-cellnote_tab[match(rownames(dat_ordered), rownames(cellnote_tab)),]
cellnote_tab<-test
map <- d3heatmap(dat_ordered, Colv=FALSE,Rowv=FALSE,ylab = "Genes",xlab = "Isolate",cellnote=cellnote_tab, main = "Gene presence/absence heatmap",color = "Blues")
saveWidget(map,"192_presence_absence.html",selfcontained = FALSE)

#Keeping only genes that are present in >3 isolates
dat_ordered2<-dat_ordered[rowSums(dat_ordered) > 3,]

#update the cellnote with new rows
cellnote2<-cellnote_tab[rownames(cellnote_tab) %in% rownames(dat_ordered2),]

#Keep only mlst1 isolates
dat_ordered2_ST1<-dat_ordered2[,colnames(dat_ordered2) %in% c("u00000crpx_c_020474","u00000crpx_c_020475","u00000crpx_c_020482","u00000crpx_c_020695","u00000crpx_c_020710","u00000crpx_c_020711","u00000crpx_c_021015","u00000crpx_c_021026","u00000crpx_c_022943","u00000crpx_c_022944","u00000crpx_c_023063","u00000crpx_c_023064","u00000crpx_c_023162","u00000crpx_c_023299","u00000crpx_c_023581","u00000crpx_c_023585","u00000crpx_c_023591","u00000crpx_c_023625","u00000crpx_c_023627","u00000crpx_c_023960","u00000crpx_c_023961","u00000crpx_c_024051","u00000crpx_c_024223","u00000crpx_c_024530","u00000crpx_c_024531","u00000crpx_c_024595","u00000crpx_c_024596","u00000crpx_c_024608","u00000crpx_c_024609","u00000crpx_c_024643","u00000crpx_c_024656","u00000crpx_c_024703","u00000xxpx_o_020481","u00000xxpx_o_020688","u00000xxpx_o_020696","u00000xxpx_o_020697","u00000xxpx_o_023061","u00000xxpx_o_023300","u00000xxpx_o_024065","u00000xxpx_o_024607","u00000xxpx_o_024646","u00000xxpx_o_024762","u00001crpx_c_023622","u00001crpx_c_024642","u00001crpx_c_025515","u00003crpx_c_025298","u00004crpx_c_024645","u00005crpx_c_025390","u00005xxpx_o_024095","u00006crpx_c_023147","u00006xxpx_o_025504")]

cellnote2_ST1<-cellnote2[,colnames(cellnote2) %in% colnames(dat_ordered2_ST1)]

#Keep only genes that are present in >3 isolates
test<-dat_ordered2_ST1[rowSums(dat_ordered2_ST1) > 3,]
dat_ordered2_ST1<-test
cellnote2_ST1<-cellnote2_ST1[rownames(cellnote2_ST1) %in% rownames(dat_ordered2_ST1),]

#Take out gene shared by all
test2<-dat_ordered2_ST1[rowSums(dat_ordered2_ST1)!=ncol(dat_ordered2_ST1),]
dat_ordered2_ST1<-test2
cellnote2_ST1<-cellnote2_ST1[rownames(cellnote2_ST1) %in% rownames(dat_ordered2_ST1),]




ST1<- d3heatmap(dat_ordered2_ST1, Colv=FALSE,Rowv=FALSE,cellnote=cellnote2_ST1,color="Blues")
saveWidget(ST1,"ST1_presence_absence.html",selfcontained = FALSE)
