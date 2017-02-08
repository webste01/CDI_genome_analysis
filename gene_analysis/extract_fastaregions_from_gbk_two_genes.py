#Takes in a gene name and extracts the coordinates of the gene from the fasta
from Bio import SeqIO
import os
import sys

gbk_fofn=sys.argv[1]
outname=sys.argv[2]
gene1=sys.argv[3]
gene2=sys.argv[4]
fasta_dir = sys.argv[5]

def create_aa_fasta (gb_fofn, name, gene_id1,gene_id2,fasta_dir):
    out_fn=str(name)
    with open(out_fn,'w') as out:
        with open(gb_fofn) as gb:
            for l in gb:
                l = l.strip().split()
                print l[0]
		iso = l[0]
		iso2 = iso.split("/")[3]
		iso3 = iso2.split(".")[0]
		fn= iso3
		my_list = []
                for rec in SeqIO.parse(l[0], "genbank"):
                    if rec.features:
                        for feature in rec.features:
                            if "gene" in feature.qualifiers:
                                if feature.qualifiers["gene"][0] == gene_id1:
				    print gene_id1
				    start1=feature.location.nofuzzy_start
                                    end1=feature.location.nofuzzy_end
				    my_list.append(start1)
				    my_list.append(end1)
				elif feature.qualifiers["gene"][0] == gene_id2:
				    print gene_id2
				    start2 = feature.location.nofuzzy_start
				    end2 = feature.location.nofuzzy_end
	        		    my_list.append(start2)
				    my_list.append(end2)
	        if  my_list:
	        	gene_id = "btw_hsdM_hsdR"
			start = min(my_list)
		        end = max(my_list)
			fn2 = str(outname.split(".")[0])
           		out.write("samtools faidx %s/%s.fasta %s:%s-%s > %s_%s.fasta" %(fasta_dir,fn,fn,start,end,fn2,gene_id))
           		out.write("\n")


#create_aa_fasta ("gbk.fofn", "get_toxB.sh", "toxB")
create_aa_fasta (gbk_fofn, outname, gene1,gene2,fasta_dir)

