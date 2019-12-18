source activate main_env

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46/*.sorted.bam`
do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V5/Tb927_46"
base=$(basename $sample ".sorted.bam")

bcftools mpileup -f ~/TERGO/Reference_genomes/Tb927/V5/Tb927_46/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}.sorted.bam --threads 14 >  ~/TERGO/Monomorph/SNP/${base}.raw.bcf

done
