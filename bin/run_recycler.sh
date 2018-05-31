set -e 

function usage(){
	echo 'usage : run_recycler.sh <list of assemblies names> <assembly_graph1> <assembly_graph2> <...> [options]    
	[options] : 
	-o outdir (default : results/recycler)  
	-1 : reads R1   
	-2 : reads R2 
	' 
}

TEMP=$(getopt -o o:,h,1:,2: -l tmp: -- "$@")
eval set -- "$TEMP" 

outdir=results/recycler 
tmp_dir=`mktemp -d -p .`

while true ; do 
	case "$1" in 
		-h) 
			usage
			shift ;;
		-o) 
			outdir=$2
			shift 2;;	
		-1) 
			reads1=$2 
			shift 2;; 
		-2) 
			reads2=$2 
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
	echo 'give assemblies graphs' 	
	exit 1 
elif [[ ! $reads1 ]]; then
	usage 
	echo 'give reads 1' 
	exit 1 
elif [[ ! $reads2 ]]; then 
	usage 
	echo 'give reads 2' 
	exit 1 
fi 

mkdir -p $outdir 

list_of_assemblies_names=$1
assemblies_format=$(echo $list_of_assemblies_names | tr "," " ")  
 
shift 

assemblies_graphs="" 
 
while [[ $@ ]]; do 
	assemblies_graphs=$assemblies_graphs" "$1 
	shift 
done 

arr_assemblies_names=($assemblies_format) 
arr_assemblies_graphs=($assemblies_graphs) 

len=$((${#arr_assemblies_names[@]}-1)) 

for i in `seq 0 $len` ; do 
	fastg=${arr_assemblies_graphs[$i]}
	make_fasta_from_fastg.py -g  $fastg -o $tmp_dir/assembly_graph.nodes.fasta 
	bwa index $tmp_dir/assembly_graph.nodes.fasta 
	echo "== bwa alignment"
	bwa mem $tmp_dir/assembly_graph.nodes.fasta $reads1 $reads2 -t 6 | samtools view -buS - > $tmp_dir/reads_pe.bam
	samtools view -bF 0x0800 $tmp_dir/reads_pe.bam > $tmp_dir/reads_pe_primary.bam
	samtools sort $tmp_dir/reads_pe_primary.bam $tmp_dir/reads_pe_primary.sort
	samtools index $tmp_dir/reads_pe_primary.sort.bam
	echo "== recycler" 
	recycle.py -g $fastg -b $tmp_dir/reads_pe_primary.sort.bam -k 55 -o $outdir/${arr_assemblies_names[$i]} -i False
done 	

rm -r $tmp_dir 


