from Bio import SeqIO
from ete3 import NCBITaxa 
import sys 
import random 

def usage(): 
	print("Retrieve taxonomic levels from one or more genbank files.") 
	print("---")
	print("usage: python3 plasmids_taxonomy.py <plasmids txt file> <out_summary_file>")
	print("---") 
	print("INPUT : plasmids tsv file, with organism name in first column and ID in second column") 
	print("OUTPUT : ")

if len(sys.argv)!=3: 
	usage() 
	exit()
	
ncbi = NCBITaxa()	

f=open(sys.argv[1],"r") 

out=open(sys.argv[2],"w") 
out.write("id\torganism name\tkingdom\tphylum\tclass\torder\tfamily\tgenus\tspecie\n")

dic={}
f.readline() 
for l in f: 
	org_name=l.rstrip().split("\t")[0]
	id=l.rstrip().split("\t")[1]
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
		dic[species].append(id) 
	else: 
		dic[species]=[id] 	  	
	out.write(id+"\t"+org_name+"\t"+kingdom+"\t"+phylum+"\t"+classe+"\t"+order+"\t"+family+"\t"+genus+"\t"+species+"\n")  		 	
	
	



			
		
