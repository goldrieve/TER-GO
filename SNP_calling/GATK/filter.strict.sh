source activate main_env
dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed/calls_v2"

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
	-V ${dir}/snps.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "DP < 5.0" --filter-name "DP5" \
	-filter "QUAL < 500.0" --filter-name "QUAL500" \
	-filter "SOR > 3.0" --filter-name "SOR3" \
	-filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" \
	-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
	-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	-window "10" \
	-cluster "3" \
	-O ${dir}/strict_snps_filtered.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
	-V ${dir}/indels.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 500.0" --filter-name "QUAL500" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O ${dir}/strict_indels_filtered.vcf

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeVcfs \
	-I ${dir}/strict_snps_filtered.vcf \
	-I ${dir}/strict_indels_filtered.vcf \
	-O ${dir}/strict_variants_filtered.vcf

bcftools view -f .,PASS ${dir}/strict_variants_filtered.vcf > ${dir}/strict_final.calls.filtered.vcf
