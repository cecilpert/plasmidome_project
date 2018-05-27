set -e 

function usage(){
	echo 'usage : taxontable_bioproject.sh <input taxontable file> <summary bioproject file> <output bioproject file>' 
}

if [[ $# -ne 3 ]]; then 
	usage
	exit 1 
fi 

for l in `cut -f 2 $1`; do  
	awk -F '\t' '$4'==$l $2 >> $3 
done 	
