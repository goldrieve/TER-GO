source activate main_env

for sample in `ls /Users/s1886853/TERGO/SIF_pathway/Alignments/*.sorted.bam`
do
dir="/Users/s1886853/TERGO/SIF_pathway/Alignments"
base=$(basename $sample ".sorted.bam")

gatk HaplotypeCaller \
	-R ~/TERGO/Reference_genomes/Tb927/V5/Tb927_46/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-I ${dir}/${base}.sorted.bam \
	-O ${dir}/${base}.sorted.vcf 
done
