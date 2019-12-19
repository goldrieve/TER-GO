source activate main_env

for sample in `ls /Users/s1886853/TERGO/Leish/Fastq/*.fq`
do
dir="/Users/s1886853/TERGO/Leish/Fastq"
base=$(basename $sample ".fq")

repair.sh in=${dir}/${base}.fq out=${dir}/${base}.fixed.fq outsingle=${dir}/${base}.singletons.fq

done
