source activate lumpy

dir="~/TERGO/Monomorph/927_aln/V4/bwa/"

lumpyexpress \
    -B NEK_END.bam,NEK_clone_2.bam \
    -S NEK_END.splitters,NEK_clone_2.splitters \
    -D NEK_END.discordants,NEK_clone_2.discordants \
    -o multi_sample.vcf
