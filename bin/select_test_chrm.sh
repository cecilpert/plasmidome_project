set -e 

function usage(){
	echo 'usage : bash construct_database.sh <taxonomy file> <filter taxonomy file>
	INPUT : taxonomy file (produced by plasmids_taxonomy.py for example) with columns : id	organism name	kingdom	phylum	class	order	family	genus	specie 
	OUTPUT : filter taxonomy file with 50 chromosomes : 10 E.coli, 5 other Escherichia, 10 others Enterobacteriaceae, 10 others Gammaproteobacteria and 15 others Proteobacteria'     
}

if [[ $# -ne 2 ]]; then 
	usage 
	exit 
fi 

inp=$1 
out=$2 

head -n 1 $inp > $out 

awk -F"\t" '{if($9=="Escherichia coli") print}' $inp | shuf -n 10 >> $out  	
awk -F"\t" '{if($8=="Escherichia" && $9!="Escherichia coli") print}' $inp | head -n 5 >> $out  	
awk -F"\t" '{if($7=="Enterobacteriaceae" && $8!="Escherichia" && $9!="Escherichia coli") print}' $inp | shuf -n 10 >> $out  	
awk -F"\t" '{if($5=="Gammaproteobacteria" && $7!="Enterobacteriaceae" && $8!="Escherichia" && $9!="Escherichia coli") print}' $inp | shuf -n 10 >> $out  	
awk -F"\t" '{if($4=="Proteobacteria" && $5!="Gammaproteobacteria" && $7!="Enterobacteriaceae" && $8!="Escherichia" && $9!="Escherichia coli") print}' $inp | shuf -n 15 >> $out  	


