import sys 
from Bio import SeqIO 

class Assembly:
	def __init__(self,assembler,index):
		self.assembler = assembler
		self.index=index 
		self.unique_contig=[]
		self.contigs=[]
		self.interspecies_translocation=[]
		
class Contig: 
	def __init__(self,c_id,length):
		self.c_id=c_id 
		self.length=length 
		 
def usage(): 
	print('usage : python3 treat_metaquast.py <outdir> <metaquast dir> <assemblies dir> <summary plasmids tsv file>')

def plasmids_unique_contigs(num_contigs_file): 
	dic={}
	f=open(num_contigs_file,"r") 
	assemblies=f.readline().rstrip().split("\t")[1:] 
	index=1
	list_assemblies=[]
	
	for assembly in assemblies :
		 list_assemblies.append(Assembly(assembly,index))
		 index+=1
	
	for l in f : 
		l_split=l.rstrip().split("\t") 
		for a in list_assemblies : 
			nb_contigs=l_split[a.index]
			plasmid=l_split[0]
			if nb_contigs=='1': 
				a.unique_contig.append(plasmid)   	
	f.close() 	
	return list_assemblies 

def contigs_length(assembly_file,assembly): 
	contigs_list=[]
	for record in SeqIO.parse(assembly_file, "fasta"):
		contig=Contig(record.id,len(record.seq)) 
		assembly.contigs.append(contig) 	

def plasmids_length(summary_plasmids_file): 
	dic={}
	f=open(summary_plasmids_file,'r') 
	f.readline() 
	for l in f :
		l_split=l.rstrip().split("\t") 
		plasmid_id=l_split[1]
		plasmid_length=l_split[3]
		print(plasmid_id,plasmid_length) 
		dic[plasmid_id]=int(plasmid_length) 		 
	f.close() 	
	return dic 
	
def verif_alignment(align_file,cov_thr,assembly,dic_plasmids_length):
	print(assembly.assembler) 
	f=open(align_file,'r') 
	f.readline() 
	for l in f : 
		l_split=l.split("\t") 
		if len(l_split)==9: 
			ab=l_split
		elif len(l_split)==4: 
			info_contig=l_split 
		else : 
			commentary=l.rstrip()  	 	
			if commentary=="interspecies translocation": 
				assembly.interspecies_translocation.append(info_contig[1])   		
			   
	f.close() 
	 						

if len(sys.argv) != 5: 
	usage() 
	exit() 
	
outdir=sys.argv[1]
metaquast_dir=sys.argv[2]
assembly_dir=sys.argv[3]	
summary_plasmids_file=sys.argv[4]

list_assemblies=plasmids_unique_contigs(metaquast_dir+"/summary/TSV/num_contigs.tsv") 
dic_plasmids_length=plasmids_length(summary_plasmids_file) 
print(dic_plasmids_length) 

for a in list_assemblies:
	assembly_subdir=assembly_dir+"/"+a.assembler
	
	if 'spades' in a.assembler: 
		assembly_file=assembly_subdir+"/scaffolds.fasta" 
	else: 
		assembly_file=assembly_subdir+"/final.contigs.fa" 
	
	contigs_length(assembly_file,a)
		
	align_file=metaquast_dir+"/combined_reference/contigs_reports/all_alignments_"+a.assembler+".rev.tsv" 
	verif_alignment(align_file,95,a,dic_plasmids_length) 
	
	print(a.interspecies_translocation) 



