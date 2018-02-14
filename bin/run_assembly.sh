set -e 

TEMP=$(getopt -o h,o:,i:,l: -l megahit,metaspades,contamination,hybridspades -- "$@")

eval set -- "$TEMP" 

outdir=results/assembly 
MEGAHIT=0
METASPADES=0
HYBRIDSPADES=0
CONTAMINATION=0

while true ; do 
	case "$1" in 
		--megahit)
			MEGAHIT=1  
			shift;; 
		--metaspades)
			METASPADES=1
			shift ;; 	
		--hybridspades) 
			HYBRIDSPADES=1
			shift ;; 	
		-h) 
			echo "help" 
			shift ;;
		-o) 
			outdir=$2
			shift 2;;	
		-i) 
			input_fq=$2 
			shift 2;; 	
		-l) 
			input_pacbio=$2
			shift 2;;
		--)  
			shift ; break ;; 					
	esac 
done 	

mkdir -p $outdir 

if [ $MEGAHIT == 1 ]; then 
	echo "MEGAHIT"
	megahit --12 $input_fq -t 6 -o $outdir/megahit 
fi 	

if [ $METASPADES == 1 ]; then 
	echo "METASPADES"  
	mkdir -p $outdir/metaspades 
	/usr/local/SPAdes-3.9.0-Linux/bin/spades.py -o $outdir/metaspades --12 $input_fq --only-assembler -t 6 --meta 
fi 	

if [ $HYBRIDSPADES == 1 ]; then 
	echo "HYBRIDSPADES"  
	mkdir -p $outdir/hybridspades 
	/usr/local/SPAdes-3.9.0-Linux/bin/spades.py -o $outdir/hybridspades --12 $input_fq --only-assembler -t 6 --pacbio $input_pacbio 
fi 	
