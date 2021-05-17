source activate main_env

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*.rg.marked.bam`

do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed/calls_v2/Publicly_available"
base=$(basename $sample ".rg.marked.bam")

ulimit -c unlimited

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk HaplotypeCaller \
	-I ${dir}/${base}.rg.marked.bam \
	-O ${dir}/calls_v1/${base}.g.vcf \
	-R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-ERC GVCF 
done

find ${dir} -name "*.g.vcf" > ${dir}/input.list

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk CombineGVCFs \
	-R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-V ${dir}/input.list \
	-O ${dir}/combined.g.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk GenotypeGVCFs \
	-R /Users/s1886853/TERGO/Reference_genomes/Tb927/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-V ${dir}/combined.g.vcf \
	-O ${dir}/calls.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk SelectVariants \
	-V ${dir}/calls.vcf \
	-select-type SNP \
	-O ${dir}/snps.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk SelectVariants \
        -V ${dir}/calls.vcf \
        -select-type INDEL \
        -O ${dir}/indels.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
	-V ${dir}/snps.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "SOR > 3.0" --filter-name "SOR3" \
	-filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" \
	-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
	-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	-O ${dir}/loose_snps_filtered.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
	-V ${dir}/indels.vcf \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O ${dir}/loose_indels_filtered.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeVcfs \
	-I ${dir}/loose_snps_filtered.vcf \
	-I ${dir}/loose_indels_filtered.vcf \
	-O ${dir}/loose_variants_filtered.vcf

#bcftools view -f .,PASS ${dir}/loose_variants_filtered.vcf > ${dir}/loose_calls_filtered.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
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

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk VariantFiltration \
        -V ${dir}/indels.vcf \
        -filter "QD < 2.0" --filter-name "QD2" \
        -filter "QUAL < 500.0" --filter-name "QUAL500" \
        -filter "FS > 200.0" --filter-name "FS200" \
        -filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
        -O ${dir}/strict_indels_filtered.vcf

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk MergeVcfs \
        -I ${dir}/strict_snps_filtered.vcf \
        -I ${dir}/strict_indels_filtered.vcf \
        -O ${dir}/strict_variants_filtered.vcf

#bcftools view -f .,PASS ${dir}/strict_variants_filtered.vcf > ${dir}/strict_calls_filtered.vcf

#Generate CDS variant file for strict SNPS for iqtree
#vcftools --bed ${dir}/Tb927.11.cds.nopseudo.bed --recode --recode-INFO-all --vcf ${dir}/strict_snps_filtered.vcf --out ${dir}/strict_snps_filtered_CDS

#Generate CDS variant file for calls, loose calls and strict calls
#vcftools --bed ${dir}/Tb927.11.cds.nopseudo.bed --recode --recode-INFO-all --vcf ${dir}/calls.vcf --out ${dir}/calls_CDS
#vcftools --bed ${dir}/Tb927.11.cds.nopseudo.bed --recode --recode-INFO-all --vcf ${dir}/loose_calls_filtered.vcf --out ${dir}/loose_calls_filtered_CDS
#vcftools --bed ${dir}/Tb927.11.cds.nopseudo.bed --recode --recode-INFO-all --vcf ${dir}/strict_calls_filtered.vcf --out ${dir}/strict_calls_filtered_CDS

#Compute stats on whole genome vcfs
#vcfstats ${dir}/calls.vcf > ${dir}/calls.vcf.stats
#vcfstats ${dir}/loose_calls_filtered.vcf > ${dir}/loose_calls_filtered.vcf.stats
#vcfstats ${dir}/strict_calls_filtered.vcf > ${dir}/strict_calls_filtered.vcf.stats

#Compute stats on CDS vcfs
#vcfstats ${dir}/calls_CDS.recode.vcf > ${dir}/calls_CDS.recode.vcf.stats
#vcfstats ${dir}/loose_calls_filtered_CDS.recode.vcf > ${dir}/loose_calls_filtered_CDS.recode.vcf.stats
#vcfstats ${dir}/strict_calls_filtered_CDS.recode.vcf > ${dir}/strict_calls_filtered_CDS.recode.vcf.stats

#Generate fasta files
vcftools --vcf ${dir}/strict_snps_filtered.vcf --max-missing 1  --recode --recode-INFO-all --out ${dir}/strict_snps_filtered.genotyped
vk phylo fasta ${dir}/strict_snps_filtered.genotyped.recode.vcf > ${dir}/iqtree/strict_snps_filtered.fasta
vcftools --vcf ${dir}/strict_snps_filtered_CDS.recode.vcf --max-missing 1  --recode --recode-INFO-all --out ${dir}/strict_snps_filtered_CDS.recode.genotyped
vk phylo fasta ${dir}/strict_snps_filtered_CDS.recode.genotyped.recode.vcf > ${dir}/iqtree/strict_snps_filtered_CDS.fasta

#Generate variant site files
iqtree -s ${dir}/iqtree/strict_snps_filtered_CDS.fasta -m MFP+ASC -bb 1000 -nt AUTO
iqtree -s ${dir}/iqtree/strict_snps_filtered.fasta -m MFP+ASC -bb 1000 -nt AUTO

#Run IQ tree on variant sites
iqtree -s ${dir}/iqtree/strict_snps_filtered_CDS.fasta.varsites.phy -m MFP+ASC -bb 1000 -nt AUTO
iqtree -s ${dir}/iqtree/strict_snps_filtered.fasta.varsites.phy -m MFP+ASC -bb 1000 -nt AUTO
