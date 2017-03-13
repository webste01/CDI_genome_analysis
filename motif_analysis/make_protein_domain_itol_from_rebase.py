#Takes in a csv with the following collumns:
#Ex:
#20327,OX00019_1A,I,R,CdiEW1IP,1032.00,hsdR,CANNNNNNNTAAAG
#20327,OX00019_1A,I,S,S.CdiEW1I,418.00,hsdS,CANNNNNNNTAAAG

#Assembly id, CD#, RM System type, subunit type, rebase gene name, length of amino acids, gene name, motif
#Outputs a protein domain schematic for itol and a motif matrix schematic for itol
import sys
import os
import string
from collections import defaultdict
from pandas import *

#Set up the color scheme for each restriction modification subunit type
color={}
color['R'] = "#ff0000"
color['S'] = "#00ff00"
color['M'] = "#0000ff"
color['C'] = "#ffff00"
color['RM'] = "#800080"


#Motifs dict
motifs = {}  #keyed on [gene_name][motif], binary values if present or not

in_file = sys.argv[1] #comma separated file as described above
main_file=open(sys.argv[1],'r+')

subunit_dict = defaultdict(list)
AAlength_dict = defaultdict(list)
motif_dict = defaultdict(list)
AAlength_subunit_dict = defaultdict(list)
for line in main_file:
	l = line.strip().split(',')
	assem_id=l[0]
	iso_id=l[1]
	RM_type=l[2]
	subunit=l[3]
	gene_id=l[4]
	AA_length=int(l[5])
	gene_name=l[6]
	motif = l[7]
	if "hsd" in gene_name:
		if "_" in gene_name:
			first_part = gene_name.split("_")[0]
			first_part = first_part[:-1]
			second_part = gene_name.split("_")[1]
			gene_name = first_part + second_part
		else:
			gene_name=gene_name[:-1]
	operon_id = iso_id + "_" + gene_name
	subunit_dict[operon_id].append(subunit)
	tmp = [(subunit,AA_length)]
	AAlength_subunit_dict[operon_id].append(tmp)
	AAlength_dict[operon_id].append(AA_length)
	motifs[operon_id] = {}
	motifs[operon_id][motif] = 1

df = DataFrame(motifs).T.fillna(0)
with open("motif_matrix.csv",'w') as f:
	df.to_csv(f,float_format='%.0f',header=False)

with open("motif_for_itol.txt",'w') as mf:
	motif_list = list(df.columns.values)
	str_list = filter(None,motif_list)
	x=0
	for item in str_list:
		x=x+1	
	mlist = ",".join(str_list)
	color_string = str('#202020,'*x)
	mf.write("DATASET_EXTERNALSHAPE" + "\n" + "SEPARATOR COMMA" + "\n" + "DATASET_LABEL,Motifs" + "\n" + "FIELD_COLORS," + color_string+"\n" + "COLOR,#ff0000" + "\n" + "FIELD_LABELS," + mlist + "\n" + "LEGEND_LABELS," + mlist + "\n" + "MARGIN,20" "\n" + "SHAPE_TYPE,2" + "\n" + "DATA" + "\n")
	df.to_csv(mf,float_format='%.0f',header=False)


with open("itol_features.txt",'w') as itol:
	itol.write("DATASET_DOMAINS" + "\n" + "SEPARATOR COMMA" + "\n" + "DATASET_LABEL,MTASE_operons" + "\n" + "COLOR,#ff0000" + "\n" + "DATASET_SCALE,100-amino_acid_100-#0000ff,500-line at aa500-#ff0000,1000-aa1000-#00ff00" + "\n" + "DATA" + "\n")
	for operon in subunit_dict:
		len_op = sum(AAlength_dict[operon])
		itol.write(operon + "," + str(len_op) + "," + "PR" + "|" + "1" + "|")
		tmplist= AAlength_subunit_dict[operon]
		lengths = []
		if len(tmplist) == 1:
			subunit,pos = tmplist[0][0]
                        col = color[subunit]
			itol.write(str(pos) + "|" + col + "|" + subunit + "\n")
		elif len(tmplist) ==2:
			subunit1,pos1 = tmplist[0][0]
			subunit2,pos2 = tmplist[1][0]
                        col1 = color[subunit1]
			col2 = color[subunit2]
			start = int(pos1)
			end = int(start) + int(pos2)
                        itol.write(str(pos1) + "|" + col1 + "|" + subunit1 +"," + "PR" + "|" + str(start) + "|" + str(end) + "|" + col2 + "|" + subunit2 + "\n")
		elif len(tmplist) ==3:
			subunit1,pos1 = tmplist[0][0]
			subunit2,pos2 = tmplist[1][0]
                        subunit3,pos3 = tmplist[2][0]
                        col1 = color[subunit1]
                        col2 = color[subunit2]
                        col3 = color[subunit3]
			end_first_unit = int(pos1)
			start_second_unit = int(end_first_unit)
			end_second_unit = int(start_second_unit) + int(pos2)
			start_third_unit = int(end_second_unit)
			end_third_unit = int(start_third_unit) + int(pos3)
			itol.write(str(pos1) + "|" +  str(col1) + "|" +  str(subunit1) + "," + "PR" + "|")
			itol.write(str(start_second_unit) + "|" + str(end_second_unit) + "|" + str(col2) + "|" + str(subunit2) +"," + "PR" + "|")
			itol.write(str(start_third_unit) + "|" + str(end_third_unit) + "|" + str(col3) + "|" + str(subunit3))
			itol.write("\n")


		
