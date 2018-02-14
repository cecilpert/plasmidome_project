from Bio import Entrez 
from Bio import SeqIO
import sys 

def usage(): 
	print("usage : python3 seq_download_from_ncbi.py <file_with_accession_numbers> <out_fasta_file> <out_stats_file>") 
	
if len(sys.argv)!=4 : 
	usage()
	exit() 

list_acc=sys.argv[1]
out_fasta=sys.argv[2]
#out_fasta_dir=sys.argv[3]
out_stats=sys.argv[3]

Entrez.email = "cecile.hilpert@gmail.com"

list_acc_f=open(list_acc,"r")
out_stats_f=open(out_stats,"w")
out_stats_f.write("id\tdesc\tlength\n")  
list_records=[]
for l in list_acc_f: 
   print(l)
   handle = Entrez.efetch(db="nucleotide",id=l.rstrip(),rettype="fasta",retmode="text")
   rec=SeqIO.read(handle,"fasta")
   out_stats_f.write(rec.id+"\t"+rec.description+"\t"+str(len(rec.seq))+"\n") 
   list_records.append(rec)
   handle.close()
    
with open(out_fasta,"w") as output_handle : 
   SeqIO.write(list_records,output_handle,"fasta") 

out_stats_f.close() 
