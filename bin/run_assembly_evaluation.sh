set -e 

assembly=$1 
outdir=$2
db=$3 
prefix=$4

#Quast eval 

quast.py -o $outdir/$prefix\_quast $assembly 

#Align eval 
if [ ! -f $db.nhr ] 
then 
   makeblastdb -in $db -dbtype nucl 
fi 

mkdir -p $ $outdir/$prefix\_align
curdir=$outdir/$prefix\_align
 
blastn -query $assembly -db $db -outfmt "6 qseqid sseqid pident qlen slen length mismatch gapope evalue bitscore" > $curdir/$prefix\_vs_plasmids.blast.tsv  
blast_results=$curdir/$prefix\_vs_plasmids.blast.tsv
blast_treated_prefix=$curdir/$prefix\_vs_plasmids.treatblast 

python3 bin/treat_blast.py $blast_results $blast_treated_prefix.tsv $blast_treated_prefix.interest.tsv 95 90


