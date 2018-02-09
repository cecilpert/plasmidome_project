import sys 
f_name = sys.argv[1]
out_dir = sys.argv[2]
prefix = sys.argv[3]

f=open(f_name,'r') 
p1=open(out_dir+"/"+prefix+"_r1.fastq",'w') 
p2=open(out_dir+"/"+prefix+"_r2.fastq","w") 

for l in f : 
   if l[0]=='@': 
      number_paired=l.split(" ")[0].split("/")[1]
      if number_paired=='1': 
         out_f=p1
      elif number_paired=='2':
         out_f=p2 
   out_f.write(l)

p1.close()
p2.close()  
