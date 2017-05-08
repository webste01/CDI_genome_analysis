library(ggdendro)
library(reshape)
library(gplots)
library(ggplot2)
library(NMF)

#Read in the phage table and the gene presence/absence csv output from roary
pa<-read.csv("gene_presence_absence_edit.csv",header=T,row.names=1)
pr<-read.table("gene_presence_absence.Rtab",header=T,row.names=1)

nonzero<-pr[rowSums(pr)!="0",]
pr_formatted<-nonzero[rowSums(nonzero)!=ncol(nonzero),]
mat<-as.matrix(pr_formatted)

phage_tab<-read.table("phage_table")

#Keep only the phage name and gene ID from the phage table
pt<-phage_tab[,c("V1","V4")]

#remove duplicated phages
pt1<-pt[!duplicated(pt), ]

#Remove first columns from the presence / absence matrix
new <- pa[,14:ncol(pa)]

#Replace matching genes from the matrix with phage elements based on matching prokka IDs
new[]<-lapply(new, function(x) pt1$V4[match(x, pt1$V1)])


#get non NA instances from the table
nonNA <- which(!is.na(new), TRUE)

#Create shell matrix where the rows and columns have the bacterial species
color2bact<-matrix(0,nrow=nrow(nonNA),ncol=2)

dat<-pr_formatted
for (i in 1:nrow(nonNA)){
	row_val=nonNA[i,1]
	col_val=nonNA[i,2]
	sub<- subset(nonNA,nonNA[,1] == row_val & nonNA[,2] == col_val)
	group<-rownames(sub)
	bact_species<-new[row_val,col_val]
	dat[row.names(dat)==group,col_val]<-as.factor(bact_species)
	color2bact[i,1]<-as.character(bact_species)
	color2bact[i,2]<-as.factor(bact_species)
	
}

#Write out a table of bacteria to color mapping
map<-data.frame(unique(color2bact))
colnames(map)<-c("Bacterial_species","color")
write.table(map,"color2bacteria.txt",quote=F,row.names=F)

#Convert to matrix
dat<-as.matrix(dat)

#Make heatmap of 0/1 matrix to get cluster ordering
hm<-heatmap.2(mat),main = "Difference in gene presence", density.info="none", trace="none") 

#Order the matrix with phage elements by the same order as the 0/1 clustered matrix
dat_ordered<-dat[hm$rowInd,hm$colInd]
n=length(unique(c(dat_ordered)))
colors = structure(circlize::rand_color(n-2))
pdf("phage_colored_heatmap.pdf",height=10,width=10)
aheatmap(dat_ordered, Rowv = NA, Colv = seq(ncol(dat_ordered),1),col=c("white","cornflowerblue",colors), legend=T)
dev.off()

#Write out mapping of bacteria species to color






