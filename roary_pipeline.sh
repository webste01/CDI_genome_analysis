module load gmp/5.1.3
module load zlib/1.2.8
module load mcl/14_137
module load ncbi_tools/20120620
module load lsf/9.1
module load R/3.0.3
module load mpfr/3.1.2
module load bedtools/2.21.0
module load parallel/20130622
module load intel/parallel_studio_xe_2015
module load torque/4.1.5-test
module load mafft/7.245
module load mpc/1.0.2
module load cd-hit/4.6.1
module load gsl/1.16                       
module load geos/3.5.0                     
module load openmpi/1.6.5                  
module load fasttree/2.1.3
module load gcc/4.8.2                       
module load blast/2.2.30+
module load CPAN/5.10.1           
module load netcdf/4.3.3.1                 
module load jags/4.0.0
export PATH=$PATH:/sc/orga/scratch/webste01/roary/build/prank-msa-master/src/prank
export PATH=$PATH:/sc/orga/scratch/webste01/roary/build/mcl-14-137/src/shmcl
export PATH=$PATH:/sc/orga/scratch/webste01/roary/build/mcl-14-137/src/alien/oxygen/src
    
roary -f /sc/orga/work/webste01/gitrepos/CDI_gene_analysis/results -e -n -v /sc/orga/work/webste01/final_gff/*.gff
FastTree -nt -gtr core_gene_alignment.aln > my_tree.newick


#Make heatmap of presence/absesce (requires):
#python (2 or 3)
module load py_packages
python /sc/orga/work/webste01/gitrepos/Roary/contrib/roary_plots/roary_plots.py /sc/orga/work/webste01/gitrepos/CDI_gene_analysis/results_1468523985/my_tree.newick /sc/orga/work/webste01/gitrepos/CDI_gene_analysis/results_1468523985/gene_presence_absence.csv 

module purge 
module load CPAN
perl /sc/orga/work/webste01/gitrepos/Roary/contrib/roary2svg/roary2svg.pl /sc/orga/work/webste01/gitrepos/CDI_gene_analysis/results_1468523985/gene_presence_absence.csv > /sc/orga/work/webste01/gitrepos/CDI_gene_analysis/results_1468523985/pangenome.svg

module purge 
module load R
cd /sc/orga/work/webste01/gitrepos/CDI_gene_analysis/results_1468523985
Rscript /sc/orga/work/webste01/gitrepos/Roary/bin/create_pan_genome_plots.R 





