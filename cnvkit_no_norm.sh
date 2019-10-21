source activate main_env

cnvkit.py batch \
	--method wgs ~/TERGO/NEK_assemblies/927_aln/*.bam \
	-r /Users/s1886853/TERGO/NEK_assemblies/CNV_kit/1000_bin_no_start/FlatReference.cnn \
	-p 14 \
	--output-dir ~/TERGO/NEK_assemblies/CNV_kit/1000_bin_no_start \
	--drop-low-coverage \
	--scatter --diagram
