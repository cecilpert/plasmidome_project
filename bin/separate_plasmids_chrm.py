import os 
import sys 
from Bio import SeqIO

def usage(): 
	print('usage : python3 separate_plasmids_chrm.py <genomes directory> <outdir> <execution mode>')

def separate(outfile,outfile2): 
	dic_summary={}
	out_plasmid=open(outfile,"w") 
	out_chrm=open(outfile2,"w")
	out_plasmid.write("#gcf_number\tplasmid_id\tplasmid_description\tplasmid_length\n") 
	out_chrm.write("#gcf_number\tchrm_id\tchrm_description\tchrm_length\n") 	
	for f in os.listdir(genome_directory): 
		if f.endswith(".fna"): 
			gcf_number=f.split("_genomic")[0]
			dic_summary[gcf_number]={"chrm":[],"plasmids":[]}
			for record in SeqIO.parse(genome_directory+"/"+f,"fasta"): 
				if "complete genome" in record.description or "chromosome" in record.description: 
					out_chrm.write(gcf_number+"\t"+record.id+"\t"+record.description+"\t"+str(len(record.seq))+"\n")  
					dic_summary[gcf_number]["chrm"].append(record)
				elif "plasmid" in record.description: 
					out_plasmid.write(gcf_number+"\t"+record.id+"\t"+record.description+"\t"+str(len(record.seq))+"\n") 
					dic_summary[gcf_number]["plasmids"].append(record)
	out_plasmid.close()
	out_chrm.close() 
	return dic_summary		
	
	
def write_fastas(outdir,dic_summary,mode,plasmids_dir):
	if mode == "test": 
		selected_gcf=["GCF_000011805.1_ASM1180v1", "GCF_000008865.1_ASM886v1", "GCF_000006945.2_ASM694v2","GCF_000014525.1_ASM1452v1", "GCF_000006925.2_ASM692v2"]
		suffix_file="_test" 
	else: 
		selected_gcf=list(dic_summary.keys()) 
		suffix_file=""
	to_write_plasmids=[]
	to_write_chrm=[]	
	for gcf in selected_gcf : 
		for chrm in dic_summary[gcf]["chrm"]: 
			to_write_chrm.append(chrm)
		for plasmid in dic_summary[gcf]["plasmids"]: 
			to_write_plasmids.append(plasmid)	
			with open(plasmids_dir+"/"+plasmid.id+".fasta","w") as output: 
				SeqIO.write(plasmid,output,"fasta") 	
		
	with open(outdir+"/plasmids"+suffix_file+".fasta", "w") as output_handle:
		SeqIO.write(to_write_plasmids, output_handle, "fasta")
	with open(outdir+"/bacteria_chrm"+suffix_file+".fasta", "w") as output_handle: 
		SeqIO.write(to_write_chrm, output_handle, "fasta") 			
	 
if len(sys.argv) != 4: 
	usage() 
	exit() 
	
genome_directory=sys.argv[1]	
outdir=sys.argv[2]
mode=sys.argv[3]

dic_summary=separate(outdir+"/summary_plasmids.tsv",outdir+"/summary_chrm.tsv")
write_fastas(outdir,dic_summary,mode,outdir+"/plasmid_sequences") 


 	


