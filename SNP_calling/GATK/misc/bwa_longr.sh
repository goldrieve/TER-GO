source activate main_env

for sample in `ls /Volumes/LaCie/ncbi/public/sra/solid/*.fa.gz`

do

dir="/Volumes/LaCie/ncbi/public/sra/solid"
base=$(basename $sample ".fa.gz")

bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}.fa.gz | samtools view -hbS - > ~/GATK/Tcomp_GATK/DAL972/${base}.bam

done

for sample in `ls /Volumes/LaCie/ncbi/public/sra/solid/*.fa.gz`

do

dir="/Volumes/LaCie/ncbi/public/sra/solid"
base=$(basename $sample ".fa.gz")

picard FastqToSam \
        F1=${dir}/${base}.fastq.gz \
        O=~/Users/s1886853/GATK/Tcomp_GATK/DAL972/${base}.umap.bam \
        SM=${base} \
	RG=${base}
done

for sample in `ls ~/Users/s1886853/GATK/Tcomp_GATK/DAL972/*.umap.bam`

do

dir="~/Users/s1886853/GATK/Tcomp_GATK/DAL972"
base=$(basename $sample ".umap.bam")

picard MergeBamAlignment \
        ALIGNED=${dir}/${base}.bam \
        UNMAPPED=${dir}/${base}.umap.bam \
        O=${dir}/${base}_merge.bam \
        R=/Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta
done

for sample in `ls ~/Users/s1886853/GATK/Tcomp_GATK/DAL972/*_merge.bam`

do

dir="~/Users/s1886853/GATK/Tcomp_GATK/DAL972"
base=$(basename $sample "_merge.bam")

gatk MarkDuplicatesSpark \
	-I ${dir}/${base}_merge.bam  \
	-O ~/Users/s1886853/GATK/Tcomp_GATK/DAL972/${base}.marked_duplicates.bam \
	--remove-sequencing-duplicates \
	--duplicate-tagging-policy OpticalOnly

done
