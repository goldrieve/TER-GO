for sample in `ls /Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK/*.marked.bam`

do

dir="/Users/s1886853/TERGO/Monomorph/SIF_pathway/GATK"
base=$(basename $sample ".marked.bam")

picard AddOrReplaceReadGroups \
       I=${dir}/${base}.marked.bam \
       O=${dir}/${base}.rg.marked.bam \
       RGID=${base} \
       RGLB=${base} \
       RGPL=ILLUMINA \
       RGPU=${base} \
       RGSM=${base}
done
