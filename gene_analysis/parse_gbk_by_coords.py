from Bio import SeqIO
import os
import sys

gb_file = sys.argv[1]
coor1=int(sys.argv[2])
coor2=int(sys.argv[3])
out=sys.argv[4]

print coor1
print coor2

with open(out,'w') as out_file:
	for rec in SeqIO.parse(gb_file, "genbank"):
		print gb_file
		print rec
    		if rec.features:
        		for feature in rec.features:
	   			start=feature.location.nofuzzy_start
            			end=feature.location.nofuzzy_end
				if end < coor2+5000 and start > coor1-5000:
					out_file.write("%s,%s," %(start,end))
					if "gene" in feature.qualifiers:
						out_file.write("%s," %(feature.qualifiers["gene"]))
					else:
						out_file.write(",")
					if "product" in feature.qualifiers:
						out_file.write("%s," %(feature.qualifiers["product"]))
					else:
                                                out_file.write(",")
					if "translation" in feature.qualifiers:
						out_file.write("%s," %(feature.qualifiers["translation"]))
					else:
                                                out_file.write(",")
					out_file.write("\n")

out_file.close()

