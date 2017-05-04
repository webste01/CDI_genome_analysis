#!/usr/bin/python
#Create a roary comparison script given mlst map and gff.fofn and comparisons by mlst type
#Input: python create_comparison_script.py  mlst_gff_map.txt gff.fofn 1 42 #Compares mlst types 1 and 42
import os
import sys

map=sys.argv[1]
gff_fofn=sys.argv[2]
mlst1=int(sys.argv[3])
mlst2=sys.argv[4]

if mlst2 in ["others"]:
	out_name="compare_ST%i_vsAll.sh" %(mlst1)
else:
	out_name="compare_ST%i_ST%i.sh" %(mlst1,int(mlst2))

out_file = open(out_name,'w')
out_file.write("query_pan_genome -a difference --input_set_one ")
map_dict={}

#Create dictionary of gff file to mlst type
with open(map) as gm:
	for l in gm:
		f = l.strip().split()
		fn = str(f[0])
		type = f[1]
		map_dict[fn] = type


mlst1_list=[]
mlst2_list=[]
with open(gff_fofn) as gf:
	for l in gf:
		ll = l.strip().split()
		ST = map_dict[ll[0]]
		if ST not in ["No_match","None"]:
			ST=int(ST)
			if ST == mlst1:
				mlst1_list.append(ll)
			elif ST == mlst2:
				mlst2_list.append(ll)
			elif mlst2 in ["others"]:
				mlst2_list.append(ll)

for idx, file in enumerate(mlst1_list):
    if idx == len(mlst1_list) - 1:
    	out_file.write(str(file[0]))
    else:
	out_file.write(str(file[0]))
	out_file.write(",")
				
out_file.write(" --input_set_two ")
for idx, file in enumerate(mlst2_list):
    if idx == len(mlst2_list) - 1:
        out_file.write(str(file[0]))
    else:
        out_file.write(str(file[0]))
        out_file.write(",")

