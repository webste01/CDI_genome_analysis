#!/bin/bash

FILES=../../fasta_files/*
for file in $FILES

do
echo $file
f1=$(basename $file)
echo $f1

f=${f1%.*}

REPO_DIR=/sc/orga/work/webste01/gitrepos/pathogendb-pipeline
ALIEN_DIR=$REPO_DIR/vendor/alien_hunter-1.7
PHAGE_DB=/sc/orga/projects/InfectiousDisease/db/prophage_virus.db
OUT=/sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/test_run/$f

echo "
#!/bin/bash
#BSUB -J alien_hunter_$f
#BSUB -P acc_PacbioGenomes
#BSUB -q private
#BSUB -n 12
#BSUB -W 24:00
#BSUB -m bashia02
#BSUB -o /sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/test_run/$f/$f.stdout
#BSUB -eo /sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/test_run/$f/$f.stderr
#BSUB -L /bin/bash

module purge
module load mummer
module load blast
module load python/2.7.6
module load py_packages/2.7
mkdir -p $OUT 

python $REPO_DIR/scripts/get_repeats_phage_pai.py -a $ALIEN_DIR/alien_hunter -d $PHAGE_DB -o $OUT/$f.rpi -f /sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/mlst1_analysis/mlst1_fasta/$f1  --islands --phage" > /sc/orga/projects/InfectiousDisease/studies/CDiff_first_paper/roary/test_run/$f.sh
bsub < $f.sh
done 

