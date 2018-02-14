set -e 

outdir=$1 
db_dir=$2 

mkdir -p $outdir 

python3 bin/separate_plasmids_chrm.py $db_dir/complete_genomes $db_dir complete

bash bin/simulate_reads.sh $outdir/simulate_reads $db_dir/plasmids.fasta 20X-am0.1 $db_dir/summary_plasmids.tsv $db_dir/summary_chrm.tsv $db_dir/bacteria_chrm.fasta 

bash bin/run_assembly.sh --megahit --metaspades --hybridspades -o $outdir/assembly -i $outdir/simulated_reads/grinder-illumina-20X-am0.1-reads.fastq -l $outdir/simulated_reads/grinder-pacbio-5x-20X-am0.1-reads.fastq 

mkdir -p $outdir/assembly_evaluation
metaquast.py -R $db_dir/plasmid_sequences -l "megahit,metaspades,hybridspades" -o $outdir/assembly_evaluation/metaquast $outdir/assembly/megahit/final.contigs.fa $outdir/assembly/metaspades/scaffolds.fasta $outdir/assembly/hybridspades/scaffolds.fasta 


  
