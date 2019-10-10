source activate main_env

for sample in `ls /Users/s1886853/TERGO/NEK_assemblies/CNV_kit/5000_bin_NEK_transcript/*.cnr`

do

dir="/Users/s1886853/TERGO/NEK_assemblies/CNV_kit/5000_bin_NEK_transcript"

base=$(basename $sample ".cnr")

cnvkit.py genemetrics ${dir}/${base}.cnr -s ${dir}/${base}.cns -t 0.3 -m 5 -y > ${dir}/${base}_thresh_copy.txt

done
