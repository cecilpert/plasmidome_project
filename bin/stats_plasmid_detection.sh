function usage(){
	echo 'usage : stats_plasmid_detection.sh <assembly name> <plasmid detection dir> <contigs stats> <contigs fasta file> <plasmids> <chrm> <detection method>'     
	
}

if [[ $# -ne 7 ]]; then 
	usage 
	exit 1 
fi 

a=$1
predict_dir=$2
contigs_stats=$3
contigs_fasta=$4
method=$7

echo -e "Assembly\tTrue positives\tFalse positives\tTrue negatives\tFalse negatives\tPrecision\tRecall\tError\tAccuracy\tLost\tSpecificity\tPrediction tool"

plasmids=$5
chrm=$6
	
contig_stats_p=$predict_dir/$a\_predicted_plasmids_contigs_stats.tsv 
contig_stats_c=$predict_dir/$a\_predicted_not_plasmids_contigs_stats.tsv
	
head -n 1 $contigs_stats > $contig_stats_p
head -n 1 $contigs_stats > $contig_stats_c

tmpdir=`mktemp -d -p .`
echo $tmpdir 
 	 
awk '{if($1=="'$a'") print}' $contigs_stats > $tmpdir/tmp.tsv

for contig in $(cat $plasmids); do 
	grep $contig"_" $tmpdir/tmp.tsv >> $contig_stats_p  
done 	
		
for contig in $(cat $chrm); do 
	grep $contig"_" $tmpdir/tmp.tsv >> $contig_stats_c
done 
	 
rm -r $tmpdir
		
VP=$predict_dir/$method\_$a\_true_positives_contigs.txt 
FP=$predict_dir/$method\_$a\_false_positives_contigs.txt 
VN=$predict_dir/$method\_$a\_true_negatives_contigs.txt 
FN=$predict_dir/$method\_$a\_false_negatives_contigs.txt 
	
awk '{if($4=="correct" || $4 == "ambiguous" || $4 == "misassembled") print}' $contig_stats_p | cut -f 2 > $VP
awk '{if($4=="contamination" || $4 == "others") print}' $contig_stats_p | cut -f 2 > $FP
awk '{if($4=="correct" || $4 == "ambiguous" || $4 == "misassembled") print}' $contig_stats_c | cut -f 2 > $FN
awk '{if($4=="contamination" || $4 =="others") print}' $contig_stats_c | cut -f 2 > $VN

VP_bases=`python3 bin/total_length_contig_list.py $VP $contigs_fasta` 
FP_bases=`python3 bin/total_length_contig_list.py $FP $contigs_fasta`
FN_bases=`python3 bin/total_length_contig_list.py $FN $contigs_fasta`
VN_bases=`python3 bin/total_length_contig_list.py $VN $contigs_fasta`

recall=`python3 -c "print(round($VP_bases/($VP_bases+$FN_bases),4))"`
precision=`python3 -c "print(round($VP_bases/($VP_bases+$FP_bases),4))"`
error=`python3 -c "print(round($FP_bases/($VP_bases+$FP_bases),4))"`
accuracy=`python3 -c "print(round(($VP_bases+$VN_bases)/($VP_bases+$FN_bases+$FP_bases+$VN_bases),4))"`
lost=`python3 -c "print(round($FN_bases/($VP_bases+$FN_bases),4))"`
specificity=`python3 -c "print(round($VN_bases/($VN_bases+$FP_bases),4))"`
echo -e "$a\t$VP_bases\t$FP_bases\t$VN_bases\t$FN_bases\t$precision\t$recall\t$error\t$accuracy\t$lost\t$specificity\t$method" 




