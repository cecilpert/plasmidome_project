from Bio import Entrez 
from Bio import SeqIO
import sys 

list_acc=sys.argv[1]
out_fasta=sys.argv[2]
out_fasta_dir=sys.argv[3]

Entrez.email = "cecile.hilpert@gmail.com"

list_acc_f=open(list_acc,"r") 
list_records=[]
for l in list_acc_f: 
   print(l)
   handle = Entrez.efetch(db="nucleotide",id=l.rstrip(),rettype="fasta",retmode="text")
   list_records.append(SeqIO.read(handle,"fasta"))
   handle.close()
    
with open(out_fasta,"w") as output_handle : 
   SeqIO.write(list_records,output_handle,"fasta") 

for record in list_records : 
   with(open(out_fasta_dir+'/'+record.id+".fasta",'w')) as output_handle: 
      SeqIO.write(record,output_handle,"fasta") 
