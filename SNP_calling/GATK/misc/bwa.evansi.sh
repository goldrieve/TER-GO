source activate samtools

for sample in `ls /Users/s1886853/TERGO/Raw_data/UPA/RNA/*_1.fq.gz`

do 

dir="/Users/s1886853/TERGO/Raw_data/UPA/RNA"
base=$(basename $sample "_1.fq.gz")
	
bwa mem -M -t 16 -k 60 -R "@RG\tID:${base}\tSM:${base}\tLB:${base}" \
	/Users/s1886853/Desktop/NRK.fa \
	${dir}/${base}_1.fq.gz ${dir}/${base}_2.fq.gz \
	| samtools view -F4 -hbS > \
	/Users/s1886853/Desktop/mono.targets.${base}.bam

done
