source activate main_env 
export BLASTDB="/Users/s1886853/databases/nt_db/nt"
for sample in `ls /Users/s1886853/Desktop/*_top_500_overrepresented.fa`

do
dir="/Users/s1886853/Desktop"
base=$(basename $sample "_top_500_overrepresented.fa")

/usr/local/ncbi/blast/bin/./blastn \
	-task blastn \
	-query ${dir}/${base}_top_500_overrepresented.fa \
	-db ~/databases/nt_db/nt \
	-outfmt '6 qseqid staxids bitscore std sscinames' \
	-max_target_seqs 1 \
	-max_hsps 1 \
	-num_threads 16 \
	-evalue 1e-25 \
	-out ~/Desktop/${base}.out
done
