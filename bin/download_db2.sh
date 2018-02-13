#!/bin/bash
set -e 

function usage(){
	echo 'usage : download_db2.sh <outdir> <execution mode>' 
}

if [ "$#" -ne 2 ]
then 
	usage 
	exit 1 
fi 

outdir=$1 
mode=$2

mkdir -p $outdir 

#Name of NCBI reference genomes 
#wget ftp://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/assembly_summary.txt -O $outdir/assembly_summary.txt 
 
#Keep only genome named as "reference genome" 
grep "reference genome" $outdir/assembly_summary.txt > $outdir/assembly_summary_refgenomes.txt 

#Keep only the ftp links for selected genomes 
cut -f 20 $outdir/assembly_summary_refgenomes.txt > $outdir/refgenomes_ftp.txt 

mkdir -p $outdir/complete_genomes 
genomes_dir=$outdir/complete_genomes

#Download selected genomes 
while read line  
do   
	ref=$(echo $line | cut -f 10 -d '/'| tr -d '\n')
	#if [ ! -f $genomes_dir/$ref\_genomic.fna ] ; then 
		#wget $line/$ref\_genomic.fna.gz -O $outdir/complete_genomes/$ref\_genomic.fna.gz
		#gunzip $outdir/complete_genomes/$ref\_genomic.fna.gz 
	#fi		
done < $outdir/refgenomes_ftp.txt 

#Delete genomes with only one sequence in fasta file (it means there's no plasmid) 
for genome_file in $(ls $genomes_dir); do 
	count_seq=$(grep "^>" -c $genomes_dir/$genome_file)
	if [ $count_seq == "1" ] ; then 
		rm $genomes_dir/$genome_file
	fi 	
done 	


if [ "$mode" == "test" ];then 
	plasmid_fasta=$outdir/plasmids_test.fasta 
	chrm_fasta=$outdir/bacteria_chrm_test.fasta 
else 
	plasmid_fasta=$outdir/plasmids.fasta
	chrm_fasta=$outdir/bacteria_chrm.fasta 
fi 

#Execute scripts to separate plasmids and chromosomes in different fasta files 	
python3 bin/separate_plasmids_chrm.py $genomes_dir $plasmid_fasta $chrm_fasta $outdir/summary_plasmids.tsv $mode 


	
	

 
