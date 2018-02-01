
# Ftp ncbi Refseq release 86 

db_path = plasmid_db 

cd $db_path 
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.1.1.genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.2.1.genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.3.1.genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/refseq/release/plasmid/plasmid.4.1.genomic.fna.gz
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/plasmids.txt 
