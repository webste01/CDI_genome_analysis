/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/plotting_scripts/metaphlan_hclust_heatmap.py -c bbcry --top 25 --minv 0.1 -s log --tax_lev s --in merged_res.txt --out stringent_out

#images for all samples
mkdir -p tmp
 for file in profiled_samples/*
 do
     filename=`basename ${file}`
     samplename=${filename%\.*}
     /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/plotting_scripts/metaphlan2graphlan.py  ${file}  --tree_file tmp/${samplename}.tree.txt --annot_file tmp/${samplename}.annot.txt
     /sc/orga/work/webste01/gitrepos/graphlan/graphlan_annotate.py --annot tmp/${samplename}.annot.txt tmp/${samplename}.tree.txt tmp/${samplename}.xml
     /sc/orga/work/webste01/gitrepos/graphlan/graphlan.py --dpi 200 tmp/${samplename}.xml output_images/${samplename}.png
 done


#abubdance across merged table
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/plotting_scripts/metaphlan2graphlan.py merged_res.txt  --tree_file tmp/merged.tree.txt --annot_file tmp/merged.annot.txt
/sc/orga/work/webste01/gitrepos/graphlan/graphlan_annotate.py --annot tmp/merged.annot.txt tmp/merged.tree.txt tmp/merged.xml
/sc/orga/work/webste01/gitrepos/graphlan/graphlan.py --dpi 200 tmp/merged.xml output_images/merged.png
