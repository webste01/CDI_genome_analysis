import os
import sys
from Bio import SeqIO
from Bio.Seq import Seq
#Script to get 200bp flanking region of each tandem repeat, and step through each repeat for the closest kmer
#Also extract the sequence between the kmers (to later be compared for similarity) 
in_fa          = sys.argv[1]
print in_fa
in_trf         = sys.argv[2]
print in_trf
#in_jf          = sys.argv[3]
#flanking_bp    = sys.argv[4]

#in_fa          = 'trf_output/u00006crpx_c_025511.fa'
#in_trf         = 'trf_output/u00006crpx_c_025511_out'
in_jf          = 'high_freq_kmers.txt'
flanking_bp    = int(200)



full_fasta_seq = SeqIO.parse(open(in_fa),'fasta')

#List of high frequency kmers
kmers=[]

#idictionary of Tuple that is keyed upon [leftmer,rightmer,tandem repeat] with the corresponding isolate name as the value
d={}

isolate = str(in_fa).split('/')[1].split('.')[0]

with open(in_jf) as jellyfish:
	for l in jellyfish:
		l = l.strip().split()
		kmers.append(l[0].lower())

def get_seq_btw_2coords(start_coord,end_coord):
#'''Given a fasta sequence, returns the sequence between indices start_coord,end_coord'''
	full_fasta_seq = SeqIO.parse(open(in_fa),'fasta')
	for fasta in full_fasta_seq:
		fa_string = str(fasta.seq)
		subset_fa =fa_string[int(start_coord):int(end_coord)]
		return subset_fa


def get_flanking(start_coord,end_coord,flanking_bp):
#'''Given the start and end coordinates of region, find the flanking region with length  X base pairs upstream and downstream'''
	start_flank              = start_coord - flanking_bp
	end_flank                = end_coord + flanking_bp
	upstream_flank_seq       = get_seq_btw_2coords(start_flank,start_coord)
	downstream_flank_seq     = get_seq_btw_2coords(end_coord,end_flank)
	return downstream_flank_seq,upstream_flank_seq

def find_kmer_in_seq(repeat,upstream_flank_seq,downstream_flank_seq,isolate):
#'''given a sequence (reference) and the kmers from the list of all high frequency kmers, find if the sequence contains the kmer and get the coordinates of the kmer within that sequence'''
	for mer in kmers:
		rc = Seq(str(mer))
		rc_mer = rc.reverse_complement()
		leftmer  = downstream_flank.find(str(rc_mer))
                rightmer = upstream_flank.find(mer)
		if (leftmer>0) and (rightmer>0):
			d[mer,mer,repeat]=isolate
		elif (leftmer>0) and (rightmer<0):
			d[mer,rightmer,repeat]=isolate
		elif (leftmer<0) and (rightmer>0):
			d[leftmer,mer,repeat]=isolate
	return


with open(in_trf,'r') as trf:
        next(trf)
        for l in trf:
		if not l.lstrip().startswith('@'):
                	l=l.strip().split()
                	start = int(l[0])
                	end = int(l[1])
                	repeat = str(l[13])
                	flanks = get_flanking(start,end,flanking_bp)
                	downstream_flank = flanks[0]
                	upstream_flank   = flanks[1]
                	find_kmer_in_seq(repeat,upstream_flank,downstream_flank,isolate)
        t=d.items()
        print t

