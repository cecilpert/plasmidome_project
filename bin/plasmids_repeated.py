import sys 
from Bio import SeqIO 

def determine_duplicated(blast_f):
	already_treated = set() 
	to_delete = []
	dic_same = {}
	for line in blast_f: 
		line_split=line.split("\t") 
		qid = line_split[0]
		sid = line_split[1]
		ident = line_split[2]
		qlen = line_split[3]
		slen = line_split[4]
		alen = line_split[5] 
		if qid != sid and float(ident)==100 and qlen == slen == alen : 
			if qid not in already_treated: 
				to_delete.append(sid)
				if qid not in dic_same : 
					dic_same[qid]=[sid]
				else : 
					dic_same[qid].append(sid) 
				already_treated.add(sid) 
	return dic_same,to_delete 	

def delete_duplicates(old_fasta,new_fasta,to_delete): 
	new_records=[]
	for record in SeqIO.parse(old_fasta,"fasta"): 
		if record.id not in to_delete: 
			new_records.append(record)
	with open(new_fasta,"w") as output_handle : 
		SeqIO.write(new_records,output_handle,"fasta") 

blast=sys.argv[1] 
old_fasta=sys.argv[2]
new_fasta=sys.argv[3]
blast_f = open(blast,"r") 

dic_same,to_delete=determine_duplicated(blast_f) 
print(to_delete,len(to_delete))
delete_duplicates(old_fasta,new_fasta,to_delete) 
blast_f.close() 



				
