source activate samtools

for sample in `ls /Users/s1886853/TERGO/Raw_data/NEK/DNA/*_1.fq.gz`

do

dir="/Users/s1886853/TERGO/Raw_data/NEK/DNA"
base=$(basename $sample "_1.fq.gz")

bwa mem -M -t 14 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz | samtools view -hbS - > /Users/s1886853/GATK/Clone/${base}.bam

done

for sample in `ls /Users/s1886853/TERGO/Raw_data/NEK/DNA/*_1.fq.gz`

do

dir="/Users/s1886853/TERGO/Raw_data/NEK/DNA"
base=$(basename $sample "_1.fq.gz")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk FastqToSam \
        F1=${dir}/${base}_1.fq.gz \
        F2=${dir}/${base}_2.fq.gz \
        O=/Users/s1886853/GATK/Clone/${base}.umap.bam \
        SM=${base} \
	RG=${base}
done

for sample in `ls /Users/s1886853/GATK/Clone/*.umap.bam`

do

dir="/Users/s1886853/GATK/Clone"
base=$(basename $sample ".umap.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeBamAlignment \
        ALIGNED=${dir}/${base}.bam \
        UNMAPPED=${dir}/${base}.umap.bam \
        O=${dir}/${base}_merge.bam \
        R=/Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta
done

for sample in `ls /Users/s1886853/GATK/Clone/*_merge.bam`

do

dir="/Users/s1886853/GATK/Clone"
base=$(basename $sample "_merge.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MarkDuplicatesSpark \
	-I ${dir}/${base}_merge.bam  \
	-O ${dir}/${base}.marked_duplicates.bam \
	--remove-sequencing-duplicates

done

