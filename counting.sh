grep -c "MEKK1_clone3_contig_2286" *sam > mutant.txt
grep -c "MEKK1_clone5_contig_7750" *sam > wt.txt
paste mutant.txt wt.txt | column -s $'\t' -t > count.txt
sed  -i '1i Mutant WT' count.txt
rm mutant.txt
rm wt.txt
