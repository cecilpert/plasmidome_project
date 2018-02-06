set -e 

outdir=$1
db_dir=$2
mode=$3 

mkdir -p $outdir


if [ "$mode" == "test" ] 
then
        echo "test" 
	ref_file=$db_dir/plasmid148_test.fasta  
else
	ref_file=$db_dir/plasmid148.fasta  
fi 	

#generate Illumina reads, with no errors and no chimeras 
grinder -rf $ref_file -cf 20 -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder_simulated_illumina  

#generate PacBio reads, with no errors and no chimeras, 5x coverage 
grinder -rf $ref_file -cf 5 -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder_simulated_pacbio  
