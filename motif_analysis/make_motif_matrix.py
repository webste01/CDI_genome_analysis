#Read in a fofn of motif_summary.csv files from output of smrtanalysis
#Output matrix of  mrn as rows, motifs as columns
import os 
import sys
import numpy as np
import re
import argparse
import csv

motif_fofn=sys.argv[1]
p_keep=float(sys.argv[2])
out_name=str(sys.argv[3])
min_genome_presence = int(sys.argv[4])
motifs=open(out_name + ".csv","w")

tmpset=set()
from collections import Counter
motifCounter = Counter()
genomeMotifs = {} # dictionary of genome ids with their list of motifs

rcDict = dict(zip('ACGTWSMKRYBDHVNacgtwsmkrybdhvn-"','TGCAWSKMYRVHDBNtgcawskmyrvhdbn-"'))
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
                        genome_id = f2.split('/')[2] # name of geneme
			motifs.write(genome_id)
                        genomeMotifs[genome_id] = set()
                        
			motifs.write(",")
			for row in motif_reader:
                           motif = row[0]
                           rcmotif = revcomp(motif)
                           p_methylated = float(row[3])
                           if p_methylated > p_keep:
                              if motif in genomeMotifs[genome_id] or rcmotif in genomeMotifs[genome_id]:
                                 # we don't want to add it in twice!
                                 pass
                              elif rcmotif not in tmpset:
                                 tmpset.add(motif)
                                 motifs.write(motif)
                                 motifs.write(",")
                                 motifCounter[motif] += 1
                                 genomeMotifs[genome_id].add(motif)
                              else:
                                 motifs.write(rcmotif)
                                 motifCounter[rcmotif] += 1
                                 genomeMotifs[genome_id].add(motif)
                                 motifs.write(",")
			motifs.write('\n')
motifs.close()		
motif_matrix=open(out_name + "_motif_matrix.csv","w")

# determine how many genomes are in our table
n = 0
motset_list = []
for motif, count in motifCounter.items():
   if count >= min_genome_presence:
      n += 1
      motset_list.append(motif)
      

motif_matrix.write("%s %s\n" % ("id,",", ".join(motset_list)))

for genome in genomeMotifs:
	binary = [0] * n
        i = 0
        for motif in motset_list:
           if motif in genomeMotifs[genome]:
              binary[i] = 1
           i += 1
           binary_str = ", ".join(map(str, binary))
	motif_matrix.write("%s, %s\n" % (genome,binary_str))

for motif in motset_list:
   print >>sys.stderr, motif, motifCounter[motif]
