source activate main_env

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/Single/*.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq/Single"
base=$(basename $sample ".fastq.gz")

#bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta ${dir}/${base}.fastq.gz | samtools view -hbS - > ~/TERGO/Monomorph/SIF_pathway/GATK/${base}.bam

done

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/Single/*.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq/Single"
base=$(basename $sample ".fastq.gz")

ulimit -c unlimited

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk FastqToSam \
        -F1 ${dir}/${base}.fastq.gz \
        -O /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/${base}.umap.bam \
        -SM ${base} \
	-RG ${base}
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk CleanSam \
	-I ${dir}/${base}.bam \
        -O ${dir}/${base}.clean.bam
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.umap.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".umap.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeBamAlignment \
        -ALIGNED ${dir}/${base}.clean.bam \
        -UNMAPPED ${dir}/${base}.umap.bam \
        -O ${dir}/${base}_merge.bam \
        -R /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*_merge.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample "_merge.bam")

samtools sort ${dir}/${base}_merge.bam -m 1000000000 -@ 14 -o ${dir}/${base}_qname.bam 

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*_qname.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample "_qname.bam")

ulimit -c unlimited

picard MarkDuplicates \
        I=${dir}/${base}_qname.bam \
        O=${dir}/${base}.marked.bam \
        M=${dir}/${base}.marked_dup_metrics.txt \
	ASSUME_SORT_ORDER=coordinate
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".marked.bam")

ulimit -c unlimited

picard BuildBamIndex I=${dir}/${base}.marked.bam

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".marked.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk BaseRecalibrator \
   -I ${dir}/${base}.marked.bam \
   -R /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta \
   --known-sites /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/calls_V1/confident.sites.vcf \
   -O ${dir}/${base}.recal.table

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".marked.bam")

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk ApplyBQSR \
   -R /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta \
   -I ${dir}/${base}.marked.bam \
   --bqsr-recal-file ${dir}/${base}.recal.table \
   -O ${dir}/${base}.recal.bam

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.recal.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".recal.bam")

ulimit -c unlimited

picard BuildBamIndex I=${dir}/${base}.recal.bam

done
