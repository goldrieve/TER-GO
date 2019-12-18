source activate lumpy

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46/*.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample ".bam")

samtools sort ${dir}/${base}.bam > ${dir}/${base}.sorted.bam 

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46/*.sorted.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample ".sorted.bam")

samtools index ${dir}/${base}.sorted.bam

done
