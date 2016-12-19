import os
import sys
import subprocess


input_file=sys.argv[1] #set_difference_unique_set_one file from roary output
gff_dir=sys.argv[2]  #directory with the fixed_input_files from roary
n_iso = sys.argv[3] #min number of isolates that the gene must be in

with open(input_file,'r') as input:
	for l in input:
		l=l.strip().split()
		if len(l) > int(n_iso):
			for iso in l[1:]:
				prokka_id=iso.split("::")[0]
				tmp=iso.split("::")[1]
				contig_id=tmp.split(":")[0]
				direction=tmp.split(":")[1].split("(")[1]
				dir=direction.split(")")[0]
				gff_fn=gff_dir+"/"+contig_id+".gff"
				if str(dir) == "+":
					gene=subprocess.check_output(["/bin/grep",prokka_id, gff_fn])
				        print "+ " + gene	
				else:	
					gene=subprocess.check_output(["/bin/grep",prokka_id, gff_fn])
					print "- " + gene


