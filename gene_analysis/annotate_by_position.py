#Script to take in a *cim file and annotate each row with: 0/1 hits gene, gene it hits, uniprot term 
from Bio import SeqIO
import os
import sys

gbk_dir=str(sys.argv[1])
cim_file=sys.argv[2] #merged_chromosomal.ali.csv
outname=sys.argv[3]

d={}
with open(cim_file, 'r+') as cim:
	    line = next(cim)	
            for line in cim:
               	l = line.strip().split(",")
		isolate_id, pos, ipd, motif, pres =  l[1],l[2],l[3],l[4],l[5]
		if pres == '1':
			if (isolate_id,motif) not in d:
				d[(isolate_id,motif)] = []
               			d[(isolate_id,motif)].append(pos) 
			else:
				d[(isolate_id,motif)].append(pos)
cim.close()
#print d[('23621','GATC')]


#open the corresponding genbank (gb_fn), retrieve annotaion corresponding to where the position  
#funtion will write to a file: contig ID, position, motif, in_gene(0/1), gene name (if hits gene, else 0), uniprotID(if hits gene, else 0)
print gbk_dir
with open(outname,'w') as out:
	for item in d:
		for fname in os.listdir(gbk_dir):    # change directory as needed
			isolate_id = item[0] 
			motif = item[1] 
			if isolate_id in fname:
				for rec in SeqIO.parse(gbk_dir+fname, "genbank"):
					if rec.features:
                        			for feature in rec.features:
			    				start=int(feature.location.nofuzzy_start)
            		    				end=int(feature.location.nofuzzy_end)
			    				for pos in d[item]:
								pos=int(pos)
								out.write("%s,%s," %(isolate_id,motif))
			    					if end >= pos and start <= pos: #check to see if position hits gene
									print "in gene"
									out.write("%s," "1," %(pos)) #Write 1 if it does
									if "gene" in feature.qualifiers:
                                    						g=feature.qualifiers["gene"][0]
										print g
										out.write("%s" %(g))
										out.write("\n")
									else:
										out.write("none_listed")
										out.write("\n")
								else:
									out.write("%s," "0,0" %(pos)) #Write 0 if it doesnt
									out.write("\n")

