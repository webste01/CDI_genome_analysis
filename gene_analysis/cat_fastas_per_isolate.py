from Bio import SeqIO
import glob, os


#Script to get all fastas in firectory from one isolate, cat together fastas based on number in header
def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""


iso_dict = {} #Dictionary keyed on assembly id, contains all fasta files containing string
ids = set() #Set of all assembly ids

#Get all fastas in directory
for file in glob.glob("*.fasta"):
    	iso_id = file.split("_")[2]
	ids.add(iso_id)

#Create dictionary of isolate ids to files with their id in the file name
for id in ids:
	iso_dict[id] = []
	for file in glob.glob("*%s*" %(id)):
		iso_dict[id].append(file)

for id in iso_dict:
	out_file = open("hsd_locus_%s.fasta" %(id),"w")
	out_file.write(">hsd_locus_%s" % (id))
	out_file.write("\n")
	fastas = iso_dict[id]
	cds_order = {}  #dictionary of fastas to starting coord
	for fn in fastas:
		print fn
		first_record = SeqIO.parse("%s" %(fn), "fasta").next()
		start = find_between(first_record.id, ":" ,"-")
		print start
		cds_order[start] = first_record.seq
	for w in sorted(cds_order):
		out_file.write("%s" %(cds_order[w]))
		out_file.write("\n")
		


