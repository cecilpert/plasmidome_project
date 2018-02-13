import os 
import sys 
from Bio import SeqIO

def usage(): 
	print('usage : python3 separate_plasmids_chrm.py <genomes directory> <plasmids fasta file> <chromosomes fasta file> <summary tsv file> <execution mode>')

def separate(outfile): 
	chrm_records=[]
	plasmid_records=[]
	dic_summary={}
	out=open(outfile,"w") 
	out.write("plasmid_id\tplasmid length\tchromosome_id\tfile\n") 	
	for f in os.listdir(genome_directory): 
		if f.endswith(".fna"): 
			for record in SeqIO.parse(genome_directory+"/"+f,"fasta"): 
				if "complete genome" in record.description or "chromosome" in record.description: 
					chrm_records.append(record) 
					current_chrm=record.id
				elif "plasmid" in record.description: 
					plasmid_records.append(record) 
					out.write(record.id+"\t"+str(len(record.seq))+"\t"+current_chrm+"\t"+f+"\n") 
					dic_summary[record.id]=current_chrm 
	out.close() 
	return chrm_records,plasmid_records,dic_summary				
	
	
def write_fastas(plasmid_fasta,chrm_fasta,mode,summary,plasmid_rec,chrm_rec):
	if mode == "test":
		nbre_plasmids=15  
		keep_chrm=set()
		for rec in plasmid_rec[:nbre_plasmids]: 
			keep_chrm.add(summary[rec.id]) 
		nbre_chrm=len(keep_chrm)
	else : 
		nbre_plasmids=len(plasmid_rec) 
		nbre_chrm=len(chrm_rec) 	
			
	with open(plasmid_fasta, "w") as output_handle:
		SeqIO.write(plasmid_rec[:nbre_plasmids], output_handle, "fasta")
	with open(chrm_fasta, "w") as output_handle: 
		SeqIO.write(chrm_rec[:nbre_chrm], output_handle, "fasta") 	
		
				
	 
if len(sys.argv) != 6: 
	usage() 
	exit() 
	
genome_directory=sys.argv[1]	
plasmid_fasta=sys.argv[2]
chrm_fasta=sys.argv[3]
summary_file=sys.argv[4]
mode=sys.argv[5]

chrm_records,plasmid_records,summary=separate(summary_file)
write_fastas(plasmid_fasta,chrm_fasta,mode,summary,plasmid_records,chrm_records) 


 	


