source activate main_env

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*.rg.marked.bam`

do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample ".rg.marked.bam")

ulimit -c unlimited

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk HaplotypeCaller \
	-I ${dir}/${base}.rg.marked.bam \
	-O ${dir}/calls_v1/${base}.g.vcf \
	-R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-ERC GVCF 
done

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed/calls_v1"

find /Volumes/LaCie/Raw_data/mono_raw/trimmed/calls_v1 -name "*.g.vcf" > /Volumes/LaCie/Raw_data/mono_raw/trimmed/calls_v1/input.list

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk CombineGVCFs \
	-R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-V ${dir}/input.list \
	-O ${dir}/combined.g.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk GenotypeGVCFs \
	-R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-V ${dir}/combined.g.vcf \
	-O ${dir}/calls.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk SelectVariants \
	-V ${dir}/calls.vcf \
	-select-type SNP \
	-O ${dir}/snps.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk SelectVariants \
        -V ${dir}/calls.vcf \
        -select-type INDEL \
        -O ${dir}/indels.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
	-V ${dir}/snps.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "SOR > 3.0" --filter-name "SOR3" \
	-filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" \
	-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
	-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	-O ${dir}/snps_filtered.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
	-V ${dir}/indels.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O ${dir}/indels_filtered.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeVcfs \
	-I ${dir}/snps_filtered.vcf \
	-I ${dir}/indels_filtered.vcf \
	-O ${dir}/variants_filtered.vcf

bcftools view -f .,PASS ${dir}/variants_filtered.vcf > ${dir}/final.calls.filtered.vcf
