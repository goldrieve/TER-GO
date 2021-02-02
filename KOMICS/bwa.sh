source activate main_env

for sample in `ls /Users/s1886853/TERGO/Raw_data/NEK/DNA/*_1.fq.gz`

do

dir="/Users/s1886853/TERGO/Raw_data/NEK/DNA"
base=$(basename $sample "_1.fq.gz")

bwa mem -M -t 16 /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz | samtools view -b -f 4 - > /Users/s1886853/komics/Selected/${base}.unmapped.bam

done

for sample in `ls /Users/s1886853/komics/Selected/*.unmapped.bam`

do

dir="/Users/s1886853/komics/Selected"
base=$(basename $sample ".unmapped.bam")

gatk SamToFastq -I ${dir}/${base}.unmapped.bam -F ${dir}/${base}.1.fq.gz -F2 ${dir}/${base}.2.fq.gz
fastp -i ${dir}/${base}.1.fq.gz -I ${dir}/${base}.2.fq.gz -o ${dir}/${base}.trim.1.fq.gz -O ${dir}/${base}.trim.2.fq.gz -q 30 -u 10 -5 -3 -W 1 -M 30 --cut_right --cut_right_window_size 10 --cut_right_mean_quality 30 -l 50 -b 150
done

