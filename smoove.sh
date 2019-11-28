for sample in `ls /src/Monomorph/927_aln/V4/bwa/bam/*.sorted.bam`
do

dir="/src/Monomorph/927_aln/V4/bwa/bam"
base=$(basename $sample ".sorted.bam")

smoove call --outdir /src/Monomorph/Smoove/results-smoove --name ${base} --fasta /src/Reference_genomes/Tb927/V4/Tb927_genome_230210.fas -p 8 --genotype ${dir}/${base}.sorted.bam

done
