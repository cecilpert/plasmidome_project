from Bio import SeqIO 
import sys 

def usage(): 
	print("usage: python3 seq_from_list.py <input fasta file> <file with seq to keep(txt)> <output fasta file> <assembly type>")
	print("Keep only seq with id present in file and write it in output")

def give_list_id_megahit_blast(f): 
	f=open(f,"r") 
	list_id=[]
	for l in f : 
		list_id.append(l.rstrip().split(" ")[0])
	f.close() 
	return list_id
	
def give_list_id_megahit(f): 
	f=open(f,"r") 
	list_id=[]
	for l in f : 
		list_id.append("_".join(l.rstrip().split("_")[:2])) 
	f.close() 
	return list_id	
	
def give_list_id_unicycler(f): 
	f=open(f,"r") 
	list_id=[]
	for l in f : 
		list_id.append(l.split("_")[0]) 
	f.close() 
	return list_id	 
	
def give_list_id_classic(f):  
	f=open(f,"r") 
	list_id=[]
	for l in f : 
		list_id.append(l.rstrip()) 
	f.close() 
	return list_id	
	
if len(sys.argv) != 5: 
	usage()
	exit() 
	  		
assembly_type=sys.argv[4]

if(assembly_type=="megahit"): 
	list_id=give_list_id_megahit(sys.argv[2])		
elif(assembly_type=="unicycler"): 
	list_id=give_list_id_unicycler(sys.argv[2])	
elif(assembly_type=="megahit_blast"): 
	list_id=give_list_id_megahit_blast(sys.argv[2])	
else: 
	list_id=give_list_id_classic(sys.argv[2])	
	
new_records=[]	
for record in SeqIO.parse(sys.argv[1],"fasta"):  
	if record.id in list_id:
		new_records.append(record) 		

with open(sys.argv[3],"w") as output_handle: 
	SeqIO.write(new_records,output_handle,"fasta") 

	
