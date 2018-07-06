from Bio import SeqIO 
import sys 

def usage(): 
	print("usage: python3 seq_from_list.py <input fasta file> <file with seq to keep(txt)> <output fasta file>")
	print("Keep only seq with id present in file and write it in output")
	print("INPUT : (1) fasta file where seq to keep are present. (2) File with only id of seq to keep") 
	print("OUTPUT : fasta file with only seq to keep")   
	
def give_list_id(f):  
	f=open(f,"r") 
	list_id=[]
	for l in f : 
		list_id.append(l.rstrip()) 
	f.close() 
	return list_id	
	
if len(sys.argv) != 4: 
	usage()
	exit() 
	 	
list_id=give_list_id(sys.argv[2])	
output=open(sys.argv[3],"w") 
	
new_records=[]	
for record in SeqIO.parse(sys.argv[1],"fasta"):  
	if record.id in list_id:
		SeqIO.write(record,output,"fasta")  		

output.close() 
	
