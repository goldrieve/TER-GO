for sample in `ls /Users/s1886853/TERGO/NEK_assemblies/927_aln/*sam`
do
dir="/Users/s1886853/TERGO/NEK_assemblies/927_aln/"
base=$(basename $sample ".sam")

samtools sort ${dir}/${base}.sam > /Users/s1886853/TERGO/NEK_assemblies/927_aln/${base}_sorted.bam

done
