import sys 

def usage(): 
	print('usage : python3 treat_metaquast.py <outdir> <summary plasmids tsv file> <names of assemblies> <contamination> <SR coverage> <LR coverage> <mode>')

class Assembly:
	def __init__(self,assembler,plasmids_dic,contamination,SR_coverage,LR_coverage):
		self.assembler=assembler
		self.contigs=[]
		self.plasmids=plasmids_dic
		self.contamination=contamination
		self.SR_coverage=SR_coverage
		self.LR_coverage=LR_coverage
		
class Contig : 
	def __init__(self,name,length,status): 
		self.name=name 
		self.length=length
		self.status=status
		self.commentary="-"
		self.bases_aligned=set() 
		self.plasmids=set()  
		self.aligned="aligned" 

class Plasmid: 	
	def __init__(self,name,length,length_cat): 
		self.name=name 
		self.length=length 
		self.length_cat=length_cat 
		self.bases_aligned=set() 
		self.contigs=set() 		
		self.complete=False 	
		 	
		
def give_list_base_aligned(start,end):
	if start < end : 
		list_base_aligned=set(range(start,end+1)) 
	else : 
		list_base_aligned=set(range(end,start+1))	
	
	return list_base_aligned		

def treat_contigs(f,cont): 
	f=open(f,"r") 
	for l in f : 
		l_split=l.rstrip().split("\t")
		if l.startswith("CONTIG"):
			status=l_split[3] 
			if status != "correct" and status != "ambiguous" and status != "misassembled" and status != "unaligned" :  
				status="others" 
			if status == "unaligned" and l_split[1] in cont:
				status="contamination" 	
			c=Contig(l_split[1],int(l_split[2]),status) 
			a.contigs.append(c) 
			last_contig=a.contigs[-1]
		elif len(l_split)==9:
			start=int(l_split[2])
			end=int(l_split[3]) 
			current_base_aligned=give_list_base_aligned(start,end) 
			last_contig.bases_aligned.update(current_base_aligned) 
				
			plasmid=l_split[4].split("_") 	
			id_p="_".join(plasmid[:2])
			last_contig.plasmids.add(id_p) 
			
			name_p=" ".join(plasmid[4:])
			start_p=int(l_split[0]) 
			end_p=int(l_split[1]) 		
			current_base_aligned_p=give_list_base_aligned(start_p,end_p) 
			
			if last_contig.status=="correct" or last_contig.status=="ambiguous": 
				a.plasmids[id_p].bases_aligned.update(current_base_aligned_p) 
				a.plasmids[id_p].contigs.add(last_contig) 

		else: 
			last_contig.commentary=l.rstrip() 	

def give_list_contamination(f): 
	f=open(f,"r") 
	list_cont=set() 
	for l in f : 
		if l.startswith("CONTIG") and l.rstrip().split("\t")[3]!="unaligned": 
			list_cont.add(l.rstrip().split("\t")[1])
	return list_cont 													
			
def initialize_plasmids(summary): 
	f=open(summary,"r") 
	dic_p={}
	total_length=0
	f.readline() 
	for l in f:  
		l_split=l.rstrip().split("\t") 
		id_p=l_split[0]
		p=Plasmid(id_p,int(l_split[-2]),l_split[-1])  	
		total_length+=int(l_split[-2]) 		
		dic_p[id_p]=p
	f.close() 
	return dic_p, total_length  

def return_stats(contig_list): 
	number_contigs=len(contig_list) 
	length=sum([c.length for c in contig_list]) 
	aligned_length=sum([len(c.bases_aligned) for c in contig_list])
	max_length=max([c.length for c in a.contigs]) 
	
	return number_contigs,length,aligned_length,max_length  	
	
def write_assembly_file(out2,out3,total_reference,ref_aligned_length,mode_cont,ref_complete_length,ref_total_length): 
	total_contigs,total_length,total_aligned_length,total_max_length=return_stats(a.contigs) 
	N50=N50_calc()
	N50_correct=N50_calc(True) 
	
	ambiguous=[c for c in a.contigs if c.status == "ambiguous"] 
	ambiguous_contigs,ambiguous_length,ambiguous_aligned_length,ambiguous_max_length=return_stats(ambiguous) 
	out2.write("%s\t%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n" %(a.assembler,"good","ambiguous",ambiguous_length,ambiguous_aligned_length,ambiguous_contigs,a.contamination,a.SR_coverage,a.LR_coverage)) 
	
	misassembled=[c for c in a.contigs if c.status == "misassembled"]
	misassembled_contigs,misassembled_length,misassembled_aligned_length,misassembled_max_length=return_stats(misassembled)  
	out2.write("%s\t%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n" %(a.assembler,"bad","misassembled",misassembled_length,misassembled_aligned_length,misassembled_contigs,a.contamination,a.SR_coverage,a.LR_coverage)) 
	
	unaligned=[c for c in a.contigs if c.status == "unaligned"]
	unaligned_contigs,unaligned_length,unaligned_aligned_length,unaligned_max_length=return_stats(unaligned) 
	out2.write("%s\t%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n" %(a.assembler,"bad","unaligned",unaligned_length,unaligned_aligned_length,unaligned_contigs,a.contamination,a.SR_coverage,a.LR_coverage)) 

	contamination=[c for c in a.contigs if c.status == "contamination"]
	contamination_contigs,contamination_length,contamination_aligned_length,contamination_max_length=return_stats(contamination) 
	out2.write("%s\t%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n" %(a.assembler,"bad","contamination",contamination_length,contamination_aligned_length,contamination_contigs,a.contamination,a.SR_coverage,a.LR_coverage)) 
	
	correct=[c for c in a.contigs if c.status == "correct"]
	correct_contigs,correct_length,correct_aligned_length,correct_max_length=return_stats(correct)
	out2.write("%s\t%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n" %(a.assembler,"good","correct",correct_length,correct_aligned_length,correct_contigs,a.contamination,a.SR_coverage,a.LR_coverage)) 
	
	others=[c for c in a.contigs if c.status == "others"] 
	others_contigs,others_length,others_aligned_length,others_max_length=return_stats(others)
	out2.write("%s\t%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\n" %(a.assembler,"bad","others",others_length,others_aligned_length,others_contigs,a.contamination,a.SR_coverage,a.LR_coverage)) 
 
 		
		
	#out.write("%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%s\t%s\n" %(a.assembler,total_contigs,total_length,total_aligned_length,total_max_length,correct_contigs,correct_length,correct_aligned_length,correct_max_length,ambiguous_contigs,ambiguous_length,ambiguous_aligned_length,ambiguous_max_length,misassembled_contigs,misassembled_length,misassembled_aligned_length,misassembled_max_length,unaligned_contigs,unaligned_length,unaligned_aligned_length,unaligned_max_length,N50,N50_correct,a.contamination,a.SR_coverage,a.LR_coverage))	
	
	if(mode_cont=="cont"): 
		out3.write("%s\t%s\t%s\t%s\t%d\t%d\t%d\t%f\t%f\t%f\t%f\t%f\n" %(a.contamination,a.SR_coverage,a.LR_coverage,a.assembler,N50_correct,correct_contigs,correct_max_length,(ref_aligned_length/total_reference)*100,((correct_aligned_length+ambiguous_aligned_length)/total_aligned_length)*100,(misassembled_aligned_length/total_aligned_length)*100,contamination_length/total_length*100,(ref_complete_length/ref_total_length)*100)) 
	else: 	
		out3.write("%s\t%s\t%s\t%s\t%d\t%d\t%d\t%f\t%f\t%f\t%s\t%f\n" %(a.contamination,a.SR_coverage,a.LR_coverage,a.assembler,N50_correct,correct_contigs,correct_max_length,(ref_aligned_length/total_reference)*100,((correct_aligned_length+ambiguous_aligned_length)/total_aligned_length)*100,(misassembled_aligned_length/total_aligned_length)*100,"-",(ref_complete_length/ref_total_length)*100)) 

	
	
def write_contig_file(out,outdir): 
	for c in a.contigs:
		if c.plasmids: 
			plasmid_list=",".join(c.plasmids)
		else: 
			plasmid_list="-" 	
		out.write("%s\t%s\t%d\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\n" %(a.assembler,c.name,c.length,c.status,c.commentary,len(c.bases_aligned),len(c.plasmids),plasmid_list,a.contamination,a.SR_coverage,a.LR_coverage))		
			 	
def write_plasmid_file(out): 
	ref_aligned_length=0
	ref_complete_length=0
	ref_total_length=0
	for p in a.plasmids: 
		p_obj=a.plasmids[p]   
		if (len(a.plasmids[p].bases_aligned)/p_obj.length>=0.9): 
			for c in p_obj.contigs: 
				if (c.length/p_obj.length >= 0.9 and c.length/p_obj.length <= 1.1) and (c.status=="correct" or c.status=="ambiguous"): 
					ref_complete_length+=p_obj.length 
		ref_aligned_length+=len(a.plasmids[p].bases_aligned) 
		ref_total_length+=p_obj.length
		out.write("%s\t%s\t%d\t%d\t%d\t%s\t%s\t%s\t%s\n" %(a.assembler,p,p_obj.length,len(p_obj.bases_aligned),len(p_obj.contigs),p_obj.length_cat,a.contamination,a.SR_coverage,a.LR_coverage)) 			
	return ref_aligned_length,ref_complete_length,ref_total_length  
	
def N50_calc(correct=False): 
	if correct: 
		list_length=[c.length for c in a.contigs if c.status=="correct"] 
	else: 	
		list_length=[c.length for c in a.contigs] 
	half_sum=sum(list_length)/2 
	list_length.sort(reverse=True) 
	sum_i=0 
	for i in list_length: 
		sum_i+=i 	
		if half_sum <= sum_i : 
			return(i)   
				 			 
if len(sys.argv) != 8: 
	usage() 
	exit() 
	
outdir=sys.argv[1]
summary_plasmids_file=sys.argv[2]
assemblies_name=sys.argv[3].split(",") 
contamination=sys.argv[4]
SR_coverage=sys.argv[5]	
LR_coverage=sys.argv[6]
mode=sys.argv[7]

#out1=open(outdir+"/assemblies_stats.tsv","w") 
out2=open(outdir+"/contigs_stats.tsv","w") 	
out3=open(outdir+"/plasmids_stats.tsv","w") 
out4=open(outdir+"/assemblies_stats_contigs_status.tsv","w") 
out5=open(outdir+"/assemblies_stats_all.tsv","w") 
#out1.write("Assembly\tTotal_contigs\tTotal_length\tTotal_aligned_length\tTotal_max_length\tCorrect_contigs\tCorrect_length\tCorrect_aligned_length\tCorrect_max_length\tAmbiguous_contigs\tAmbiguous_length\tAmbiguous_aligned_length\tAmbiguous_max_length\tMisassembled_contigs\tMisassembled_length\tMisassembled_aligned_length\tMisassembled_max_length\tUnaligned_contigs\tUnaligned_length\tUnaligned_aligned_length\tUnaligned_max_length\tN50\tCorrect_N50\tContamination\tShort_read_coverage\tLong_read_coverage\n") 
out2.write("Assembly\tContig_name\tContig_length\tContig_status\tCommentary\tLength_aligned\tNumber_aligned_plasmids\tList_of_aligned_plasmids\tContamination\tShort_read_coverage\tLong_read_coverage\n")  		
out3.write("Assembly\tPlasmid_id\tLength\tLength_correct_aligned\tNumber_correct_contigs\tLength_cat\tContamination\tShort_read_coverage\tLong_read_coverage\n") 
out4.write("Assembly\tContigs_status\tContigs_substatus\tTotal_length\tAlign_length\tNumber_contigs\tContamination\tShort_read_coverage\tLong_read_coverage\n") 
out5.write("Contamination\tIllumina coverage\tPacBio coverage\tAssembler\tN50 (correct contigs)\tNumber correct contigs\tLargest alignment\t% Reference coverage\t% Contigs aligned\t% Misassembled contigs aligned\t%Contamination length\t% complete plasmids\n")   
		
for a_name in assemblies_name :
	print(a_name) 
	dic_p={}
	dic_p,total_reference=initialize_plasmids(summary_plasmids_file)
	a=Assembly(a_name,dic_p,contamination,SR_coverage,LR_coverage) 
	list_contamination=[]
	if (mode=="cont"): 
		list_contamination=give_list_contamination(outdir+"/all_alignments_cont_"+a_name+".rev.tsv") 
	treat_contigs(outdir+"/all_alignments_"+a_name+".rev.tsv",list_contamination)  	
	ref_aligned_length,ref_complete_length,ref_total_length=write_plasmid_file(out3)
	write_assembly_file(out4,out5,total_reference,ref_aligned_length,mode,ref_complete_length,ref_total_length) 
	write_contig_file(out2,outdir) 
	 
	 
	
	
	
#out1.close() 	 
out2.close() 	
out3.close() 
out4.close()
out5.close()
	
	
	
