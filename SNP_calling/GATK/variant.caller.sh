for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/Recal/*.recal.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/Recal"
base=$(basename $sample ".recal.bam")

ulimit -c unlimited

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk HaplotypeCaller \
	-I ${dir}/${base}.recal.bam \
	-O /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/calls_V2/${base}.g.vcf \
	-R ~/TERGO/Monomorph/SIF_pathway/SIF.fasta \
	-ERC GVCF 
done

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/calls_V2"

#find /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/calls_V2 -name "*.g.vcf" > /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/calls_V2/input.list

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk CombineGVCFs \
	-R /Users/s1886853/TERGO/Monomorph/SIF_pathway/SIF.fasta \
	-V ${dir}/input.list \ 
	-O ${dir}/combined.g.vcf

dir="/Users/s1886853/TERGO/Monomorph/Tcomp/GATK/calls_v2"

gatk GenotypeGVCFs \
	-R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-V ${dir}/combined.g.vcf \
	-O ${dir}/calls.vcf

gatk SelectVariants \
	-V ${dir}/calls.vcf \
	-select-type SNP \
	-O ${dir}/snps.vcf

gatk SelectVariants \
        -V ${dir}/calls.vcf \
        -select-type INDEL \
        -O ${dir}/indels.vcf

gatk VariantFiltration \
	-V ${dir}/snps.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "SOR > 3.0" --filter-name "SOR3" \
	-filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" \
	-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
	-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	-O ${dir}/snps_filtered.vcf

gatk VariantFiltration \
	-V ${dir}/indels.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O ${dir}/indels_filtered.vcf

gatk MergeVcfs \
	-I ${dir}/snps_filtered.vcf \
	-I ${dir}/indels_filtered.vcf \
	-O ${dir}/variants_filtered.vcf

bcftools view -f .,PASS ${dir}/variants_filtered.vcf > ${dir}/final.calls.filtered.vcf
