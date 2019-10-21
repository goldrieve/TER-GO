source activate main_env

for sample in `ls /Users/s1886853/TERGO/Raw_data/NEK*`
do
dir="/Users/s1886853/TERGO/Raw_data"
base=$(basename $sample "_1.fq.gz")
bowtie2 -x /Users/s1886853/TERGO/Reference_genomes/V4/TREU_V4 --sensitive-local --no-unal -p 14 -1 ${dir}/${base}_1.fq.gz -2 ${dir}/${base}_2.fq.gz -S /Users/s1886853/TERGO/NEK_assemblies/927_aln/927_V4/${base}.sam | samtools view -bS -> ${base}out.bam 
done
