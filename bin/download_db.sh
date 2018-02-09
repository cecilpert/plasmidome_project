set -e 

function usage(){
	printf "usage: download_db.sh <output_directory> <db name> <execution mode>\n 
	\t execution mode		complete or test
	\t output directory	directory where database and associated files will be stored
	\t db name		prefix name for database\n\n"
}

if [ $# -ne 3 ]
then
	usage
	exit 1 
fi		

outdir=$1
db_name=$2
mode=$3

#Download db list 
wget https://gitlab.com/sirarredondo/Plasmid_Assembly/blob/master/Analysis/All_Genomes/Benchmark_perPlasmid.csv -O $outdir/$db_name.csv
db_list = $outdir/$db_name.csv

#Delete first description line, and take just accession number
tail -n +2 $db_list | cut -f 1 | cut -f 1 -d" " | cut -f 4 -d"|" > $outdir/$db_name\_acc.csv
db_acc_list = $outdir/$db_name\_acc.csv

#Download fasta files for given accession numbers

if [ "$mode" -eq "test" ]
then 
	head -n 15 $db_acc_list > $outdir/$db_name\_acc_test.csv
	python3 plasmid_dw.py $outdir/$db_name\_acc_test.csv $outdir/$db_name\_test.fasta  
else 
	python3 plasmid_dw.py $db_acc_list $outdir/$db_name.fasta
fi	
 


