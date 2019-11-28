source activate main_env

for sample in `ls /Users/s1886853/TERGO/Raw_data/UPA/DNA/*_1.fq.gz`
do
dir="/Users/s1886853/TERGO/Raw_data/UPA/DNA"
base=$(basename $sample "_1.fq.gz")

bwa mem -t 8 -R "@RG\tID:id\tSM:sample\tLB:lib" ~/TERGO/Reference_genomes/Tb927/V4/Tb927_genome_230210.fas ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz  \
    | samblaster --excludeDups --addMateTags --maxSplitCount 2 --minNonOverlap 20 \
    | samtools view -S -b - \
    > ~/TERGO/Monomorph/927_aln/V4/bwa/${base}.bam
done
