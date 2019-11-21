wget https://tritrypdb.org/common/downloads/Current_Release/TbruceiTREU927/fasta/data/TriTrypDB-46_TbruceiTREU927_AnnotatedTranscripts.fasta

wget https://tritrypdb.org/common/downloads/Current_Release/TbruceiTREU927/fasta/data/TriTrypDB-46_TbruceiTREU927_Genome.fasta

grep "^>" <(cat TriTrypDB-46_TbruceiTREU927_Genome.fasta) | cut -d " " -f 1 > decoys.txt
sed -i -e 's/>//g' decoys.txt

cat TriTrypDB-46_TbruceiTREU927_AnnotatedTranscripts.fasta TriTrypDB-46_TbruceiTREU927_Genome.fasta > Gentrome.fa

salmon index -t gentrome.fa -d decoys.txt -p 12 -i salmon_index --gencode

