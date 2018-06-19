import sys 
from Bio import SeqIO 

def usage():  
	print("usage: python3 delete_seq_from_file.py <input fasta file> <file with seq to delete(txt)> <output fasta file>")

if len(sys.argv) != 4: 
	usage()
	exit()

f=open(sys.argv[2],"r") 
	
list_del=[] 	
test_dic={}
for l in f: 
	list_del.add(l.rstrip()) 
f.close() 	

print(len(list_del)) 
exit() 		
new_records=[]	

output=open(sys.argv[3],"a") 	
for record in SeqIO.parse(sys.argv[1],"fasta"): 
	if record.id not in list_del : 
		SeqIO.write(record,output,"fasta") 

output.close() 		

	
