for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/raw/*_1.fq.gz`
do
dir="/Volumes/LaCie/Raw_data/mono_raw/raw"
outdir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample "_1.fq.gz")

trimmomatic PE -threads 16 ${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz ${outdir}/${base}_1.trimmed.fq.gz ${outdir}/${base}_1un.trimmed.fq.gz ${outdir}/${base}_2.trimmed.fq.gz ${outdir}/${base}_2un.trimmed.fq.gz SLIDINGWINDOW:4:20 ILLUMINACLIP:adapters.fa:2:40:15 MINLEN:25
fastqc -t 16 ${outdir}/${base}_1.trimmed.fq.gz ${outdir}/${base}_2.trimmed.fq.gz -o ${outdir}
done
