set -e 

function usage(){
	echo 'usage : simulate_reads.sh <input.fasta> [options]    
	[options] : 
	-o outdir (default : .)  
	--pacbio coverage_value : generate pacbio simulation (error free, 6kb).  
	--illumina coverage_value : generate illumina simulation (error free, 2x150kb, insert 350)   
	--ab_file : abundance file for each species in simulated reads  
	--diversity : value of powerlaw for diversity (default : 0.1)
	--contamination : contamination level (between 0 and 1)  
	--contamination_f : fasta file with contaminants (required if --contamination) 
	--ab_file_cont : abundance for each contaminants 
	' 
}

outdir=. 
ILLUMINA=0
PACBIO=0  
diversity=0.1

TEMP=$(getopt -o o:,h -l illumina:,pacbio:,ab_file:,diversity:,contamination:,contamination_f:,ab_file_cont: -- "$@")

eval set -- "$TEMP" 

while true ; do 
	case "$1" in  
		-o)	
			outdir=$2 
			shift 2;; 
		--illumina)
			ILLUMINA=1
			coverage_illumina=$2
			shift 2;; 
		--pacbio) 	
			PACBIO=1 
			coverage_pacbio=$2
			shift 2 ;; 
		--ab_file) 
			ab_file=$2
			shift 2 ;; 	
		--diversity)
			diversity=$2 
			shift 2 ;; 
		--contamination)
			contamination=$2
			shift 2 ;; 
		--contamination_f) 
			contamination_f=$2	
			shift 2 ;; 
		--ab_file_cont) 
			ab_file_cont=$2	
			shift 2 ;;
		-h) 
			usage
			exit 0;;	
		--)  
			shift ; break ;; 					
	esac 
done 	


if [ "$#" -ne 1 ]
then 
	usage
	echo 'give input.fasta'  
	exit 1 
fi


if [ $ILLUMINA -eq 0 ] && [ $PACBIO -eq 0 ] 
then  
	usage 
	echo 'you must select --pacbio and/or --illumina' 
	exit 1 
fi 	

if [ $contamination ] && [ ! $contamination_f ]
then 
	usage
	echo "you must give fasta contaminants file" 
	exit 1 
fi 	

input=$1
mkdir -p $outdir

if [ $ILLUMINA -eq 1 ]; then 
	if [[ -f $outdir/grinder-illumina-$coverage_illumina\X-am$diversity\-reads.fastq ]]; then 
		echo "Simulated illumina read files already exists" 
	else
		if [[ $ab_file ]]; then 
			grinder -rf $input -cf $coverage_illumina -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder-illumina-$coverage_illumina\X-am$diversity -af $ab_file 
		else 
			grinder -rf $input -cf $coverage_illumina -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder-illumina-$coverage_illumina\X-am$diversity -am powerlaw $diversity
			tail -n +2 $outdir/grinder-illumina-$coverage_illumina\X-am$diversity\-ranks.txt | cut -f 2- > $outdir/af$diversity.txt
			ab_file=$outdir/af$diversity.txt
		fi 	  		
	fi 	
	if [[ $contamination ]]; then
		read=`grep "^@" -c $outdir/grinder-illumina-$coverage_illumina\X-am$diversity-reads.fastq`
		read_cont=$(echo $read $contamination | awk '{printf "%i\n",$1*$2}')
		if [[ $ab_file_cont ]]; then 
			grinder -rf $contamination_f -tr $read_cont -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder-illumina$coverage_illumina\-contamination-$contamination -af $ab_file_cont 
		else 
			grinder -rf $contamination_f -tr $read_cont -rd 150 -id 350 -fq 1 -ql 30 10 -od $outdir -bn grinder-illumina$coverage_illumina\-contamination-$contamination -am powerlaw $diversity  
			tail -n +2 $outdir/grinder-illumina$coverage_illumina-contamination-$contamination\-ranks.txt | cut -f 2- > $outdir/af_cont$diversity.txt
			ab_file_cont=$outdir/af_cont$diversity.txt
		fi
	fi
fi 	
	
	
if [ $PACBIO -eq 1 ]; then 
	if [[ -f $outdir/grinder-pacbio-$coverage_pacbio\X-am$diversity\-reads.fastq ]]; then 
		echo "Simulated pacbio read files already exists" 	
	else
		if [[ $ab_file ]]; then 
			grinder -rf $input -cf $coverage_pacbio -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder-pacbio-$coverage_pacbio\X-am$diversity -af $ab_file 
		else 
			grinder -rf $input -cf $coverage_pacbio -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder-pacbio-$coverage_pacbio\Xam$diversity -am powerlaw $diversity
		fi 	 		
	fi 
	
	if [[ $contamination ]]; then
		read=`grep "^@" -c $outdir/grinder-pacbio-$coverage_pacbio\X-am$diversity-reads.fastq`
		read_cont=$(echo $read $contamination | awk '{printf "%d\n",$1*$2}')
		if [[ $ab_file_cont ]]; then 
			grinder -rf $contamination_f -tr $read_cont -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder-pacbio-contamination-$contamination -af $ab_file_cont 
		else 
			grinder -rf $contamination_f -tr $read_cont -rd 6000 -fq 1 -ql 30 10 -od $outdir -bn grinder-pacbio-contamination-$contamination -am powerlaw $diversity  
		fi
	fi
fi 	 	
