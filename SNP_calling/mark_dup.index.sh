for sample in `ls /Users/s1886853/TERGO/SIF_pathway/Alignments/*.marked.bam`
do
dir="/Users/s1886853/TERGO/SIF_pathway/Alignments"
base=$(basename $sample ".marked.bam")

picard BuildBamIndex I=${dir}/${base}.marked.bam

done
