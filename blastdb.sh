for sample in `ls ./*.fasta`
do
dir="."
base=$(basename $sample ".fasta")

makeblastdb -in ${base}.fasta -dbtype nucl -title ${base}_db -out ${base}_db_seq 

done
