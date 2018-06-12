from Bio import Entrez 
from Bio import SeqIO
import sys 

def usage(): 
	print("usage: python3 download_contaminants_ncbi.py <ncbi browse genome file> <output fasta file>")
	print("Input file is downloaded from https://www.ncbi.nlm.nih.gov/genome/browse#!/overview/") 
	
if len(sys.argv) != 3: 
	usage()
	exit() 
	
f=open(sys.argv[1],"r") 

new_records=[]

Entrez.email="cecile.hilpert@gmail.com" 
count=0
for l in f :
	count+=1
	if (count%10==0): 
		print(count)  
	seq=l.replace('"',"").split(",")[9].split(";")
	chrm = [s.split(":")[1].split("/")[0] for s in seq if 'chromosome' in s] 
	try : 
		handle_search=[Entrez.esearch(db="nucleotide",term=accession) for accession in chrm] 
		for search in handle_search: 
			id_chrm=Entrez.read(search)["IdList"][0]   
			record_fasta=Entrez.efetch(id=id_chrm,db="nucleotide",rettype="fasta",retmode="text")
			record_seqio=SeqIO.read(record_fasta,"fasta")	
			new_records.append(record_seqio) 
	except : 
		continue 		
f.close() 		
		
with open(sys.argv[2],"w") as output_handle: 
	SeqIO.write(new_records,output_handle,"fasta") 		
	 
 
	 	
