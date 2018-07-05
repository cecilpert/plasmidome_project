# Plasmidome project 

## How to launch analysis ? 

### Construct databases  

#### Plasmid databases 

To construct plasmid database you have to launch `bash bin/construct_database.sh -o <outdir> --plasmid`
This script download plasmids summary files from NCBI ftp (ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/plasmids.txt), construct taxonomy for each plasmid (`plasmids_taxonomy.py`, using ete3 module), keep one plasmid per specie and download this plasmids (`download_plasmids.py`) 

# Requirements 
To launch all steps you will need : 
* [ete3](http://etetoolkit.org/)
* [BioPython](https://biopython.org/)
