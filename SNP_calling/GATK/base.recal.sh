/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk IndexFeatureFile \
     -I /Volumes/LaCie/Raw_data/mono_raw/trimmed/calls_v1/top_calls.vcf

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*.rg.marked.bam`

do
dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample ".rg.marked.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk BaseRecalibrator \
   -I ${dir}/${base}.rg.marked.bam \
   -R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
   --known-sites ${dir}/calls_v1/top_calls.vcf \
   -O ${dir}/${base}.recal.table

done

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*.rg.marked.bam`
do
dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample ".rg.marked.bam")

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk ApplyBQSR \
   -R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
   -I ${dir}/${base}.rg.marked.bam \
   --bqsr-recal-file ${dir}/${base}.recal.table \
   -O ${dir}/${base}.recal.bam

done

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*.recal.bam`
do
dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample ".recal.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk BuildBamIndex \
        -I ${dir}/${base}.recal.bam

done
