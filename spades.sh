source activate main_env

for sample in `ls /Users/s1886853/TERGO/Raw_data/UPA/DNA/*_1.fq.gz`
do
dir="/Users/s1886853/TERGO/Raw_data/UPA/DNA"
base=$(basename $sample "_1.fq.gz")

spades.py -1 ${dir}/${base}_1.fq.gz -2 ${dir}/${base}_2.fq.gz -k 21,33,55,77,99 -o /Users/s1886853/TERGO/Assemblies/${base} -t 10

done
