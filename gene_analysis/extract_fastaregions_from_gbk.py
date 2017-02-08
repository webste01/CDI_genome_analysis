#Takes in a gene name and extracts the coordinates of the gene from the fasta
from Bio import SeqIO
import os
import sys

gbk_fofn=sys.argv[1]
outname=sys.argv[2]
gene=sys.argv[3]
fasta_dir = sys.argv[4]

def create_aa_fasta (gb_fofn, name, gene_id,fasta_dir):
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
                for rec in SeqIO.parse(l[0], "genbank"):
                    if rec.features:
                        for feature in rec.features:
                            if "gene" in feature.qualifiers:
                                if feature.qualifiers["gene"][0] == gene_id:
				    start=feature.location.nofuzzy_start
                                    end=feature.location.nofuzzy_end
                                    out.write("samtools faidx %s/%s.fasta %s:%s-%s > %s_%s.fasta" %(fasta_dir,fn,fn,start,end,fn,gene_id))
                                    out.write("\n")
			    elif "product" in feature.qualifiers:
				if gene_id in  feature.qualifiers["product"][0]:
					start=feature.location.nofuzzy_start
                                    	end=feature.location.nofuzzy_end
                                    	out.write("samtools faidx %s/%s.fasta %s:%s-%s >> %s_%s.fasta" %(fasta_dir,fn,fn,start,end,fn,gene_id))
                                    	out.write("\n")


#create_aa_fasta ("gbk.fofn", "get_toxB.sh", "toxB")
create_aa_fasta (gbk_fofn, outname, gene,fasta_dir)

