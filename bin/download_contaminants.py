from Bio import Entrez 
from Bio import SeqIO
import sys 

def usage(): 
	print("usage: python3 download_contaminants.py <bioproject file> <output fasta file>")
	
if len(sys.argv)!=3: 
	usage() 
	exit()
	
f=open(sys.argv[1],"r") 

list_records=[]
Entrez.email="cecile.hilpert@gmail.com" 
count=0
for l in f : 
	accession=l.split("\t")[1]
	handle_search=Entrez.esearch(db="nucleotide",term=accession) 
	record_search=Entrez.read(handle_search)
	records_fasta=[Entrez.efetch(id=i,db="nucleotide",rettype="fasta",retmode="text") for i in record_search["IdList"]]	
	records_seqio=[SeqIO.read(record,"fasta") for record in records_fasta]
	for rec in records_seqio : 
		if 'plasmid' not in rec.description and ("A" in rec.seq or "C" in rec.seq or "T" in rec.seq or "G" in rec.seq): 
			list_records.append(rec) 
	
with open(sys.argv[2],"w") as output_handle : 
   SeqIO.write(list_records,output_handle,"fasta")	
 	
	
