#!/bin/bash
#BSUB -J metaphlan
#BSUB -P acc_PacbioGenomes
#BSUB -q private
#BSUB -n 25
#BSUB -W 144:00
#BSUB -m bashia02
#BSUB -o /sc/orga/scratch/webste01/metaphlan/XT_compare_ultraII.stdout
#BSUB -eo /sc/orga/scratch/webste01/metaphlan/XT_compare_ultraII.stderr
#BSUB -L /bin/bash

module load blast 
module load python
module load py_packages
module load bowtie2 

cd /sc/orga/scratch/webste01/metaphlan

/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/U2_CD01190_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt1 > U2_CD01190_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/U2_CD01465_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt2 > U2_CD01465_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/U2_CD01500_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt3 > U2_CD01500_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/U2_RC00189_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt4 > U2_RC00189_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/U2_RC00462_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt5 > U2_RC00462_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_CD01190_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt6 > XT_CD01190_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_CD01219_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt7 > XT_CD01219_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_CD01345_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt8 > XT_CD01345_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_CD01465_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt9 > XT_CD01465_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_CD01500_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out.txt10 > XT_CD01500_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_RC00189_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out11.txt > XT_RC00189_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_RC00462_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out12.txt > XT_RC00462_1_res
/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/metaphlan.py /sc/orga/projects/InfectiousDisease/cdiff_metagenomics/compare_ultraII-XT/XT_RC01151_1.fastq --bowtie2db /sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/bowtie2db/mpa --nproc 5 --bt2_ps sensitive-local --bowtie2out metagenome.bt2out13.txt > XT_RC01151_1_res



#/sc/orga/work/webste01/gitrepos/nsegata-metaphlan-2f1b17a1f4e9/utils/merge_metaphlan_tables.py *res > merged_res.txt
