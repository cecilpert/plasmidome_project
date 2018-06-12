set -e 

files_prok="00 01 02 03 04 05 06 07 08 09 10" 

for num in $files_prok; do 
	echo "Prokaryotes$num" 
	python3 bin/download_contaminants_ncbi.py contaminants_db/prokaryotes.nohead.ftp.csv$num contaminants_db/prokaryotes.$num.fasta 
done 

echo "Eukaryotes"
python3 bin/download_contaminants_ncbi.py contaminants_db/eukaryotes.nohead.ftp.csv contaminants_db/eukaryotes.fasta 



