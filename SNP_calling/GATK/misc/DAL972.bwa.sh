source activate samtools

for sample in `ls /Users/s1886853/TERGO/Monomorph/Mylene/Microsat/*.fa`

do 

dir="/Users/s1886853/TERGO/Monomorph/Mylene/Microsat"
base=$(basename $sample ".fa")
	
bwa mem -M -t 16 -k 60 /Users/s1886853/TERGO/Monomorph/Mylene/Microsat/${base}.fa ~/Desktop/Tbgambiense_reads_07Apr06.fasta | \
	samtools view -hbS - > /Users/s1886853/TERGO/Monomorph/Mylene/Microsat/Bam/${base}.DAL972.bam
done
