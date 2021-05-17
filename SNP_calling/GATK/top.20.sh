source activate main_env

ulimit -c unlimited

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed/calls_v1"

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
	-filter "QUAL < 26812.68" --filter-name "QUAL30" \
	-filter "SOR > 3.0" --filter-name "SOR3" \
	-filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" \
	-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
	-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	-O ${dir}/top_snps_filtered.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
	-V ${dir}/indels.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 26812.68 " --filter-name "QUAL30" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O ${dir}/top_indels_filtered.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeVcfs \
	-I ${dir}/top_snps_filtered.vcf \
	-I ${dir}/top_indels_filtered.vcf \
	-O ${dir}/variants_filtered.vcf

bcftools view -f .,PASS ${dir}/variants_filtered.vcf > ${dir}/top_calls.vcf.gz
