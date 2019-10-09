grep -c "AE017150" *sam > 1.txt
grep -c "AL929603" *sam > 2.txt
grep -c "CH464491" *sam > 3.txt
grep -c "CH464492" *sam > 4.txt
grep -c "CM000207" *sam > 5.txt
grep -c "CM000208" *sam > 6.txt
grep -c "CP000066" *sam > 7.txt
grep -c "CP000067" *sam > 8.txt
grep -c "CP000068" *sam > 9.txt
grep -c "CP000069" *sam > 10.txt
grep -c "CP000070" *sam > 11.txt
grep -c "CP000071" *sam > 12.txt

paste *.txt | column -s $'\t' -t > count.txt
rm *.txt
