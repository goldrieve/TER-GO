source activate main_env

for sample in `ls /Users/s1886853/TERGO/NEK_assemblies/927_aln/927_V4/bwa/*bam`
do
dir="/Users/s1886853/TERGO/NEK_assemblies/927_aln/927_V4/bwa"
base=$(basename $sample ".bam")

samtools sort --threads 14 ${dir}/${base}.bam > ${dir}/${base}_sorted.bam

done
