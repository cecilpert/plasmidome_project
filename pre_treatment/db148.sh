set -e 
list_plasmid=$1
outdir=$2
mode=$3

#cd plasmidome_project 

#Delete first description line, and take just accession number
tail -n +2 $list_plasmid | cut -f 1 | cut -f 1 -d" " | cut -f 4 -d"|" > $outdir/plasmid148_acc.csv



#Download fasta files for given accession numbers

if [ "$mode" == "test" ]
then 
	head -n 15 $outdir/plasmid148_acc.csv > $outdir/plasmid148_acc_test.csv
	python3 plasmid_148_dw.py $outdir/plasmid148_acc_test.csv $outdir/plasmid148_test.fasta  
else 
	python3 plasmid_148_dw.py $outdir/plasmid148_acc.csv $outdir/plasmid148.fasta
fi	
 


