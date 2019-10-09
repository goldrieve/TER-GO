#!/bin/bash

# Execute in the current working directory
#$ -cwd
#USe environment variable present at qsub (i.e. STAR/TOPHAT/etc PATH in bashrc etc)
#$ -N blast
#$ -V
# Set PE
#$ -l h_vmem=20G #memory per core
#$ -l h_rt=47:59:59

#set up environmental modules command
. /etc/profile.d/modules.sh

module load roslin/blast+/2.7.1

for sample in `ls /home/s1886853/Group_space/Abdelrahim/fasta/*.fasta`
do
dir="/home/s1886853/Group_space/Abdelrahim/aligned_reads"
base=$(basename $sample ".fasta")

blastn -task blastn -query ${dir}/${base}.fasta -db /home/s1886853/Group_space/Abdelrahim/ITS1_Guy/ITS1_db_seq -evalue 1e-10 -outfmt 6 | sort -k1,1 -k12,12nr -k11,11n | sort -u -k1,1 --merge > ${base}.blastn

done
