from Bio import SeqIO
import sys
import os

#Renames all contigs in a fasta file
in_fa = sys.argv[1]
out_fa = sys.argv[2]


with open(out_fa,"w") as out:
	i = 1
	for record in SeqIO.parse(in_fa, "fasta"):
    		print(record.id)
    		new_id = "cont_" + str(i) 
    		print new_id
    		out.write(">" + str(new_id))
    		out.write("\n")
    		out.write("%s" %(record.seq))
		out.write("\n")
		i = i + 1

out.close()
