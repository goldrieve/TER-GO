source activate main_env

for sample in `ls /Users/s1886853/TERGO/NEK_assemblies/CNV_kit/TREU_V4/200_no_start/*.cnr`

do

dir="/Users/s1886853/TERGO/NEK_assemblies/CNV_kit/TREU_V4/200_no_start"

base=$(basename $sample ".cnr")

cnvkit.py genemetrics ${dir}/${base}.cnr > ${dir}/${base}_copyn.txt

done
