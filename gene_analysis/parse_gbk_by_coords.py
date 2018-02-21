from Bio import SeqIO
import os
import sys

gb_file = sys.argv[1]
coor1=int(sys.argv[2])
coor2=int(sys.argv[3])
window = int(sys.argv[4])
out=sys.argv[5]

print coor1
print coor2

with open(out,'w') as out_file:
	for rec in SeqIO.parse(gb_file, "genbank"):
		print gb_file
    		if rec.features:
        		for feature in rec.features:
	   			start=feature.location.nofuzzy_start
            			end=feature.location.nofuzzy_end
				if end < coor2+window and start > coor1-window:
					out_file.write("%s,%s," %(start,end))
					if "gene" in feature.qualifiers:
						print feature.qualifiers["gene"]
						out_file.write("%s," %(feature.qualifiers["gene"]))
					else:
						print feature.qualifiers["locus_tag"]
						out_file.write(",")
					if "product" in feature.qualifiers:
						print feature.qualifiers["product"]
						out_file.write("%s," %(feature.qualifiers["product"]))
					else:
                                                out_file.write(",")
					if "translation" in feature.qualifiers:
						print feature.qualifiers["translation"]
						out_file.write("%s," %(feature.qualifiers["translation"]))
					else:
                                                out_file.write(",")
					out_file.write("\n")

out_file.close()

