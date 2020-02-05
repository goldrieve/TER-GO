source activate main_env

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*_1.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq"
base=$(basename $sample "_1.fastq.gz")

bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/SIF_pathway/HYP/HYP_REGION.fasta ${dir}/${base}_1.fastq.gz ${dir}/${base}_2.fastq.gz | samtools view -hbS - | samtools sort -m 1000000000 > /Users/s1886853/TERGO/SIF_pathway/HYP/Alignments/${base}_sorted.bam

done
