set -e 

#mkdir -p plasmid_db 
cd plasmid_db 
 
#sh ../pre_treatment/download_db.sh

cd .. 

# Delete Eukaryota and Archaea plasmids in list 
mkdir -p tmp 
sed '/Eukaryota/d' plasmid_db/plasmids.txt > tmp/tmp_plasmid_list.txt
sed '/Archaea/d' tmp/tmp_plasmid_list.txt > plasmid_db/bacteria_plasmids.txt 

# Select one plasmid per specie 

python3 pre_treatment/treat_plasmid_list.py plasmid_db/bacteria_plasmids.txt plasmid_db/selected_plasmids.txt   
