set -e 

function usage(){
	echo 'usage : bash delete_seq_parallel.sh <input.fasta> <ref_to_delete.txt> <output.fasta> <id type> <number of parallel jobs>' 
}

function prepare_parallelization(){
	mkdir -p $tmp/seq 
	split -n $p -d $inp seq
	mv seq* $tmp/seq 
	for f in $(ls $tmp/seq); do 
		tmp_out=$tmp/$f.fasta 
		echo "python3 $HOME/plasmidome_project/bin/delete_seq_from_file.py $tmp/seq/$f $ref $tmp_out $id ; rm $tmp/seq/$f" >> $tmp/commands.txt 
	done  
	
}	

function run_parallelization(){ 
	parallel --no-notice < $tmp/commands.txt 
	cat $tmp/*.fasta > $out
	rm -r $tmp 
}	

if [[ $# -ne 5 ]]; then 
	usage
	exit 1 
fi

tmp=$(mktemp -d -p .)
inp=$1 
ref=$2
out=$3
id=$4
p=$5

prepare_parallelization
run_parallelization
