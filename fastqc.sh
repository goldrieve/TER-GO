source activate main_env

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/*_1.fq.gz`

do

dir="/Volumes/LaCie/Raw_data/mono_raw"
base=$(basename $sample "_1.fq.gz")

fastqc ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz -t 16 --outdir ${dir}

done
