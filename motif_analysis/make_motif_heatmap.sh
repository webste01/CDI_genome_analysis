FOFN=$1
PKEEP=$2
OUT=$3
python make_motif_matrix.py ${FOFN} ${PKEEP} ${OUT}

sed 's:[['',]::g' ${OUT}_motif_matrix.csv  > tmp
sed 's:[]]::g' tmp > tmp2
mv tmp2 ${OUT}_motif_matrix.csv
rm tmp

Rscript make_heatmap.R ${OUT}
