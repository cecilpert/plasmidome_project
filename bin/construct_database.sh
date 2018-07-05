set -e 

function usage(){
	echo 'usage : bash construct_database.sh -o outdir
	Options : 
	--plasmid : plasmid database construction  
	--contaminant : contaminants database construction'      
}

TEMP=$(getopt -o h,o: -l test,all,construct_db -- "$@")
eval set -- "$TEMP" 

while true ; do 
	case "$1" in 
		--plasmid)
			PLASMID=1
			shift ;;
		--contaminant) 
			CONTAMINANT=1 
			shift ;; 
		
		-h) 
			usage 
			shift ;;
		-o) 
			outdir=$2
			shift 2;;	
		--)  
			shift ; break ;; 					
	esac 
done 	



dbdir=$outdir/database
mkdir -p $dbdir  
cd $dbdir 

if [[ $PLASMID ]]; then 
	wget ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/plasmids.txt
	python3 $bin/plasmids_taxonomy.py plasmids.txt plasmids_taxonomy.tsv 
	sort -u -k 9 plasmids_taxonomy.tsv > plasmids_taxonomy.uniqspecie.tsv 
	cut -f 1 plasmids_taxonomy.uniqspecie.tsv > plasmids.uniqspecie.id.txt 
	cd $HOME/plasmidome_project
	python3 bin/download_plasmids.py $plasmids_id $dbdir\/plasmids.fasta 
fi 		
