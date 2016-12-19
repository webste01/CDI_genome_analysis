#Script to take in a list of isolate gffs  and a list of gffs to compare with  and get the gene difference per genome, using roary commands
import sys
import glob
import os
list1=sys.argv[1] #list of query set
list2=sys.argv[2] #list of all genomes 
out=sys.argv[3] #name of script output
mypath=sys.argv[4] #path to fixed_input_files directory
input_list=[]
output_list=[]
i=0
j=0

print "path to GFF files:"
print mypath
with open(out,'w') as out_fn:
	out_fn.write("query_pan_genome -a difference --input_set_one ")
	with open(list1,'r') as input_set_one:
		for l in input_set_one:
                	l = l.strip().split()
			input_list.append(l[0])
		for file in os.listdir(mypath):
			for iso in input_list:
	 			if file.endswith(str(iso)+".gff"):
					out_fn.write(mypath+"/"+file)
					out_fn.write(",")
					j=j+1
	with open(list2,'r') as input_set_two:
		out_fn.write("--input_set_two ")
		for line in input_set_two:
			l = line.strip().split()
			if line[0] not in input_list:
				output_list.append(l[0])
                for file in os.listdir(mypath):
			for iso in output_list:
                                if file.endswith(str(iso)+".gff"):
                                        out_fn.write(mypath+"/"+file)
                                        out_fn.write(",")
					i=i+1
print "Numer of genomes in out set:" 
print i
print "Number of genomes in in set:" 
print j

