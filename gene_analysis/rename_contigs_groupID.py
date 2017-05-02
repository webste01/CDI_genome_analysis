from Bio import SeqIO
import sys
import os

#Renames all contigs in a fasta file
in_fa = sys.argv[1]
out_fa = sys.argv[2]


with open(out_fa,"w") as out:
	i = 1
	for record in SeqIO.parse(in_fa, "fasta"):
		full_header = record.description
		group_id = full_header.split(" ")[1]
		print group_id
    		new_id = group_id 
    		print new_id
    		out.write(">" + str(new_id))
    		out.write("\n")
    		out.write("%s" %(record.seq))
		out.write("\n")
		i = i + 1

out.close()
