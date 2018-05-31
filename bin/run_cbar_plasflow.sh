set -e 

function usage(){
	echo 'usage : run_cbar_plasflow.sh <assembly name> <contig fasta file> <contigs stats tsv file> <thresold detection> <outdir>'
}

if [ "$#" -ne 5 ]
then 
	usage
	exit 1 
fi

assembly=$1
contigs=$2
contigs_stats=$3
thres=$4
outdir=$5

#bash bin/run_cbar.sh $assembly $contigs -o $outdir
cbar_plasmids=$outdir/cbar_$assembly\_predicted_plasmids.txt
cbar_not_plasmids=$outdir/cbar_$assembly\_predicted_not_plasmids
grep "Plasmid" $outdir/$assembly\_cbar_prediction.txt | cut -f 1 > $cbar_plasmids
grep "Chromosome" $outdir/$assembly\_cbar_prediction.txt | cut -f 1 > $cbar_not_plasmids.txt

python3 bin/seq_from_list.py $contigs $cbar_not_plasmids.txt $cbar_not_plasmids.fasta $assembly

bash bin/run_plasflow.sh $assembly $cbar_not_plasmids.fasta -o $outdir --thres $thres 
plasflow_plasmids=$outdir/plasflow$thres\_$assembly\_predicted_plasmids.txt 
plasflow_not_plasmids=$outdir/plasflow$thres\_$assembly\_predicted_not_plasmids.txt 

grep ">" $outdir/$assembly\_plasflow_$thres.tsv_plasmids.fasta | tr -d '>' > $plasflow_plasmids
cat $outdir/$assembly\_plasflow_$thres.tsv_chromosomes.fasta $outdir/$assembly\_plasflow_$thres.tsv_unclassified.fasta | grep ">" | tr -d ">" > $plasflow_not_plasmids

combined_plasmids=$outdir/cbar_plasflow$thres\_$assembly\_predicted_plasmids.txt 
cat $plasflow_plasmids $cbar_plasmids > $combined_plasmids

#bash bin/stats_plasmid_detection2.sh $assembly $outdir $contigs_stats $contigs $combined_plasmids $plasflow_not_plasmids plasflow$thres\_cbar > $outdir/plasflow$thres\_cbar_$assembly\_results.tsv 




