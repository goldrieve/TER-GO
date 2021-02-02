source activate main_env

for sample in `ls /Users/s1886853/komics/Selected/*.trim.1.fq.gz`

do

dir="/Users/s1886853/komics/Selected"
base=$(basename $sample ".trim.1.fq.gz")

komics assemble --threads 4 --kmin 29 --kmax 119 --kstep 20 ${base}_run1 ${dir}/${base}.trim.1.fq.gz ${dir}/${base}.trim.2.fq.gz

done
