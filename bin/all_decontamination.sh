set -e 

function usage(){
	echo 'usage : bash run_decontamination.sh -f <assembly fasta> -o <outdir>  [options]
	[options] 
	--plasflow <comma-separated list of threshold to test> : launch plasflow decontamination
	--cbar : launch cbar decontamination
	--cbar_plasflow <comma-separated list of plasflow threshold to test>: launch cbar+plasflow decontamination  
	--prefix <prefix for results files> : optional (default : assembly fasta name) 
	-t : number of threads for tools : optional (default : 6) 
	'
}	

function args_gestion(){ 
	if [[ ! $contigs ]]; then 
		quit=1
		echo " ! You must give assembly contigs fasta file (-f)"
	fi
	if [[ ! $outdir ]]; then 
		quit=1
		echo " ! You must give outdir path (-o)"
	fi
	if [[ ! $plasflow_thres ]] && [[ ! $cbar ]] && [[ ! $cbar_plas_thres ]]; then 
		quit=1
		echo " ! You must give at least one decontamination method"
	fi  
	
	if [[ ! $pref ]]; then 
		pref=$(echo $contigs | rev | cut -f 1 -d "/" | cut -f 2- -d "." | rev)
	fi 
	
	if [[ $quit ]]; then 
		usage 
		exit 1 
	fi
}	

function thres_gestion(){ 
	thresholds=$(echo $1 | tr "," " ")  

}	

t=6

TEMP=$(getopt -o h,o:,f:,t: -l chrm_alignment:,plasflow:,cbar,cbar_plasflow:,chrm_db:,prefix:,chrm_rna:,chrm_cont: -- "$@")

eval set -- "$TEMP" 

while true ; do 
	case "$1" in 
		--plasflow)
			plasflow_thres=$2
			shift 2;; 
		--cbar)
			cbar=1
			shift;;	
		--cbar_plasflow)
			cbar_plas_thres=$2
			shift 2;;
		--prefix)
			pref=$2
			shift 2;; 
		-t)
			t=$2 
			shift 2;;
		-h) 
			usage 
			shift ;;
		-o) 
			outdir=$2
			shift 2;;	
		-f) 
			contigs=$2 
			shift 2;; 	
		--)  
			shift ; break ;; 					
	esac 
done


args_gestion
 
bin=$HOME/plasmidome_project/bin 
tmp=`mktemp -d -p .`
mkdir -p $outdir 
~/PlasFlow/filter_sequences_by_length.pl -input $contigs -output $tmp/contigs.1kb.fasta -thres 1000 
contigs=$tmp/contigs.1kb.fasta

if [[ $plasflow_thres ]]; then 
	dir=$outdir/plasflow
	mkdir -p $dir 
	thres_gestion $plasflow_thres 
	count=0
	nb_file=0
	for thr in $thresholds; do 
		thr=$(echo $thr | awk '{print $1/100}') 
		if [[ $(($count%$t)) == 0 ]]; then
			nb_file=$(($nb_file+1)) 
			echo bash $bin/run_plasflow.sh $pref $contigs -o $dir --thres $thr > $tmp/plasflow_commands.$nb_file.txt
			 
		else 
			echo bash $bin/run_plasflow.sh $pref $contigs -o $dir --thres $thr	>> $tmp/plasflow_commands.$nb_file.txt
		fi 	
		count=$(($count+1))
	done 	
	for commands in $(ls $tmp/plasflow_commands.*); do 
		parallel --no-notice < $commands 
	done
	
fi 

if [[ $cbar ]]; then 
	dir=$outdir/cbar 
	mkdir -p $dir 
	bash $bin/run_cbar.sh $pref $contigs -o $dir 
	awk '{if ($3 == "Plasmid") print $1}' $dir/$pref.cbar.prediction.txt > $dir/$pref.cbar.plasmids.txt
	python3 $bin/seq_from_list.py --input_fasta $contigs --keep $dir/$pref.cbar.plasmids.txt --output_fasta $dir/$pref.cbar.plasmids.fasta
fi 

if [[ $cbar_plas_thres ]]; then 
	dir=$outdir/cbar_plasflow 
	mkdir -p $dir 
	thres_gestion $cbar_plas_thres 
	count=0
	nb_file=0
	for thr in $thresholds; do 
		if [[ $(($count%$t)) == 0 ]]; then
			nb_file=$(($nb_file+1)) 
			echo bash $bin/run_cbar_plasflow.sh $thr $dir $pref $contigs > $tmp/cbar_plasflow_commands.$nb_file.txt
			 
		else 
			echo bash $bin/run_cbar_plasflow.sh $thr $dir $pref $contigs >> $tmp/cbar_plasflow_commands.$nb_file.txt	
		fi 	
		count=$(($count+1))
	done 	
	for commands in $(ls $tmp/cbar_plasflow_commands.*); do 
		parallel --no-notice < $commands 
	done 	
fi 

rm -r $tmp 
