source activate minimapv2

dir="/Users/s1886853/TERGO/Monomorph/Antat_assembly/Antat_canu/racon"
raw="/Users/s1886853/TERGO/Raw_data/Antat_pacbio"

minimap2 -x map-pb -d ${dir}/antat.contigs.mmi ${dir}/antat.contigs.fasta

minimap2 -x map-pb ${dir}/antat.contigs.mmi ${raw}/downsample.5.fastq.fastq.gz --secondary=no -t 10 > ${dir}/antat.contigs.mapped.paf 

racon ${raw}/downsample.5.fastq.fastq.gz ${dir}/antat.contigs.mapped.paf ${dir}/antat.contigs.fasta -t 10 > ${dir}/racon.1.fasta

minimap2 -x map-pb -d ${dir}/racon.1.mmi ${dir}/racon.1.fasta

minimap2 -x map-pb ${dir}/racon.1.mmi ${raw}/downsample.5.fastq.fastq.gz --secondary=no -t 10 > ${dir}/racon.1.mapped.paf

racon ${raw}/downsample.5.fastq.fastq.gz ${dir}/racon.1.mapped.paf ${dir}/racon.1.fasta -t 10 > ${dir}/racon.2.fasta

minimap2 -x map-pb -d ${dir}/racon.2.mmi ${dir}/racon.2.fasta

minimap2 -x map-pb ${dir}/racon.2.mmi ${raw}/downsample.5.fastq.fastq.gz --secondary=no -t 10 > ${dir}/racon.2.mapped.paf

racon ${raw}/downsample.5.fastq.fastq.gz ${dir}/racon.2.mapped.paf ${dir}/racon.2.fasta -t 10 > ${dir}/racon.3.fasta

minimap2 -x map-pb -d ${dir}/racon.3.mmi ${dir}/racon.3.fasta

minimap2 -x map-pb ${dir}/racon.3.mmi ${raw}/downsample.5.fastq.fastq.gz --secondary=no -t 10 > ${dir}/racon.3.mapped.paf

racon ${raw}/downsample.5.fastq.fastq.gz ${dir}/racon.3.mapped.paf ${dir}/racon.3.fasta -t 10 > ${dir}/racon.4.fasta

minimap2 -x map-pb -d ${dir}/racon.4.mmi ${dir}/racon.4.fasta

minimap2 -x map-pb ${dir}/racon.4.mmi ${raw}/downsample.5.fastq.fastq.gz --secondary=no -t 10 > ${dir}/racon.4.mapped.paf