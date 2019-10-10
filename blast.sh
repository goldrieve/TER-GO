source activate main_env 

for sample in `ls /Users/s1886853/TERGO/Leish/fasta/*_db_seq`

do
dir="."
base=$(basename $sample "_db_seq.nhr")

blastn -task blastn -query /Users/s1886853/TERGO/Leish/ITS1_Guy/ITS1.fasta -db ${dir}/${base}_db_seq.nhr -evalue 1e-10 -outfmt 6 -out ${base}.blastn

done
