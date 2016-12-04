#Read in a fofn of motif_summary.csv files from output of smrtanalysis
#Output matrix of  mrn as rows, motifs as columns
import os 
import sys
import numpy as np
import re
import argparse
import csv

motif_fofn=sys.argv[1]
p_keep=sys.argv[2]
out_name=str(sys.argv[3])
motifs=open(out_name + ".csv","w")

tmpset=set()
rcDict = dict(zip('ACGTWSMKRYBDHVNacgtwsmkrybdhvn-','TGCAWSKMYRVHDBNtgcawskmyrvhdbn-'))
def revcomp(seq):
   """Return the reverse complement of a string:

   :param seq: DNA Sequence to be reverse complemented
   :type seq: str
   :returns: A new string that is the reverse complement of seq
   :rtype: string

   """
   return ''.join([rcDict[nuc] for nuc in  seq[::-1]])


#For each file in motif fofn
with open (motif_fofn) as m:
	for line in m:
		f1=line.strip().split()
		f2=str(f1[0])
		with open (f2,'rb') as f:
			motif_reader= csv.reader(f,skipinitialspace=True)
			next(motif_reader)
			motifs.write(f2.split('/')[2])
			motifs.write(",")
			tmpset=set()
			for row in motif_reader:
				if row[3]> p_keep:
					if revcomp(row[0]) not in tmpset:
						tmpset.add(row[0])
						motifs.write(row[0])
						motifs.write(",")
			motifs.write('\n')
motifs.close()		
id_mots = {}
all_mots = []
motset = set()
motifs=open(out_name + ".csv","r")
for l in motifs:
	ll = l.strip().split(',')
	id = ll[0]
	mot = ll[1:]
	for motif in mot:
		all_mots.append(motif)	
		motset.add(motif)
	id_mots.setdefault(id,[]).append(mot)

motset_list = list(motset)
motif_matrix=open(out_name + "_motif_matrix.csv","w")
motif_matrix.write("%s %s\n" % ("id,",motset_list))
for id in id_mots:
	binary = [0] * len(motset)
	motif = id_mots[id]
	motif1=motif[0]
	for pos in range(len(motif1)):
		index_of_motif = motset_list.index(motif1[pos])
		binary[index_of_motif]=1
	motif_matrix.write("%s, %s\n" % (id,binary))
