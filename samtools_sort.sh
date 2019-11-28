source activate lumpy

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V4/bwa/bam/*.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V4/bwa/bam"
base=$(basename $sample ".bam")

samtools sort ${dir}/${base}.bam > ${dir}/${base}.sorted.bam

done
