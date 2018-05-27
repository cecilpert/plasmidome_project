set -e 

function usage(){
	echo 'usage : run.sh <outdir>'        
}

if [[ $# -ne 1 ]]; then 
	usage 
	echo "Give out directory" 
	exit 1 
fi 

outdir=$1
mkdir -p $outdir 

echo "== CONSTRUCT DATABASES ==" 

dbdir=$outdir/database 
mkdir -p $outdir/database 

#bash bin/download_db.sh -o $outdir  

#Taxonomy assignment 
#python3 bin/plasmids_taxonomy.py test/plasmid.1.genomic.gbff test/plasmids_summary.tsv

#Delete viruses 
#grep -v "Virus" test/plasmids_summary.tsv > test/tmp.tsv 
#mv test/tmp.tsv test/plasmids_summary.tsv 

#File for krona 
#cut -f 3- test/plasmids_summary.tsv | sort | uniq -c > test/krona.tsv
#python3 bin/krona_txt.py test/krona.tsv test/krona.txt 

#Generate krona
#ktImportText test/krona.txt -o test/krona.html

#echo "Select and download non redondant species plasmids..."  
#python3 bin/select_plasmids.py $dbdir/plasmids_summary.tsv $dbdir/selected_plasmids

## CONTAMINANT DATABASE

# Download manually list genomes from IMG/M (https://img.jgi.doe.gov/cgi-bin/m/main.cgi?section=FindGenomes) in tsv format. 
# Sequence status must be column 3, Domain column 2 and NCBI project ID column 10. Others columns doesn't matter. 

#Keep only finished genomes, no metagenome, and only genomes with NCBI project ID
#awk -F'\t' '{if($3=="Finished" && $2 != "Metagenome" && $10 != 0) print}' test/taxontable.tsv > test/taxontable_ncbiproject.tsv 

#Keep one sequence per species, and select 500 genomes randomly  
#python3 bin/select_contaminants.py test/taxontable_ncbiproject.tsv test/taxontable_ncbiproject_nr.tsv 
shuf -n 10 $dbdir/taxontable_ncbiproject_nr.tsv > $dbdir/taxontable_ncbiproject_nr500.tsv

echo "Retrieve BioProject ID" 
#wget ftp://ftp.ncbi.nlm.nih.gov/bioproject/summary.txt -O $dbdir/summary_bioproject.txt 
bash bin/taxontable_bioproject.sh $dbdir/taxontable_ncbiproject_nr500.tsv $dbdir/summary_bioproject.txt $dbdir/bioproject500.tsv 
 
#echo "Download contaminant sequences..."  
python3 bin/download_contaminants.py $dbdir/bioproject500.tsv $dbdir/contaminants.fasta 

exit 

echo " == SIMULATE SEQUENCING ==" 
simulatedir=$outdir/simulated_reads
mkdir -p $simulatedir 

echo "Simulate Illumina plasmids sequencing..."

bash bin/simulate_reads.sh $dbdir/selected_plasmids.fasta -o $simulatedir --illumina 1 
illumina_depths="2 5 10 20"
for depth in $illumina_depths; do 
	echo $depth\X"..." 
	bash bin/simulate_reads.sh $dbdir/selected_plasmids.fasta -o $simulatedir --illumina $depth --ab_file $simulatedir/af0.1.txt
done 

echo "Simulate PacBio plasmids sequencing..." 
pacbio_depths="0.5 1 5" 
for depth in $pacbio_depths; do 
	echo $depth\X"..." 
	bash bin/simulate_reads.sh $dbdir/selected_plasmids.fasta -o $simulatedir --pacbio $depth --ab_file $simulatedir/af0.1.txt 
done

echo "Simulate Illumina contaminants sequencing..." 
cont_values="0.1 0.2" 
bash bin/simulate_reads.sh $dbdir/selected_plasmids.fasta -o $simulatedir --illumina 10 --contamination 0.05 --contamination_f $dbdir/contaminants.fasta  
exit 
for cont in $cont_values; do 
	echo $depth\X"..." 
	bash bin/simulate_reads.sh $dbdir/selected_plasmids.fasta -o $simulatedir --illumina 10 --cibt   
done 




