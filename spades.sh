source activate main_env

for sample in `ls /Users/s1886853/TERGO/Leish/Fastq/*.fixed.fq`
do
dir="/Users/s1886853/TERGO/Leish/Fastq"
base=$(basename $sample "*.fixed.fq")

spades.py --12 ${dir}/${base} -k 21,33,55,77,99 -o /Users/s1886853/TERGO/Leish/Assemblies/${base} -t 14

done
