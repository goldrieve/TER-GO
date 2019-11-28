for sample in `ls /src/Monomorph/927_aln/V4/bwa/bam/*.sorted.bam`
do

dir="/src/Monomorph/927_aln/V4/bwa/bam"
base=$(basename $sample ".sorted.bam")

smoove genotype -d -x -p 1 --name ${base} --outdir /src/Monomorph/Smoove/results-smoove/results-genotyped --fasta /src/Reference_genomes/Tb927/V4/Tb927_genome_230210.fas --vcf /src/Monomorph/Smoove/results-smoove/merged_mono.sites.vcf.gz ${dir}/${base}.sorted.bam

done
