ls *.sra| tr '.' '\t' | cut -f1 | while read name;
do
echo "#!/bin/bash
#BSUB -J process_$name
#BSUB -P acc_PacbioGenomes
#BSUB -q private
#BSUB -n 12
#BSUB -W 24:00
#BSUB -m bashia02
#BSUB -o /sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/reference_SRA_runs/g$name.stdout
#BSUB -eo /sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/reference_SRA_runs/g$name.stderr
#BSUB -L /bin/bash

cd /sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/reference_SRA_runs
module load sratoolkit/2.4.2-1
fastq-dump --split-files ${name}.sra 

module purge 
module load spades
spades.py --pe1-1 ${name}_1.fastq --pe1-2 ${name}_2.fastq -o $name

#Rename contigs
module purge
module load python py_packages
python /sc/orga/work/webste01/gitrepos/CDI_genome_analysis/gene_analysis/rename_contigs.py ${name}/contigs.fasta ${name}.fasta" > $name.process.sh

bsub < $name.process.sh

done

