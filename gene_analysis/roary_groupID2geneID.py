import os
import sys
import csv

#Gene presence and absence csv
pa = 'gene_presence_absence.csv'

#gff fofn used by roary
gff_fofn = 'gff.fofn'
gff_dir='fixed_input_files/'

group2geneID={}
prokka2geneID={}
out = "groupID2prokkaID2geneID_all.txt"
with open(out,'w') as out_file:  
        with open(pa,'rb') as csvfile:
                reader = csv.reader(csvfile,delimiter=',', quotechar='"')
                for row in reader:
                        group_id = row[0]
                        for item in row:
                                if "PROKKA" in item:
                                        p_id=item.split(':')[0]
                                        other = item.split('::')[1]
                                        fn=other.split(':')[0]
                                        fn1= gff_dir + fn + ".gff"
					print fn1
                                        if not os.path.isfile(fn1):
                                                fn1 = gff_dir + fn + ".gff"
                                        with open(fn1) as gff_file:
                                                for l in gff_file:
                                                        if p_id in l:
                                                                if "gene=" in l:
                                                                        tmp=l.split('gene=')[1]
                                                                        tmp2=tmp.split(';')[0]
									prokka2geneID[p_id]=tmp2
									out_file.write("%s %s %s" %(group_id,p_id,tmp2))	
									out_file.write("\n")
								else:
									continue
							else:
								continue
out_file.close()
