source activate main_env

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/Single/*.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq/Single"
base=$(basename $sample ".fastq.gz")

bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}.fastq.gz | samtools view -hbS - | samtools sort -m 1000000000 > /Users/s1886853/TERGO/Monomorph/Tcomp/Trypanozoon/${base}_sorted.bam

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/Trypanozoon/*_sorted.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/Tcomp/Trypanozoon"
base=$(basename $sample "_sorted.bam")

picard MarkDuplicates \
        I=${dir}/${base}_sorted.bam \
        O=${dir}/${base}.marked.bam \
        M=${dir}/${base}.marked_dup_metrics.txt \
        ASSUME_SORT_ORDER=coordinate
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/Trypanozoon/*.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/Tcomp/Trypanozoon"
base=$(basename $sample ".marked.bam")

picard BuildBamIndex I=${dir}/${base}.marked.bam

done
