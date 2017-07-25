#Retrieves fastq files from SRA given a list of the SRR IDs 
while read name;
do
echo "#!/bin/bash
#BSUB -J getfastq_$name
#BSUB -P acc_PacbioGenomes
#BSUB -q private
#BSUB -n 12
#BSUB -W 24:00
#BSUB -m bashia02
#BSUB -o /sc/orga/scratch/webste01/reference_SRA/scripts/$name.stdout
#BSUB -eo /sc/orga/scratch/webste01/reference_SRA/scripts/$name.stderr
#BSUB -L /bin/bash

cd /sc/orga/scratch/webste01/reference_SRA/scripts
module purge
module load sratoolkit/2.8.0

NAME_FIRST_3 = ${name:0:3}
NAME_FIRST_6 = ${name:0:6}
wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/SRR/${NAME_FIRST_6}/${name}/${name}.sra


module purge
module load spades

spades.py --pe1-1 ${name}_1.fastq --pe1-2 ${name}_2.fastq -o $name



module purge
module load python py_packages
python /sc/orga/work/webste01/gitrepos/pathogendb-pipeline/scripts/fetch_mlst.py --fasta $name/contigs.fasta  --output $name.mlst --mlst cdifficile

if [ -e ${name}.mlst ]
then
  STRAIN_TYPE = 'tail -n2 ${name}.mlst | head -1'
  if [[ $STRAIN_TYPE != *"1"* ]]; then
   rm ${name}_1.fastq
   rm ${name}_2.fastq
   rm -rf ${name}
  fi
else
 fi

" > $name.check_mlst.sh



bsub <  $name.check_mlst.sh

done < test_accession_list.txt



