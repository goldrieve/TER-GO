source activate busco

for sample in `ls /Users/s1886853/TERGO/Monomorph/Antat_genome/*.fasta`
do
dir="/Users/s1886853/TERGO/Monomorph/Antat_genome"
base=$(basename $sample ".fasta")

docker run -u $(id -u) -v $(pwd):/busco_wd ezlabgva/busco:v4.0.2_cv1 busco -i ${dir}/${base}.fasta -o $dir}/${base} --auto-lineage-euk -m geno -f

done
