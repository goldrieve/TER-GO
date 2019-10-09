#!/bin/bash

# Execute in the current working directory
#$ -cwd
#USe environment variable present at qsub (i.e. STAR/TOPHAT/etc PATH in bashrc etc)
#$ -N Bwt
#$ -V
# Set PE
#$ -l h_vmem=25G #memory per core
#$ -l h_rt=47:59:59

module load igmm/apps/sratoolkit/2.8.2-1

fastq-dump --outdir ~/Group_space/Oldrieve/NEK_mono_select/Raw_data/927 --gzip --split-files *sra
