source activate lumpy

for sample in `ls /Users/s1886853/TERGO/Monomorph/927_aln/V4/bwa/*.bam`

do
dir="/Users/s1886853/TERGO/Monomorph/927_aln/V4/bwa"
base=$(basename $sample ".bam")

samtools view -b -F 1294 ${dir}/${base}.bam > ${dir}/${base}.discordants.unsorted.bam

samtools view -h ${dir}/${base}.bam \
    | /Users/s1886853/miniconda3/pkgs/lumpy-sv-0.2.14a-hdfb72b2_2/share/lumpy-sv-0.2.14a-2/scripts/extractSplitReads_BwaMem -i stdin \
    | samtools view -Sb - \
    > ${dir}/${base}.splitters.unsorted.bam

samtools sort ${dir}/${base}.discordants.unsorted.bam > ${dir}/${base}.discordants
samtools sort ${dir}/${base}.splitters.unsorted.bam > ${dir}/${base}.splitters

done
