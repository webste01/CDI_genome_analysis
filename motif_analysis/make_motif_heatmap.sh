FOFN=$1
PKEEP=$2
OUT=$3
MIN=$4
python make_motif_matrix.py ${FOFN} ${PKEEP} ${OUT} ${MIN}


Rscript make_heatmap.R ${OUT}
