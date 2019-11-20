source activate salmon

for sample in `ls /Users/s1886853/TERGO/Raw_data/UPA/RNA/*_1.fq.gz`
do
dir="/Users/s1886853/TERGO/Raw_data/UPA/RNA"
base=$(basename $sample "_1.fq.gz")

salmon quant -i /Users/s1886853/TERGO/Monomorph_DE/salmon_index_decoy \
	-l A \
	--gcBias \
	--validateMappings \
	--numGibbsSamples 20 \
	-p 8 \
	-o /Users/s1886853/TERGO/Monomorph_DE/salmon/quants/${base} \
	-1 ${dir}/${base}_1.fq.gz \
	-2 ${dir}/${base}_2.fq.gz

done 
