set -e 

function usage(){
	echo 'usage : run_assembly_evaluation.sh <outdir> <reference file> <suffix simulated reads>' 
}

if [ "$#" -ne 3 ]
then 
	usage 
	exit 1 
fi


outdir=$1
ref_file=$2
suffix=$3


mkdir -p $outdir


 	

#generate Illumina reads, with no errors and no chimeras 
grinder -rf $ref_file -cf 20 -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder-illumina-$suffix -am powerlaw 0.1 

#Generate abundance file for Pacbio
cut -f 2,3 $outdir/grinder-illumina-$suffix-ranks.txt | tail -n +2 > $outdir/grinder-illumina-$suffix-af.txt
af=$outdir/grinder-illumina-$suffix-af.txt

#generate PacBio reads, with no errors and no chimeras, 5x coverage 
grinder -rf $ref_file -cf 5 -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder-pacbio-5x-$suffix -am powerlaw 0.1 -af $af  
