source activate main_env

for sample in `ls /Users/s1886853/TERGO/NEK_assemblies/CNV_kit/TREU_V4/200_no_start/*.cnr`

do

dir="/Users/s1886853/TERGO/NEK_assemblies/CNV_kit/TREU_V4/200_no_start"

base=$(basename $sample ".cnr")

cnvkit.py genemetrics ${dir}/${base}.cnr -s ${dir}/${base}.cns -t 0 -m 0 -y > ${dir}/${base}_thresh_copy.txt

done
