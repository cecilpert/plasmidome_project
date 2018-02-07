set -e 

outdir=$1
db_dir=$2
suffix=$3
mode=$4

mkdir -p $outdir/simulated_reads
res_dir=$outdir/simulated_reads


if [ $mode == "test" ] 
then
        echo "test" 
	ref_file=$db_dir/plasmid148_test.fasta  
else
        echo "no test" 
	ref_file=$db_dir/plasmid148.fasta  
fi 	

#generate Illumina reads, with no errors and no chimeras 
grinder -rf $ref_file -cf 20 -rd 150 -id 350 -fq 1 -ql 30 10 -od $res_dir -bn grinder-illumina-20x-$suffix -am powerlaw 0.1 

#generate PacBio reads, with no errors and no chimeras, 5x coverage 
grinder -rf $ref_file -cf 5 -rd 6000 -fq 1 -ql 30 10 -od $res_dir -bn grinder-pacbio-5x-$suffix -am powerlaw 0.1  
