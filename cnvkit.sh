source activate main_env

cnvkit.py batch --method wgs ~/TERGO/NEK_assemblies/927_aln/*.bam --normal ~/TERGO/NEK_assemblies/927_aln/NEK_START_sorted.bam -n --target-avg-size 5000 -p 14 --fasta ~/TERGO/Reference_genomes/TriTrypDB-44_TbruceiTREU927_Genome.fasta --annotate ~/TERGO/Reference_genomes/TriTrypDB-44_TbruceiTREU927_V3.gtf --output-dir ~/TERGO/NEK_assemblies/CNV_kit/5000_bin_NEK_transcript --scatter --diagram
