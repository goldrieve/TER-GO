source activate minimap2
minimap2 -t 4 -ax map-pb /Users/s1886853/TERGO/Monomorph/Antat_assembly/Antat_canu/purge_haplotigs/curated.fasta \
	/Users/s1886853/TERGO/Monomorph/Antat_assembly/downsample.5.fastq.fastq.gz --secondary=no \
	| samtools sort -o /Users/s1886853/TERGO/Monomorph/Antat_assembly/Antat_canu/purge_haplotigs/blob/aligned.bam -T tmp.ali
