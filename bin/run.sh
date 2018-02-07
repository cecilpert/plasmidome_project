set -e 

results_dir=$1 
db_dir=$2
mode=$3

megahit_assembly=$results_dir/assembly/megahit-am0.1 
suffix=am0.1
blast_prefix=$results_dir/assembly_evaluation/megahit_illumina_am0.1 

if [ $mode == "test" ] 
then 
   db_prefix=$db_dir/plasmid148_test
else 
   db_prefix=$db_dir/plasmid148
fi  

./bin/simulate_reads.sh $results_dir $db_dir $suffix $mode

mkdir -p $results_dir/assembly

megahit --12 $results_dir/simulated_reads/grinder-illumina-20x-$suffix\-reads.fastq -t 6 -o $megahit_assembly


mkdir -p $results_dir/assembly_evaluation 

if [ ! -f $db_prefix.fasta.nhr ] 
then 
   makeblastdb -in $db_prefix.fasta -dbtype nucl 
fi 

blastn -query $megahit_assembly/final.contigs.fa -db $db_prefix.fasta -outfmt "6 qseqid sseqid pident qlen slen length mismatch gapope evalue bitscore" > $blast_prefix.blast.tsv

python3 bin/treat_blast.py $blast_prefix.blast.tsv $blast_prefix.treatblast.tsv $blast_prefix.treatblast.interest.tsv 95 90 
