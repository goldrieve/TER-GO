for sample in `ls ./MW003a.bam`
do
dir="."
base=$(basename $sample "MW003a.bam")

samtools bam2fq ${base} > ${base}.fq

done
