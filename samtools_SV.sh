source activate main_env

for sample in `ls /Users/s1886853/TERGO/NEK_assemblies/927_aln/927_V4/*sam`
do
dir="/Users/s1886853/TERGO/NEK_assemblies/927_aln/927_V4"
base=$(basename $sample ".sam")

samtools sort ${dir}/${base}.sam > ${dir}/${base}_sorted.bam

done
