import random 
from Bio import Entrez 
from Bio import SeqIO
import sys  

def usage(): 
	print("usage: python3 select_plasmids.py <summary_tsv_file> <out_prefix>")
	print("Download specie non redondant sequences from a summary file. The file must be tab-separated, with id in first column, sequence description in second column and species in third column. More columns can be add if you want.") 
	print("This script choose randomly one sequence per species.") 

if len(sys.argv)!=3: 
	usage() 
	exit()
	
f=sys.argv[1]
out_prefix=sys.argv[2]	
f=open(f,"r") 
out=open(out_prefix+".tsv","w") 

dic={}
for l in f : 
	l_split=l.rstrip().split("\t") 
	id=l_split[0]
	desc=l_split[1]
	specie=l_split[8]
	if specie in dic : 
		dic[specie].append((id,desc))
	else: 
		dic[specie]=[(id,desc)] 

Entrez.email="cecile.hilpert@gmail.com" 
list_records=[]
for sp in dic : 
	choose=random.choice(dic[sp]) 
	out.write(choose[0]+"\t"+choose[1]+"\t"+sp+"\n")
	try : 
		handle = Entrez.efetch(db="nucleotide",id=choose[0],rettype="fasta",retmode="text")	
	except : 
		continue 
	rec=SeqIO.read(handle,"fasta")
	list_records.append(rec)
	handle.close() 

with open(out_prefix+".fasta","w") as output_handle : 
   SeqIO.write(list_records,output_handle,"fasta") 			
		 
out.close() 
