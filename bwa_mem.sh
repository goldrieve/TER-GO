source activate main_env

for sample in `ls /Users/s1886853/TERGO/Raw_data/UPA/DNA/*_1.fq.gz`
do
dir="/Users/s1886853/TERGO/Raw_data/UPA/DNA"
base=$(basename $sample "_1.fq.gz")

bwa mem -t 16 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" ~/TERGO/Reference_genomes/Tb927/V5/Tb927_46/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz > ~/TERGO/Monomorph/927_aln/V5/Tb927_46/${base}.sam
done

for sample in `ls /Users/s1886853/TERGO/Raw_data/NEK/DNA/*_1.fq.gz`
do
dir="/Users/s1886853/TERGO/Raw_data/NEK/DNA"
base=$(basename $sample "_1.fq.gz")

bwa mem -t 16 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" ~/TERGO/Reference_genomes/Tb927/V5/Tb927_46/TriTrypDB-46_TbruceiTREU927_Genome.fasta ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz > ~/TERGO/Monomorph/927_aln/V5/Tb927_46/${base}.sam
done
