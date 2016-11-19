from Bio import SeqIO
import os
import sys

gbk_fofn=sys.argv[1]
outname=sys.argv[2]
gene=sys.argv[3]

def create_aa_fasta (gb_fofn, name, gene_id):
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
                                if feature.qualifiers["gene"][0] in gene_id:
                                    out.write(">%s_%s\n" %(l[0], gene_id))
                                    seq = feature.qualifiers['translation'][0]
                                    out.write(seq)
                                    out.write("\n")

#create_aa_fasta ("gbk.fofn", "toxB_catted.fa", "toxB")
create_aa_fasta (gbk_fofn, outname, gene)

