source activate main_env

for sample in `ls /Users/s1886853/TERGO/SIF_pathway/Alignments/New/*_sorted.bam`
do
dir="/Users/s1886853/TERGO/SIF_pathway/Alignments/New"
base=$(basename $sample "_sorted.bam")

picard MarkDuplicates \
	I=${dir}/${base}_sorted.bam \
	O=${dir}/${base}.marked.bam \
	M=${dir}/${base}.marked_dup_metrics.txt \
	ASSUME_SORT_ORDER=coordinate
done

for sample in `ls /Users/s1886853/TERGO/SIF_pathway/Alignments/New/*.marked.bam`
do
dir="/Users/s1886853/TERGO/SIF_pathway/Alignments/New"
base=$(basename $sample ".marked.bam")

picard BuildBamIndex I=${dir}/${base}.marked.bam

done
