source activate lumpy

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46/*.sam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample ".sam")

samtools view -S -b ${dir}/${base}.sam > ${dir}/${base}.bam 

done
