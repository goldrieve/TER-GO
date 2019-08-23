source activate main_env

cnvkit.py batch \
	--method wgs \
	~/TERGO/NEK_assemblies/927_aln/Normal/*.bam \		
	--normal ~/TERGO/NEK_assemblies/927_aln/NEK_START_sorted.bam \
	--fasta ~/TERGO/Reference_genomes/TriTrypDB-44_TbruceiTREU927_Genome.fasta \
	--output-dir ~/TERGO/NEK_assemblies/ \
	--scatter \
	--diagram \
	--target-avg-size 200 \
	-p
