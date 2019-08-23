source activate main_env

cnvkit.py batch --method wgs ~/TERGO/NEK_assemblies/927_aln/*.bam -n --target-avg-size 1000 -p --fasta ~/TERGO/Reference_genomes/TriTrypDB-44_TbruceiTREU927_Genome.fasta --output-dir ~/TERGO/NEK_assemblies/CNV_kit/1000_bin --scatter --diagram
