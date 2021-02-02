source activate main_env

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*_1.trimmed.fq.gz`

do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample "_1.trimmed.fq.gz")

#bwa mem -M -t 16 /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}_1.trimmed.fq.gz ${dir}/${base}_2.trimmed.fq.gz | samtools view -hbS - > ${dir}/${base}.bam

done

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*_1.trimmed.fq.gz`

do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample "_1.trimmed.fq.gz")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk FastqToSam \
        -F1 ${dir}/${base}_1.trimmed.fq.gz \
        -F2 ${dir}/${base}_2.trimmed.fq.gz \
        -O ${dir}/${base}.umap.bam \
        -SM ${base} \
	-RG ${base}
done

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*.umap.bam`

do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample ".umap.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeBamAlignment \
        -ALIGNED ${dir}/${base}.bam \
        -UNMAPPED ${dir}/${base}.umap.bam \
        -O ${dir}/${base}_merge.bam \
        -R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta
done

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*_merge.bam`

do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample "_merge.bam")

samtools sort ${dir}/${base}_merge.bam -m 1000000000 -@ 14 -o ${dir}/${base}_qname.bam 

done

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*_qname.bam`

do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample "_qname.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MarkDuplicates \
	-I ${dir}/${base}_qname.bam \
	-O ${dir}/${base}.marked.bam \
	-M ${dir}/${base}.marked_dup_metrics.txt \
	-ASSUME_SORT_ORDER coordinate
done
