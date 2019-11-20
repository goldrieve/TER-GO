source activate main_env

for sample in `ls /Users/s1886853/TERGO/Raw_data/NEK*_1.fq.gz`
do
dir="/Users/s1886853/TERGO/Raw_data"
base=$(basename $sample "_1.fq.gz")

bwa mem -t 15 -R "@RG\tID:id\tSM:sample\tLB:lib" ~/TERGO/Reference_genomes/V4/Tb927_genome_230210.fas ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz  \
    | samblaster --excludeDups --addMateTags --maxSplitCount 2 --minNonOverlap 20 \
    | samtools view -S -b - \
    > ~/TERGO/NEK_assemblies/927_aln/927_V4/bwa/${base}.bam
done
