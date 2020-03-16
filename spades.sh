source activate main_env

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*_1.fastq.gz`
do
dir="/Users/s1886853/ncbi/public/sra/Fastq"
base=$(basename $sample "_1.fastq.gz")

spades.py -1 ${dir}/${base}_1.fastq.gz -2 ${dir}/${base}_2.fastq.gz -k 21,33,55,77,99 -o /Users/s1886853/ncbi/public/sra/Assemblies/${base} -t 16

done
