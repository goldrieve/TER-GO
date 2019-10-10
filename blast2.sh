source activate main_env 

for i in $(find . -name '*.nhr') ; do
  database="${i%.*}"
  time blastn -db "$database" -query /Users/s1886853/TERGO/Leish/ITS1_Guy/ITS1.fasta -out "$i".out -evalue 1e-10  -outfmt 6 -num_threads 16 -dust yes -ungapped
done
