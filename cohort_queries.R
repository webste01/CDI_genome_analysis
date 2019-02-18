#Read in the cohort data
dat<-read.table("CDI_cohort.txt",header=T,sep=",")
#Read in the assemblies table (tAssemblies)
assem<-read.table("tAssemblies_2.17.19.csv",header=T,sep=";")
#Set the startdate
startdate=as.Date("2015-09-01",format="%Y-%m-%d")
#Read in visits data
visits<-read.csv("patient_encounters_table.csv",header=T)
visits2<-visits[visits$eRAP_ID %in% dat$eRAP_ID,]
visits2$start_date<-as.Date(visits2$start_date,format="%Y-%m-%d")
visits2$end_date<-as.Date(visits2$end_date,format="%Y-%m-%d")
visits2<-visits2[visits2$start_date > startdate,]
rm(visits)
#Split Extract ID so that it matches specimen ID
tmp <- unlist(strsplit(as.character(assem$Extract.ID), "[.]"))
cols <- c("specimen_ID", "clone")
nC <- length(cols)
ind <- seq(from=1, by=nC, length=nrow(assem))
for(i in 1:nC) {
   assem[, cols[i]] <- tmp[ind + i - 1]
 }
#Convert date column to date object in R
dat$specimen_sampling_date <- as.Date(dat$specimen_sampling_date,format="%m/%d/%y")
#Date of the first CDI isolate (primary isolate) CHANGE TO ONLY CD SAMPLES 
dat_CD<- dat[grep("CD",dat$specimen_ID ), ]
prim<-aggregate(specimen_sampling_date~eRAP_ID,dat_CD,min)
prim_ICU<-merge(dat_CD,prim,by.x=c("eRAP_ID","specimen_sampling_date"), by.y=c("eRAP_ID","specimen_sampling_date"),l.x=F,all.y=T)
#Primary isolate sequenced
prim_ICU["sequenced"]<- ifelse(prim_ICU$specimen_ID %in% assem$specimen_ID, "1", 0)
#ST of the primary isolate
st<-assem[,c("specimen_ID","MLST")]
prim_all<-merge(prim_ICU, st, by.x="specimen_ID",by.y="specimen_ID",all.x=TRUE, all.y=FALSE)
prim_all$specimen_sampling_date<-as.Date(prim_all$specimen_sampling_date,format="%m/%d/%y")
#Get the hospital location of the first isolate
namevector<-c(colnames(prim_all),colnames(visits2))
prim_new<-data.frame(matrix(, nrow=1, ncol=0))
prim_new[,namevector] <- NA
prim_new[,c("specimen_sampling_date")]<-as.Date(startdate,format="%Y-%m-%d")
prim_new[,c("end_date")]<-as.Date(startdate,format="%Y-%m-%d")
prim_new[,c("start_date")]<-as.Date(startdate,format="%Y-%m-%d")
column_names_tmp<-c("specimen_ID","eRAP_ID","specimen_sampling_date","plot_order","specimen_location","freezer_ID", "freezer_box_ID","freezer_box_position", "specimen_type","sequenced","MLST","auto_ID","eRAP_ID","died_visit_id","start_date","end_date","department_name","transfer_to","encounter_type","age","sex","BMI","smoker","Colorectal_Cancer","UC","CROHNS","IBD","IBS","race","ethnic_group")
column_names_visit<-c("auto_ID","eRAP_ID","died_visit_id","start_date","end_date","department_name","transfer_to","encounter_type","age","sex","BMI","smoker","Colorectal_Cancer","UC","CROHNS","IBD","IBS","race","ethnic_group")
for (i in 1:nrow(prim_all)){
	prim_tmp<-prim_all[i,]
	prim_tmp$specimen_sampling_date<-as.Date(prim_tmp$specimen_sampling_date,format="%m/%d/%y")
	visit<-visits2[visits2$eRAP_ID == prim_tmp$eRAP_ID & prim_tmp$specimen_sampling_date >= visits2$start_date & prim_tmp$specimen_sampling_date < visits2$end_date,]
	if (nrow(visit)==0) {
		visit<-data.frame(matrix(, nrow=1, ncol=0))
		visit[,column_names_visit] <- NA
		tmp<-cbind(prim_tmp, visit)
		colnames(tmp)<-column_names_tmp
		tmp[,c("specimen_sampling_date")]<-as.Date(tmp$specimen_sampling_date,format="%Y-%m-%d")
		tmp[,c("end_date")]<-as.Date(startdate,format="%Y-%m-%d")
		tmp[,c("start_date")]<-as.Date(startdate,format="%Y-%m-%d")
		tmp[,c("department_name")]<-"None"
		prim_new<-rbind.data.frame(prim_new,tmp)
		rm(tmp)
	} else {
	tmp<-cbind(prim_tmp,visit)
	tmp$specimen_sampling_date<-as.Date(tmp$specimen_sampling_date,format="%Y-%m-%d")
	tmp$start_date <-as.Date(tmp$start_date,format="%Y-%m-%d")
	tmp$end_date<-as.Date(tmp$end_date,format="%Y-%m-%d")
	prim_new<-rbind.data.frame(prim_new,tmp) 
	rm(tmp)}
}

prim_new = prim_new[-1,]
#Keep only columns we want
drop <- c("freezer_ID", "freezer_box_ID", "freezer_box_position","encounter_type","transfer_to","eRAP_ID.1", "died_visit_id")
prim_new2<-prim_new[ , !(names(prim_new) %in% drop)]

#Make sure there are no missing
#'%!in%' <- function(x,y)!('%in%'(x,y))
#missing<-prim_all[prim_all$eRAP_ID %!in% prim_new2$eRAP_ID,]

write.table(prim_new2,"primary_isolate_info.csv",quote=F,sep=",",row.names=FALSE)

#Total number of CD samples
dat2<-dat
dat2["swab"]<- ifelse(grepl("SW",dat2$specimen_ID), "1", 0)
dat2["stool"]<- ifelse(grepl("RC",dat2$specimen_ID), "1", 0)
dat2["CD"]<- ifelse(grepl("CD",dat2$specimen_ID), "1", 0)

tmp<-dat2[,c("eRAP_ID","swab","CD","stool")]
tmp$Patient.ID<-as.factor(tmp$Patient.ID)
tmp$CD<-as.numeric(tmp$CD)
tmp$stool<-as.numeric(tmp$stool)
tmp$swab<-as.numeric(tmp$swab)

agg_CD<-aggregate(CD~eRAP_ID,tmp,sum)
agg_swab<-aggregate(swab~eRAP_ID,tmp,sum)
agg_stool<-aggregate(stool~eRAP_ID,tmp,sum)
cohort_seq<-merge(agg_CD,agg_swab,by.x="eRAP_ID",by.y="eRAP_ID",all.x=T,all.y=T)
cohort_seq<-merge(cohort_seq,agg_stool,by.x="eRAP_ID",by.y="eRAP_ID",all.x=T,all.y=T)
write.table(cohort_seq,"cohort_sequencing_dat.csv",quote=F,sep=",",row.names=FALSE)

#Number of visits
n_visits<-as.data.frame(table(visits2$eRAP_ID))

#Total length of stay across all visits
visits3<-visits2
visits3["length_of_stay"]<-abs(visits3$end_date - visits3$start_date)
total_length_stay<-aggregate(length_of_stay~eRAP_ID,visits3,sum)

#N ICUs (departments)  visited
n_ICUs_visited<-aggregate(department_name~eRAP_ID,visits3, function(x) length(unique(x)))

#N samples collected before and after CDI
prim3<-prim_all[,c("specimen_ID", "eRAP_ID", "specimen_sampling_date")]

before_after_counts<-data.frame(matrix(, nrow=1, ncol=0))
namevector2<-c("eRAP_ID","before_primary_count","after_primary_count","same_day_primary_count")
before_after_counts[,namevector2] <- NA

#Remove CDI negative from dat
dat3<-dat[dat$specimen_type!="CDI negative",]

rm(tmp)
for (i in 1:nrow(prim3)){
	tmp_prim3<-prim3[i,]
        tmp_dat<-dat3[dat3$eRAP_ID==tmp_prim3$eRAP_ID,]
	tmp_prim3$specimen_sampling_date<-as.Date(tmp_prim3$specimen_sampling_date,format="%Y-%m-%d")
	tmp_dat$specimen_sampling_date<-as.Date(tmp_dat$specimen_sampling_date,format="%Y-%m-%d")
	#Remove overlap
	tmp_dat<-tmp_dat[!(tmp_dat$specimen_ID==tmp_prim3$specimen_ID),]
	cd_date<-tmp_prim3$specimen_sampling_date
	after<-tmp_dat[tmp_dat$specimen_sampling_date>cd_date,]
	before<-tmp_dat[tmp_dat$specimen_sampling_date<cd_date,]
	same<-tmp_dat[tmp_dat$specimen_sampling_date==cd_date,]
	after_c<-nrow(after)
	before_c<-nrow(before)
	same_c<-nrow(same)
	tmp<-cbind(tmp_prim3$eRAP_ID,before_c, after_c,same_c)
	colnames(tmp)<-namevector2
	before_after_counts<-rbind(before_after_counts,tmp)
	rm(tmp)
}

before_after_counts = before_after_counts[-1,]


#Make 1 large data table with all information

final<-merge(prim_new2, cohort_seq, by.x="eRAP_ID",by.y="eRAP_ID",all.x=TRUE,all.y=TRUE)
final2<-merge(final,n_visits, by.x="eRAP_ID",by.y="Var1",all.x=TRUE,all.y=TRUE)

drop<-c("age","sex","BMI","smoker","Colorectal_Cancer","UC","CROHNS","IBD","IBS","race","ethnic_group")
final2<-final2[ , !(names(final2) %in% drop)]

colnames(final2)<-c("eRAP_ID","primary_specimen_ID","specimen_sampling_date","plot_order","specimen_location","specimen_type","primary_sequenced","primary_MLST","auto_ID","primary_visit_start_date","primary_visit_end_date","department_name","N_CD_samples","N_SW_samples","N_RC_samples","N_visits")


final3<-merge(final2, total_length_stay,by.x="eRAP_ID",by.y="eRAP_ID",all.x=TRUE,all.y=TRUE)
colnames(n_ICUs_visited)<-c("eRAP_ID","N_depts_visited")

final4<-merge(final3, n_ICUs_visited,by.x="eRAP_ID",by.y="eRAP_ID",all.x=TRUE,all.y=TRUE)
final5<-merge(final4, before_after_counts, by.x="eRAP_ID",by.y="eRAP_ID",all.x=TRUE,all.y=TRUE)

#Remove identical rows
final6<-final5[!duplicated(final5), ]	
write.table(final6,"cohort_agg_data.csv",quote=F,sep=",",row.names=FALSE)






