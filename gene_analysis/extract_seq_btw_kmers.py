import os
import sys
import csv
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

isolate = str(in_fa).split('/')[1].split('.')[0]

out_name = str(isolate) + ".csv"


full_fasta_seq = SeqIO.parse(open(in_fa),'fasta')

#List of high frequency kmers
kmers=[]

#idictionary of Tuple that is keyed upon [leftmer,rightmer,tandem repeat] with the corresponding isolate name as the value
d={}


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
	upmer_dist={}
	downmer_dist={}
	for mer in kmers:
		upmer_start  = upstream_flank.find(mer)
		upmer = upmer_start + len(mer)
		if upmer>0:
			upmer_dist[mer]=upmer
                downmer = downstream_flank.find(mer)
		if downmer>0:
			downmer_dist[mer]=downmer
	if upmer_dist:
	        closest_upmer   = max(upmer_dist, key=upmer_dist.get)
	if downmer_dist:
		closest_downmer = max(downmer_dist, key=downmer_dist.get)
       	if 'closest_upmer' in locals():
		if  'closest_downmer' in locals():
			d[closest_upmer,closest_downmer,repeat]=isolate
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



with open(out_name, 'w') as a_file:
    for result in t:
	utr = str(result[0][0])
	dtr = str(result[0][1])
	kmer = result[0][2]
	iso = result[1]
        final = ','.join([utr,dtr,kmer,iso])
        a_file.write(final + '\n')






