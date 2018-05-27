import random
import sys 

def usage(): 
	print("usage: python3 select_contaminants.py <input taxontable> <output taxontable>")
	print("Select randomly non redundant species projects") 
	
if len(sys.argv)!=3: 
	usage() 
	exit()
	
f=sys.argv[1]
out=sys.argv[2]	
f=open(f,"r") 
out=open(out,"w")	

dic={}
for l in f: 
	specie=l.split("\t")[7]
	project_id=l.split("\t")[9]
	if specie in dic : 
		dic[specie].append(project_id) 
	else: 
		dic[specie]=[project_id] 
		
for sp in dic : 
	out.write(sp+"\t"+random.choice(dic[sp])+"\n")		
	
