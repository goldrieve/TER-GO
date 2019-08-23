quast.py ~/TERGO/NEK_assemblies/Assemblies/NEK_END.fasta \
	~/TERGO/NEK_assemblies/Assemblies/NEK_START.fasta \
	~/TERGO/NEK_assemblies/Assemblies/NEK_clone_2.fasta \
	~/TERGO/NEK_assemblies/Assemblies/NEK_clone_3.fasta \
	~/TERGO/NEK_assemblies/Assemblies/NEK_clone_4.fasta \
	~/TERGO/NEK_assemblies/Assemblies/NEK_clone_5.fasta \
	-r ~/TERGO/Reference_genomes/TriTrypDB-44_TbruceiTREU927_Genome.fasta \
	-g ~/TERGO/Reference_genomes/TriTrypDB-44_TbruceiTREU927.gff \
	--ref-bam ~/TERGO/NEK_assemblies/927_aln/NEK_END_sorted.bam \
	--ref-bam ~/TERGO/NEK_assemblies/927_aln/NEK_START_sorted.bam \
	--ref-bam ~/TERGO/NEK_assemblies/927_aln/Clone_2_sorted.bam \
	--ref-bam ~/TERGO/NEK_assemblies/927_aln/Clone_3_sorted.bam \
	--ref-bam ~/TERGO/NEK_assemblies/927_aln/Clone_4_sorted.bam \
	--ref-bam ~/TERGO/NEK_assemblies/927_aln/Clone_5_sorted.bam \
	-e 
	-o ~/Desktop/ \
	-t 14
