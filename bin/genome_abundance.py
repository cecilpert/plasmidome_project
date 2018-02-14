import sys 

def usage(): 
	print('usage : python3 contamination_abundance.py <plasmids ranks abundance file> <summary chrm file> <summary plasmid file> <genomes ranks abundance file (output)>')

			
def dic_plasmid_chrm(summary_chrm,summary_plasmid): 
	dic={}
	dic_plasmid={}
	f_chrm=open(summary_chrm,"r") 
	f_plas=open(summary_plasmid,"r") 
	for l in f_chrm : 
		if not l.startswith('#'): 
			l_split=l.split("\t") 
			gcf=l_split[0]
			chrm_id=l_split[1]
			if gcf in dic: 
				dic[gcf].append(chrm_id) 
			else: 
				dic[gcf]=[chrm_id]			
	f_chrm.close()	 		
	for l in f_plas: 
		if not l.startswith('#'): 
			l_split=l.split("\t") 
			gcf=l_split[0]
			plasmid_id=l_split[1]
			dic_plasmid[plasmid_id]=gcf
	f_plas.close() 		
	return dic,dic_plasmid 		
		
		
def create_abundance_dic(chrm_dic,plas_dic,plasmid_ranks): 
	f=open(plasmid_ranks,"r") 
	dic_ab={}
	ab=0
	for l in f : 
		if not l.startswith("#"): 
			l_split=l.split("\t") 
			p_id=l_split[1]
			abundance=float(l_split[2])
			ab=ab+abundance
			gcf=plas_dic[p_id] 
			
			for chrm_id in chrm_dic[gcf]: 
				if chrm_id in dic_ab: 
					dic_ab[chrm_id]=dic_ab[chrm_id]+(abundance/len(chrm_dic[gcf]))  
				else: 
					dic_ab[chrm_id]=abundance/len(chrm_dic[gcf]) 
				 
	return dic_ab 					
	f.close() 	

def write_abundance_file(abundance_dic,outfile): 
	with open(outfile,"w") as out : 
		for genome in abundance_dic: 
			out.write(genome+"\t"+str(abundance_dic[genome])+"\n") 
			
if len(sys.argv) != 5: 
	usage() 
	exit() 		

plasmid_ranks = sys.argv[1]
summary_chrm = sys.argv[2]
summary_plasmid = sys.argv[3]
outfile = sys.argv[4]

chrm_dic,plasmid_dic=dic_plasmid_chrm(summary_chrm,summary_plasmid)
dic_ab=create_abundance_dic(chrm_dic,plasmid_dic,plasmid_ranks) 
write_abundance_file(dic_ab,outfile) 




