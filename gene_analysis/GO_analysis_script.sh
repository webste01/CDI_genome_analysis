#Run Harm'n NGS-tools GO analysis script
PREFIX=$1
LIST=$2
export GIT_REPODIR=/sc/orga/work/webste01/gitrepos
echo $GIT_REPODIR
sh build-bacterial-reference-genomedir gff=$1.gff fna=$1.fna faa=$1.faa 

module purge
unset MODULEPATH
source /etc/profile.d/modules.sh
module load openssl
module load R/3.3.1
export R_LIBS="/hpc/users/vanbah01/opt/Rlib-ngs-pipelines:$R_LIBS"
export HTTP_PROXY="http://proxy.mgmt.hpc.mssm.edu:8123"

Rscript run-go-enrich.R -i $2 -a $1.anno -o $1.topGO -n symbol 
