for sample in `ls /src/Monomorph/927_aln/V5/Tb927_46/*.sorted.bam`
do

dir="/src/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample ".sorted.bam")

smoove call \
	--outdir /src/Monomorph/Smoove/results-smoove_v5_46 \
	--name ${base} \
	--fasta /src/Reference_genomes/Tb927/V5/Tb927_46/TriTrypDB-46_TbruceiTREU927_Genome.fasta \
	-p 16 \
	--exclude /src/Reference_genomes/Tb927/V5/Tb927_46/exclude.bed \
	--genotype \
	${dir}/${base}.sorted.bam

done
