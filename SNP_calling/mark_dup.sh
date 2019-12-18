source activate main_env

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46/*_sorted.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample "_sorted.bam")

picard MarkDuplicates \
	I=${dir}/${base}_sorted.bam \
	O=${dir}/${base}.marked.bam \
	M=${dir}/${base}.marked_dup_metrics.txt \
	ASSUME_SORT_ORDER=coordinate
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46/*.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample ".marked.bam")

picard BuildBamIndex I=${dir}/${base}.marked.bam

done
