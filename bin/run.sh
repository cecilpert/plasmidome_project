set -e 

results_dir=$1 
db_dir=$2
mode=$3

megahit_assembly=$results_dir/assembly/megahit-20x-am0.1 
spades_assembly=$results_dir/assembly/metaspades-20x-am0.1
suffix=20x-am0.1 
blast_prefix=align_contig_plasmids
eval_megahit=$results_dir/assembly_evaluation/megahit-20x-am0.1
eval_metaspades=$results_dir/assembly_evaluation/metaspades-20x-am0.1

if [ $mode == "test" ] 
then 
   db_prefix=$db_dir/plasmid148_test
else 
   db_prefix=$db_dir/plasmid148_no_dupl
fi  

#./bin/simulate_reads.sh $results_dir $db_dir $suffix $mode

mkdir -p $results_dir/assembly

#megahit --12 $results_dir/simulated_reads/grinder-illumina-$suffix\-reads.fastq -t 6 -o $megahit_assembly
#/usr/local/SPAdes-3.9.0-Linux/bin/spades.py --12 $results_dir/simulated_reads/grinder-illumina-$suffix\-reads.fastq -t 6 --meta --only-assembler -o $spades_assembly   

mkdir -p $results_dir/assembly_evaluation 

if [ ! -f $db_prefix.fasta.nhr ] 
then 
   makeblastdb -in $db_prefix.fasta -dbtype nucl 
fi 
 
mkdir -p $eval_megahit
mkdir -p $eval_metaspades 
 
blastn -query $megahit_assembly/final.contigs.fa -db $db_prefix.fasta -outfmt "6 qseqid sseqid pident qlen slen length mismatch gapope evalue bitscore" > $eval_megahit/$blast_prefix.blast.tsv
blastn -query $spades_assembly/scaffolds.fasta -db $db_prefix.fasta -outfmt "6 qseqid sseqid pident qlen slen length mismatch gapope evalue bitscore" > $eval_metaspades/$blast_prefix.blast.tsv 

python3 bin/treat_blast.py $eval_megahit/$blast_prefix.blast.tsv $eval_megahit/$blast_prefix.treatblast.tsv $eval_megahit/$blast_prefix.treatblast.interest.tsv 95 90
python3 bin/treat_blast.py $eval_metaspades/$blast_prefix.blast.tsv $eval_metaspades/$blast_prefix.treatblast.tsv $eval_metaspades/$blast_prefix.treatblast.interest.tsv 95 90 
