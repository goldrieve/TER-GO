source activate main_env

for sample in `ls /Users/s1886853/TERGO/SIF_pathway/Alignments/*.marked.bam`

do

dir="/Users/s1886853/TERGO/SIF_pathway/Alignments"
base=$(basename $sample ".marked.bam")

cat /Users/s1886853/TERGO/SIF_pathway/SIF.fasta | bcftools consensus /Users/s1886853/TERGO/SIF_pathway/Alignments/VCF/V2/filtered.20.t.vcf.gz --sample ${base} > /Users/s1886853/TERGO/SIF_pathway/Consensus/${base}.alt.fa 

done 

for sample in `ls /Users/s1886853/TERGO/SIF_pathway/Consensus/*.alt.fa`

do

dir="/Users/s1886853/TERGO/SIF_pathway/Consensus"
base=$(basename $sample ".alt.fa")

sed 's/>.*/& '${base}'/' ${dir}/${base}.alt.fa > ${dir}/${base}.out.fa

done 
