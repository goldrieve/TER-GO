source activate main_env

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/Single/*.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq/Single"
base=$(basename $sample ".fastq.gz")

bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta ${dir}/${base}.fastq.gz | samtools view -hbS - > ~/TERGO/Monomorph/SIF_pathway/GATK/LR/${base}.bam

done

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/Single/*.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq/Single"
base=$(basename $sample ".fastq.gz")

picard FastqToSam \
        F1=${dir}/${base}.fastq.gz \
        O=/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/LR/${base}.umap.bam \
        SM=${base} \
	RG=${base}
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/LR/*.umap.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/LR"
base=$(basename $sample ".umap.bam")

picard MergeBamAlignment \
        ALIGNED=${dir}/${base}.bam \
        UNMAPPED=${dir}/${base}.umap.bam \
        O=${dir}/${base}_merge.bam \
        R=/Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/LR/*_merge.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/LR"
base=$(basename $sample "_merge.bam")

gatk MarkDuplicatesSpark \
	-I ${dir}/${base}_merge.bam  \
	-O /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/${base}.marked_duplicates.bam \
	--remove-sequencing-duplicates \
	--duplicate-tagging-policy OpticalOnly

done
