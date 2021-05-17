for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed_full/*_1.150.trimmed.fq.gz`
do
dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed_full"
base=$(basename $sample "_1.150.trimmed.fq.gz")

jellyfish count -C -m 21 -s 1000000000 -t 16 <(zcat < ${dir}/${base}._1.150.trimmed.fq.gz) <(zcat < ${dir}/${base}_2.150.trimmed.fq.gz) -o ${dir}/Jelly/${base}.jf
jellyfish histo -t 16 ${dir}/Jelly/${base}.jf > ${dir}/Jelly/${base}.reads.histo
done
