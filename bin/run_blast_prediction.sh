set -e 

function usage(){
	echo 'usage : run_blast_prediction.sh <assembly name> <contig fasta file> <contigs stats tsv file> <db file> <outdir> <nucl/prot>'
}

if [ "$#" -ne 6 ]
then 
	usage
	exit 1 
fi

assembly=$1
contigs=$2
contigs_stats=$3
dbfile=$4
resultsdir=$5
dbtype=$6

#makeblastdb -in $dbfile -dbtype $dbtype

mkdir -p $resultsdir

blastxml=$resultsdir/$assembly.blastn.xml
if [ "$dbtype" == "prot" ]; then 
	blast_type="blastx"
elif [ "$dbtype" == "nucl" ]; then 
	blast_type="blastn"	
fi 	

echo "== Run Blast" 
$blast_type -query $contigs -db $dbfile -outfmt 5 -num_threads 6 > $blastxml

echo "== Run Blast treatment" 
python3 ~/plasmidome_project/bin/treat_plasmidfinder.py $blastxml $resultsdir $assembly $blast_type

plasmids=$resultsdir/$assembly\_predicted_plasmids.txt
chrm=$resultsdir/$assembly\_predicted_not_plasmids.txt

echo "== Run prediction stats" 
#bash bin/stats_plasmid_detection2.sh $assembly $resultsdir $contigs_stats $contigs $plasmids $chrm blast_prediction > $resultsdir/plasmidfinder_$assembly\_results.tsv

 
