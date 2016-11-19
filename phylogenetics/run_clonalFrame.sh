TREE=$1
FA=$2
NAME=$3
/sc/orga/work/webste01/gitrepos/ClonalFrameML/src/ClonalFrameML $2 $1 $3

Rscript /sc/orga/work/webste01/gitrepos/ClonalFrameML/src/cfml_results.R $3

