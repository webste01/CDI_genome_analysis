#export PYTHONPATH=$PYTHONPATH:/sc/orga/work/webste01/gitrepos/gffutils/
#Format the phage data from alien hunter to be read into R
import gffutils
import sys
import os

os.chdir("/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/mlst1_analysis/scripts")
#in_file="../mlst1_gff/u00000crpm_c_020265.gff"
clustered_proteins="../roary_mafft_results/_1493052300/clustered_proteins"
#phage_file="../roary_mafft_results/_1493052300/u00000crpm_c_020265.rpi.phage.out"

in_file=sys.argv[1]
phage_file=sys.argv[2]


db = gffutils.create_db(in_file, dbfn='test.db', force=True, keep_order=True, sort_attribute_values=True)
#Given coordinates and database, return prokka id of feature between those coordinates
def retreive_prokka_ids (coord_start,coord_end,db):      
        for feat in db.features_of_type('CDS', order_by='start'):
                if feat.end < int(coord_end)+100 and feat.start > int(coord_start)-100:
                        return feat.id,feat.start, feat.end


with open(phage_file,'r') as pf:
	for l in pf:
		l = l.strip().split()
		full_phageid = l[1]
		org_name=l[1]
		org_name1=org_name.split('_')[1]
		coords = [l[6],l[7]]
		phage_start = min(coords)
		phage_end = max(coords) 
		test = retreive_prokka_ids(phage_start,phage_end,db)
		if test:
			prokka_id, startcoord, endcoord = test[0],test[1],test[2]
			print prokka_id, startcoord, endcoord, org_name1, phage_start, phage_end
		

