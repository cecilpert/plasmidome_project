import sys 
from Bio import SeqIO 

def usage(): 
	print('usage : python3 total_length_contig_list.py <file with contig names> <fasta contigs>')
	
def generate_list_contigs(f_name): 
	f=open(f_name,"r")
	list_contigs=set() 
	for l in f :  	
		list_contigs.add(l.rstrip().split(" ")[0])  
	return list_contigs 	

def generate_total_length(list_contigs,fasta):
	length=0
	for record in SeqIO.parse(fasta,"fasta"):  
		desc="_".join(record.description.split(" ")).replace("=","_")  
		if desc in list_contigs : 
			length+=len(record.seq)
	return length		
			
				
if len(sys.argv) != 3: 
	usage() 
	exit() 	
	
list_contigs=generate_list_contigs(sys.argv[1]) 
print(generate_total_length(list_contigs,sys.argv[2]))	
	
