set -e 

results_dir=~/plasmidome_project/results/complete 

./simulate_reads.sh $results_dir ~/plasmidome_project/plasmid_db/db148 complete

megahit --12 $results_dir/grinder_simulated_illumina-reads.fasta -t 6 -o $results_dir/megahit_assembly

