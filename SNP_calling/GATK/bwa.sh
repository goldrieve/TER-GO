#for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*_1.fastq.gz`

#do

#dir="/Users/s1886853/ncbi/public/sra/Fastq"
#base=$(basename $sample "_1.fastq.gz")

#bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta ${dir}/${base}_1.fastq.gz ${dir}/${base}_2.fastq.gz | samtools view -hbS - > ~/TERGO/Monomorph/SIF_pathway/GATK/${base}.bam

#done

for sample in `ls /Users/s1886853/ncbi/public/sra/Fastq/*_1.fastq.gz`

do

dir="/Users/s1886853/ncbi/public/sra/Fastq"
base=$(basename $sample "_1.fastq.gz")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk FastqToSam \
        F1=${dir}/${base}_1.fastq.gz \
        F2=${dir}/${base}_2.fastq.gz \
        O=/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/${base}.umap.bam \
        SM=${base} \
	RG=${base}
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.umap.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".umap.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeBamAlignment \
        ALIGNED=${dir}/${base}.bam \
        UNMAPPED=${dir}/${base}.umap.bam \
        O=${dir}/${base}_merge.bam \
        R=/Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta
done

for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*_merge.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample "_merge.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MarkDuplicatesSpark \
	-I ${dir}/${base}_merge.bam  \
	-O ${dir}/${base}.marked_duplicates.bam \
	--remove-sequencing-duplicates

done

