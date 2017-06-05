#Converts the gene_presence_absence.csv 
#Takes in gene_presence_absence.csv and the dat_ordered.txt matrix and the gff directory from roary output
#Outputs a matrix the same dimensions as dat_ordered.txt but with character strings of values (gene start, gene end, gene name)

import os
import sys
import pandas as pd
import re

#csv=sys.argv[1]
csv="/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/gene_presence_absence.csv"

#dat_ordered=sys.argv[2]
dat_ordered="/sc/orga/scratch/webste01/dat_ordered.csv"

#gff_dir = sys.argv[3]
gff_dir="/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/fixed_input_files/"

#Read in the gene presence absence as a pandas table
df = pd.read_csv(csv)

#Read in the heatmap table as a pandas table
hf = pd.read_csv(dat_ordered)

#Rename the first column to be the gene name
hf=hf.rename(columns = {'Unnamed: 0':'Gene'})

#Delete columns that dont correspond to isolate names
df2=df.drop(df.columns[[1,2,3,4,5,6,7,8,9,10,11,12,13]], axis=1)

#Subset df2 to only the rows which are in the dat_ordered data frame
df3=df2.loc[df2['Gene'].isin(hf['Gene'])]

df4 = pd.DataFrame(columns=df3.columns.values, index=df3.index)

cols=list(df3.columns)
for isolate in cols:	
	i =0
	gff_name = str(gff_dir + isolate + ".gff")
	if gff_name != "/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/192_samples/fixed_input_files/Gene.gff":
		of = open("%s.txt" %(str(isolate)),'w')
 		newDf = df3.loc[:,[isolate]]
		print newDf.shape
		for index,row in newDf.iterrows():
			with open(gff_name,'r') as gff_file:
				group= str(row[isolate])
				prokka = str(group).strip().split()
				if len(prokka) == 1:
					prokka_id=str(prokka[0]).split('(')[0]
					if prokka_id == 'nan':
						i+=1
						print i
						of.write('0')
						of.write('\n')
					else:
						for line in gff_file:
							if re.search(prokka_id, line):
								 if "gene=" in line:
                                                                        tmp = line.split('gene=')[1]
                                                                        start = line.split()[3]
                                                                        end = line.split()[4]
                                                                        gene = tmp.split(';')[0]
                                                                        cell_value = str(gene) + ',' + str(start) + ',' + str(end)
                                                                        of.write(cell_value)
                                                                        i +=1
									print i
                                                                        of.write('\n')
                                                                 else:
                                                                        gene = "hypothetical"
                                                                        start = line.split()[3]
                                                                        end = line.split()[4]
                                                                        cell_value = str(gene) + ',' + str(start) + ',' + str(end)
                                                                        of.write(cell_value)
                                                                        i+=1
									print i
                                                                        of.write('\n')
				else:
					i +=1
					print i
					of.write('multiple_group_ids')
                                        of.write('\n')
	print i
