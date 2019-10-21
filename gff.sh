source activate main_env

for sample in `ls /Users/s1886853/TERGO/Reference_genomes/V4/gff/*`
do
dir="/Users/s1886853/TERGO/Reference_genomes/V4/gff"
base=$(basename $sample "*")

gffread ${dir}/${base} -T -o ${dir}/${base}gtf
done
