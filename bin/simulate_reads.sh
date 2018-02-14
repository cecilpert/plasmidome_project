set -e 

function usage(){
	echo 'usage : simulate_reads.sh <outdir> <reference file> <suffix simulated reads> <summary plasmid tsv file> <summary chromosome tsv file> <chromosome contamination fasta file>' 
}

if [ "$#" -ne 6 ]
then 
	usage 
	exit 1 
fi


outdir=$1
ref_file=$2
suffix=$3
summary_plasmid=$4
summary_chrm=$5
contamination_file=$6


mkdir -p $outdir

#generate Illumina reads, with no errors and no chimeras 
grinder -rf $ref_file -cf 20 -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder-illumina-$suffix -am powerlaw 0.1 

#Generate abundance file for Pacbio
cut -f 2,3 $outdir/grinder-illumina-$suffix-ranks.txt | tail -n +2 > $outdir/grinder-illumina-$suffix-af.txt
af=$outdir/grinder-illumina-$suffix-af.txt

#generate PacBio reads, with no errors and no chimeras, 5x coverage 
grinder -rf $ref_file -cf 5 -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder-pacbio-5x-$suffix -af $af  

python3 bin/genome_abundance.py $outdir/grinder-illumina-$suffix-ranks.txt $summary_chrm $summary_plasmid $outdir/contamination_af.txt

echo $contamination_file
grinder -rf $contamination_file -tr 32000 -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder-illumina-contamination-2X -af $outdir/contamination_af.txt 
grinder -rf $contamination_file -tr 200 -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder-pacbio-contamination-0.5X -af $outdir/contamination_af.txt 

cat $outdir/grinder-illumina-$suffix-reads.fastq $outdir/grinder-illumina-contamination-2X-reads.fastq > $outdir/grinder-illumina-with-contamination.fastq 
cat $outdir/grinder-pacbio-5x-$suffix-reads.fastq $outdir/grinder-pacbio-contamination-0.5X-reads.fastq > $outdir/grinder-illumina-with-contamination.fastq 
