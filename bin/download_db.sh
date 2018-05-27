set -e 

function usage(){
	echo 'Download all gbff files from plasmid RefSeq database
	== usage : download_db.sh [options]    
	[options] : 
	-o outdir (default : plasmid_db)' 
}

TEMP=$(getopt -o o:,h -- "$@")

eval set -- "$TEMP" 

outdir=plasmid_db

while true ; do 
	echo $1 
	case "$1" in 
		-o) 
			outdir=$2 
			shift 2;; 		
		-h) 
			usage
			exit 1 
			shift ;;	
		--)  
			shift ; break ;; 					
	esac 
done 	

mkdir -p $outdir 

wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.1.genomic.gbff.gz -O $outdir/plasmid.1.genomic.gbff.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.2.genomic.gbff.gz -O $outdir/plasmid.2.genomic.gbff.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.3.genomic.gbff.gz -O $outdir/plasmid.3.genomic.gbff.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.4.genomic.gbff.gz -O $outdir/plasmid.4.genomic.gbff.gz

gunzip $outdir/plasmid.1.genomic.gbff.gz 
gunzip $outdir/plasmid.2.genomic.gbff.gz
gunzip $outdir/plasmid.3.genomic.gbff.gz
gunzip $outdir/plasmid.4.genomic.gbff.gz
