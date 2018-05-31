from Bio import SeqIO
from ete3 import NCBITaxa 
import sys 
import random 

def usage(): 
	print("Retrieve taxonomic levels from one or more genbank files.") 
	print("---" 
	print("usage: python3 plasmids_taxonomy.py <gb_file_1> <gb_file_2> .... <gb_file_n> <out_summary_file>")
	print("---") 

if len(sys.argv)==1: 
	usage() 
	exit()
	
ncbi = NCBITaxa()	

files = sys.argv[1:]
outfile=sys.argv[-1]

out=open(outfile,"w") 
out.write("id\tdescription\tkingdom\tphylum\tclass\torder\tfamily\tgenus\tspecie\n")

dic={}
for f in files: 
	print(f)
	for record in SeqIO.parse(f,"genbank"): 
		org_name=record.annotations["organism"] 
		kingdom="-"
		phylum="-"
		species="-" 
		classe="-"
		order="-"
		family="-"
		genus="-"
		try : 
			taxid=ncbi.get_name_translator([org_name])[org_name]
		except : 
			continue 
		lineage=ncbi.get_lineage(taxid[0]) 
		ranks=ncbi.get_rank(lineage) 
		for r in ranks : 
			if ranks[r]=="superkingdom": 
				kingdom=ncbi.get_taxid_translator([r])[r] 
			elif ranks[r]=="phylum": 
				phylum=ncbi.get_taxid_translator([r])[r]	
			elif ranks[r]=="species": 
				species=ncbi.get_taxid_translator([r])[r]	
				species=species.replace("'","").replace("#","") 
			elif ranks[r]=="class": 
				classe=ncbi.get_taxid_translator([r])[r]
			elif ranks[r]=="order": 
				order=ncbi.get_taxid_translator([r])[r]
			elif ranks[r]=="family": 
				family=ncbi.get_taxid_translator([r])[r]
			elif ranks[r]=="genus":
				genus=ncbi.get_taxid_translator([r])[r]
		if species in dic : 
			dic[species].append(record.id) 
		else: 
			dic[species]=[record.id] 	
		
		desc=record.description.replace("'","").replace("#","")  		
		out.write(record.id+"\t"+desc+"\t"+kingdom+"\t"+phylum+"\t"+classe+"\t"+order+"\t"+family+"\t"+genus+"\t"+species+"\n")  		 	
	
	



			
		
