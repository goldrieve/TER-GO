source activate flye
ulimit -n 4096
flye --pacbio-raw \
	/Users/s1886853/Desktop/downsample.5.fastq.fastq.gz \
	--out-dir /Volumes/LaCie/flye \
	--genome-size 35.9m \
	--threads 5 \
	--resume
