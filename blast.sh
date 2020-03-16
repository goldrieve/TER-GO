source activate main_env 

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*_1.fastq.gz`

do
dir="/Users/s1886853/ncbi/public/sra/Fastq"
base=$(basename $sample "_1.fastq.gz")

blastn -task blastn -query ${dir}/${base}_1.fastq.gz -db /Users/s1886853/TERGO/Monomorph/Rotat/rotat.fasta -evalue 1e-10 -outfmt 6 -out ${dir}/${base}.blastn

done
