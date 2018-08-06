from Bio import Entrez 
from Bio import SeqIO
import sys 

def usage(): 
	print("usage: python3 download_plasmids.py <RefSeq ID file> <output fasta file>")
	print("INPUT : taxonomy file with first column containing id like : chromosome:NC_012926.1/FM252032.1; plasmid pBM407:NC_012923.1/FM252033.1") 
	print("OUTPUT : fasta file") 
	
if len(sys.argv)!=3: 
	usage() 
	exit()
	
f=open(sys.argv[1],"r") 

list_records=[]
Entrez.email="cecile.hilpert@gmail.com" 
out=open(sys.argv[2],"w") 
count=0 
for l in f : 
	count+=1 
	if count%10==0: 
		print(count)
	accession=[ac.split(":")[1].split("/")[0] for ac in l.split("\t")[0].split(";") if ac.startswith("chromosome")] 
	for ac in accession:  
		handle_search=Entrez.esearch(db="nucleotide",term=ac) 
		record_search=Entrez.read(handle_search)
		records_fasta=[Entrez.efetch(id=i,db="nucleotide",rettype="fasta",retmode="text") for i in record_search["IdList"]]	
		records_seqio=[SeqIO.read(record,"fasta") for record in records_fasta] 
		for rec in records_seqio : 
			if rec.id == ac: 
				SeqIO.write(rec,out,"fasta")	 
out.close()  	
	
