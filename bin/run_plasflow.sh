set -e 

function usage(){
	echo 'usage : run_plasflow.sh <list of assemblies names> <contig fasta file 1> <contig fasta file 2> <...> [options]    
	[options] : 
	-o outdir (default : results/plasflow)   
	--tmp tmp dir (default : tmp) 
	--thres thresold for plasflow classification 
	--min_contigs : min contigs size to be classified (default:1000)
	' 
}

TEMP=$(getopt -o o:,h -l tmp:,thres:,min_contigs: -- "$@")
eval set -- "$TEMP" 

outdir=results/plasflow 
tmp_dir=`mktemp -d -p .`
thres=0.7
min_contigs=1000

while true ; do 
	case "$1" in 
		-h) 
			usage
			shift ;;
		-o) 
			outdir=$2
			shift 2;;	
		--tmp) 
			tmp_dir=$2
			shift 2;; 
		--thres) 
			thres=$2
			shift 2;;	
		--min_contigs) 
			min_contigs=$2
			shift 2;; 
		--)  
			shift ; break ;; 					
	esac 
done 	

if [ "$#" -eq 0 ]
then 
	usage
	echo 'give list of assemblies'  
	exit 1 
elif [ "$#" -eq 1 ]
then 
	usage 
	echo 'give contigs fasta files' 	
	exit 1 
fi 

mkdir -p $outdir 

assemblies_format=$(echo $1 | tr "," " ")  
shift

assemblies_contigs="" 

while [[ $@ ]]; do 
	assemblies_contigs=$assemblies_contigs" "$1 
	shift 
done 

arr_assemblies_names=($assemblies_format) 
arr_assemblies_contigs=($assemblies_contigs) 	

len=$((${#arr_assemblies_names[@]}-1)) 

for i in `seq 0 $len` ; do 
	contigs=${arr_assemblies_contigs[$i]}
	name=${arr_assemblies_names[$i]} 
	tmp_fasta=$tmp_dir/$name\1000.fasta
	outfile=$outdir/$name\_plasflow_$thres.tsv
	echo "== plasflow $name"
	~/PlasFlow/filter_sequences_by_length.pl -input $contigs -output $tmp_fasta -thres $min_contigs 
	python3 ~/PlasFlow/PlasFlow.py --input $tmp_fasta --output $outfile --models ~/PlasFlow/models --thres $thres
done 	

rm -r $tmp_dir 