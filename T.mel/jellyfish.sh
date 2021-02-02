source activate jelly
for sample in `ls /Volumes/LaCie/ncbi_public/sra/*_1.fastq.gz`;

do

dir="/Volumes/LaCie/ncbi_public/sra"
base=$(basename $sample "_1.fastq.gz")

jellyfish count -C -m 21 -s 1000000000 -t 16 < (zcat < ${dir}/${base}_1.fastq.gz) < (zcat < ${dir}/${base}_2.fastq.gz) -o ${dir}/jf/${base}.jf

done
