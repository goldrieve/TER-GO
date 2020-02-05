for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*3000_1.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq/"
base=$(basename $sample "3000_1.fastq.gz")

bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/SIF_pathway/SIF.fasta ${dir}/${base}3000_1.fastq.gz /Users/s1886853/TERGO/SIF_pathway/SIF.fasta ${dir}/${base}3000_2.fastq.gz | samtools view -hbS - | samtools sort -m 1000000000 > /Users/s1886853/TERGO/SIF_pathway/Alignments/${base}_sorted.bam

done
