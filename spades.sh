for sample in `ls /Users/s1886853/TERGO/Leish/Fastq/*fq`
do
dir="/Users/s1886853/TERGO/Leish/Fastq"
base=$(basename $sample ".fq")

spades.py --12 ${dir}/${base}.fq -k 21,33,55,77,99 -o /Users/s1886853/TERGO/Leish/Assembly/${base} -t 14 -m 150

done
