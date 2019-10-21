source activate main_env

cnvkit.py batch \
	--method wgs ~/TERGO/NEK_assemblies/927_aln/927_V4/*.bam \
	-n ~/TERGO/NEK_assemblies/927_aln/927_V4/START/NEK_START_sorted.bam \
	--processes 14 \
	--annotate /Users/s1886853/TERGO/Reference_genomes/V4/gtf/Tb927_v4.gtf \
	--fasta ~/TERGO/Reference_genomes/V4/Tb927_genome_230210.fas \
	--output-dir ~/TERGO/NEK_assemblies/CNV_kit/TREU_V4/200_no_start \
	-t ~/TERGO/Reference_genomes/V4/my_target.bed \
	--target-avg-size 200 \
	--drop-low-coverage
