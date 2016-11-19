module load qiime/1.9.1  
beta_diversity_through_plots.py -i merged_metaphlan-out.biom -m metadata.txt -o /sc/orga/scratch/webste01/metaphlan/qiime_out --nonphylogenetic_diversity

core_diversity_analyses.py --i merged_metaphlan-out.biom --mapping_fp metadata.txt --output_dir /sc/orga/scratch/webste01/metaphlan/qiime_out --sampling_depth 597 --nonphylogenetic_diversity
