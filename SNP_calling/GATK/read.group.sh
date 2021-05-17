source activate main_env

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/marked/DNBseq/*.marked.bam`
do

dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed/marked/DNBseq"
base=$(basename $sample ".marked.bam")

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk AddOrReplaceReadGroups \
        -I ${dir}/${base}.marked.bam \
        -O ${dir}/${base}.rg.marked.bam \
        -RGLB ${base} \
        -RGSM ${base} \
        -RGPU ${base} \
        --RGPL DNBseq

done

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/marked/Illumina/*.marked.bam`
do
dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed/marked/Illumina"
base=$(basename $sample ".marked.bam")

#/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk AddOrReplaceReadGroups \
        -I ${dir}/${base}.marked.bam \
        -O ${dir}/${base}.rg.marked.bam \
        -RGLB ${base} \
        -RGSM ${base} \
        -RGPU ${base} \
        --RGPL Illumina

done

#mv /Volumes/LaCie/Raw_data/mono_raw/trimmed/marked/Illumina/*rg.marked.bam Volumes/LaCie/Raw_data/mono_raw/trimmed
#mv /Volumes/LaCie/Raw_data/mono_raw/trimmed/marked/DNBseq/*rg.marked.bam Volumes/LaCie/Raw_data/mono_raw/trimmed

for sample in `ls /Volumes/LaCie/Raw_data/mono_raw/trimmed/*.rg.marked.bam`
do
dir="/Volumes/LaCie/Raw_data/mono_raw/trimmed"
base=$(basename $sample ".rg.marked.bam")

ulimit -c unlimited

/Users/s1886853/Pkgs/gatk-4.1.4.1/./gatk BuildBamIndex \
        -I ${dir}/${base}.rg.marked.bam

done
