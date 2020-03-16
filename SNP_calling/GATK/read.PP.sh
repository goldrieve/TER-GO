source activate main_env

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*_1.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq"
base=$(basename $sample "_1.fastq.gz")

#bwa mem -M -t 16 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}_1.fastq.gz ${dir}/${base}_2.fastq.gz | samtools view -hbS - > ~/TERGO/Monomorph/Tcomp/GATK/${base}.bam

done

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*_1.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq"
base=$(basename $sample "_1.fastq.gz")

ulimit -c unlimited

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk FastqToSam \
        -F1 ${dir}/${base}_1.fastq.gz \
        -F2 ${dir}/${base}_2.fastq.gz \
        -O /Users/s1886853/TERGO/Monomorph/Tcomp/GATK/${base}.umap.bam \
        -SM ${base} \
	-RG ${base}
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/GATK/*.umap.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/Tcomp/GATK"
base=$(basename $sample ".umap.bam")

ulimit -c unlimited

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeBamAlignment \
        -ALIGNED ${dir}/${base}.bam \
        -UNMAPPED ${dir}/${base}.umap.bam \
        -O ${dir}/${base}_merge.bam \
        -R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/GATK/*_merge.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/Tcomp/GATK"
base=$(basename $sample "_merge.bam")

#samtools sort ${dir}/${base}_merge.bam -m 1000000000 -@ 14 -o ${dir}/${base}_qname.bam 

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/GATK/*_qname.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/Tcomp/GATK"
base=$(basename $sample "_qname.bam")

ulimit -c unlimited

picard MarkDuplicates \
        I=${dir}/${base}_qname.bam \
        O=${dir}/${base}.marked.bam \
        M=${dir}/${base}.marked_dup_metrics.txt \
	ASSUME_SORT_ORDER=coordinate
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/GATK/*.marked.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/Tcomp/GATK"
base=$(basename $sample ".marked.bam")

picard AddOrReplaceReadGroups \
       I=${dir}/${base}.marked.bam \
       O=${dir}/${base}.rg.marked.bam \
       RGID=${base} \
       RGLB=${base} \
       RGPL=ILLUMINA \
       RGPU=${base} \
       RGSM=${base}
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/GATK/*.rg.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/Tcomp/GATK"
base=$(basename $sample ".rg.marked.bam")

ulimit -c unlimited

picard BuildBamIndex I=${dir}/${base}.rg.marked.bam

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/Tcomp/GATK/*.rg.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/Tcomp/GATK"
base=$(basename $sample ".rg.marked.bam")

ulimit -c unlimited

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk BaseRecalibrator \
   -I ${dir}/${base}.rg.marked.bam \
   -R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
   --known-sites /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/confident.sites.vcf \
   -O ${dir}/${base}.recal.table

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.rg.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".rg.marked.bam")

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk ApplyBQSR \
   -R /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta \
   -I ${dir}/${base}.rg.marked.bam \
   --bqsr-recal-file ${dir}/${base}.recal.table \
   -O ${dir}/${base}.recal.bam

done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.recal.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".recal.bam")

ulimit -c unlimited

#picard BuildBamIndex I=${dir}/${base}.recal.bam

done
