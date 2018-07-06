set -e 

function usage(){
	echo 'usage : bash construct_database.sh -o outdir
	Options : 
	--plasmid : plasmid database construction  
	--contaminant : contaminants database construction'      
}

TEMP=$(getopt -o h,o: -l plasmid,contaminant -- "$@")
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

if [[ ! $outdir ]]; then 
	usage
	echo "give output directory with -o" 
	exit 
fi 	

if [[ ! $PLASMID ]] && [[ ! $CONTAMINANT ]]; then 
	usage  
	echo "select --plasmid and/or --contaminant" 
	exit 
fi 	


dbdir=$outdir/database
mkdir -p $dbdir   

if [[ $PLASMID ]]; then 
	cd $dbdir
	wget ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/plasmids.txt
	cut -f 1,6 plasmids.txt > plasmids_org_id.txt 
	python3 $bin/plasmids_taxonomy.py plasmids_org_id.txt plasmids_taxonomy.tsv 
	sort -u -k 9 plasmids_taxonomy.tsv > plasmids_taxonomy.uniqspecie.tsv 
	cut -f 1 plasmids_taxonomy.uniqspecie.tsv > plasmids.uniqspecie.id.txt 
	cd $HOME/plasmidome_project
	python3 bin/download_plasmids.py $plasmids_id $dbdir\/plasmids.fasta 
fi 		

if [[ $CONTAMINANT ]]; then 
	cd $dbdir 
	wget ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/prokaryotes.txt
	awk '{if ($16 == "Complete Genome") print}' prokaryotes.txt > prokaryotes.completegenome.txt 
	cut -f 1,9 prokaryotes.completegenome.txt > prokaryotes_org_id.completegenome.txt 
fi 
