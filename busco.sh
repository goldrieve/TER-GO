source activate busco

for sample in `ls ~/TERGO/Tcomp/Genome/*.fasta`
do
dir="~/TERGO/Tcomp/Genome"
base=$(basename $sample ".fasta")

docker run -u $(id -u) -v $(pwd):/busco_wd ezlabgva/busco:v4.0.2_cv1 busco -i ${dir}/${base}.fasta -o ${base} --auto-lineage-euk -m geno -f

done
