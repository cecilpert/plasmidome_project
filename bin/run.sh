set -e 

function usage(){
	echo 'usage : run.sh <outdir> <db directory>' 
}

if [ "$#" -ne 2 ]
then 
	usage 
	exit 1 
fi



outdir=$1 
db_dir=$2 

mkdir -p $outdir 

#python3 bin/separate_plasmids_chrm.py $db_dir/complete_genomes $db_dir complete

#bash bin/simulate_reads.sh $outdir/simulated_reads $db_dir/plasmids.fasta 20X-am0.1 $db_dir/summary_plasmids.tsv $db_dir/summary_chrm.tsv $db_dir/bacteria_chrm.fasta 

#bash bin/run_assembly.sh --megahit --metaspades --hybridspades -o $outdir/assembly -i $outdir/simulated_reads/grinder-illumina-20X-am0.1-reads.fastq -l $outdir/simulated_reads/grinder-pacbio-5x-20X-am0.1-reads.fastq 

megahit_assembly=$outdir/assembly/megahit/final.contigs.fa
metaspades_assembly=$outdir/assembly/metaspades/scaffolds.fasta
hybridspades_assembly=$outdir/assembly/hybridspades/scaffolds.fasta

#OSEF SUREMENT  
#python3 bin/assembly_length.py $megahit_assembly $outdir/assembly/megahit/assembly_length.tsv 
#python3 bin/assembly_length.py $metaspades_assembly $outdir/assembly/metaspades/assembly_length.tsv 
#python3 bin/assembly_length.py $hybridspades_assembly $outdir/assembly/hybridspades/assembly_length.tsv 

mkdir -p $outdir/assembly_evaluation

#~/quast/metaquast.py -R $db_dir/plasmid_sequences -l "megahit,metaspades,hybridspades" -o $outdir/assembly_evaluation/metaquast $megahit_assembly $metaspades_assembly $hybridspades_assembly 

#DO CORRECT LOOP 
tail -n +2 $outdir/assembly_evaluation/metaquast/combined_reference/contigs_reports/all_alignments_megahit.tsv | tac > $outdir/assembly_evaluation/metaquast/combined_reference/contigs_reports/all_alignments_megahit.rev.tsv
tail -n +2 $outdir/assembly_evaluation/metaquast/combined_reference/contigs_reports/all_alignments_metaspades.tsv | tac > $outdir/assembly_evaluation/metaquast/combined_reference/contigs_reports/all_alignments_metaspades.rev.tsv
tail -n +2 $outdir/assembly_evaluation/metaquast/combined_reference/contigs_reports/all_alignments_hybridspades.tsv | tac > $outdir/assembly_evaluation/metaquast/combined_reference/contigs_reports/all_alignments_hybridspades.rev.tsv

