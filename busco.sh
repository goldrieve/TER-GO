#!/bin/bash

# Execute in the current working directory
#$ -cwd
#USe environment variable present at qsub (i.e. STAR/TOPHAT/etc PATH in bashrc etc)
#$ -N BUSCO
#$ -V
# Set PE
#$ -l h_vmem=20G #memory per core
#$ -l h_rt=47:59:59

#set up environmental modules command
. /etc/profile.d/modules.sh

module load anaconda
source activate busco

for sample in `ls /home/s1886853/Group_space/NEK_mono_select/Clone_assemblies/*.fasta`
do
dir="/home/s1886853/Group_space/NEK_mono_select/Clone_assemblies"
base=$(basename $sample ".fasta")

run_busco -i ${dir}/${base}.fasta -o ${base} -l /exports/csce/eddie/biology/groups/matthews/conda_envs/envs/busco/database/protists_ensembl -m geno
done
