from Bio import SeqIO
import os
import sys

gbk_fofn=sys.argv[1]
outname=sys.argv[2]

def annot_info (gb_fofn, name):
    out_fn=str(name)
    with open(out_fn,'w') as out:
        with open(gb_fofn) as gb:
            for l in gb:
                l = l.strip().split()
                print l[0]
                for rec in SeqIO.parse(l[0], "genbank"):
                    if rec.features:
                        for feature in rec.features:
                            if "gene" in feature.qualifiers:
				    g=feature.qualifiers["gene"][0]
				    print g
			            p=feature.qualifiers["product"][0]
				    print p
                                    out.write("%s,%s,%s," %(l[0],g,p))
                                    seq = feature.qualifiers["translation"][0]
                                    out.write(seq)
                                    out.write("\n")
			    elif "product" in feature.qualifiers and "translation" in feature.qualifiers:
				    prod=feature.qualifiers["product"][0]
				    print prod
				    h="hypothetical protein"
				    out.write("%s,%s,%s," %(l[0],h,h))
				    seq = feature.qualifiers["translation"][0]
                                    out.write(seq)
                                    out.write("\n")			

annot_info (gbk_fofn, outname)

