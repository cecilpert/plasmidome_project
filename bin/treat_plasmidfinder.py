from Bio import SeqIO 
from Bio.Blast import NCBIXML
import sys 

def usage(): 
	print("python3 treat_plasmidfinder.py <xml blast file> <outdir> <prefix> <mode>")
	print("<mode> : blastn or tblastx")  
	
if len(sys.argv)!=5: 
	usage() 
	exit() 	

mode=sys.argv[4]
result_handle = open(sys.argv[1])

plasmids=set() 
chrm=set() 

count=0

if mode=="blastn" or mode == "blastx":
	mult=1
elif mode=="tblastx": 
	mult=3
else: 
	usage() 
	print("<mode> must be blastn or tblastx") 
	exit() 		

for record in NCBIXML.parse(result_handle): 
	count+=1
	if len(record.alignments)!=0: 
		for align in record.alignments: 
			for hsp in align.hsps: 
				percent_ident=hsp.identities/hsp.align_length
				coverage=(hsp.align_length*mult)/align.length 
				if percent_ident >= 0.8 and coverage >= 0.6 : 
					#print(record.query,percent_ident,coverage) 
					plasmids.add(record.query)
				else: 
					chrm.add(record.query) 
	else: 
		chrm.add(record.query) 					 
				
plasmids=list(plasmids) 
outplas=sys.argv[2]+"/"+sys.argv[3]+"_predicted_plasmids.txt" 
outchrm=sys.argv[2]+"/"+sys.argv[3]+"_predicted_not_plasmids.txt" 

with open(outplas,"w") as output_handle: 
	output_handle.write("\n".join(plasmids)) 
	
with open(outchrm,"w") as output_handle: 
	output_handle.write("\n".join(chrm)) 	
	
	
	
	
				
			 
