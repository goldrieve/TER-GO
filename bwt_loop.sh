#!/bin/bash

# Execute in the current working directory
#$ -cwd
#USe environment variable present at qsub (i.e. STAR/TOPHAT/etc PATH in bashrc etc)
#$ -N Bwt
#$ -V
#$ -pe sharedmem 4 
#$ -l h_vmem=25G #memory per core
#$ -l h_rt=47:59:59

#set up environmental modules command
. /etc/profile.d/modules.sh
module load igmm/apps/bowtie/2.3.4.3

for sample in `ls /home/s1886853/Group_space/Oldrieve/NEK_mono_select/Raw_data/927/ERR005858*`
do
dir="/home/s1886853/Group_space/Oldrieve/NEK_mono_select/Raw_data/927"
base=$(basename $sample "_1.fq.gz")
bowtie2 -x /home/s1886853/Group_space/Oldrieve/Reference_genomes/927_chromosome_db/Assembly/927_index --sensitive-local --no-unal -1 ${dir}/${base}_1.fq.gz -2 ${dir}/${base}_2.fq.gz -S /home/s1886853/Scratch/927_mapping/${base}.sam
done
