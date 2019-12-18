source activate main_env

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46/*.marked.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample ".marked.bam")

gatk Mutect2 \
	-R ~/TERGO/Reference_genomes/Tb927/V5/Tb927_46/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-I ${dir}/${base}.marked.bam \
	-tumour ${base} \
	-I ${dir}/NEK_START.marked.bam \
	-normal NEK_START \
	-O ${dir}/${base}.vcf.gz

done
