import sys 

file_name = sys.argv[1]
out_name = sys.argv[2]
f = open(file_name,'r')
out = open(out_name,'w')
already_select = set() 
for line in f : 
   line_split = line.split("\t")
   specie_name = " ".join(line_split[0].rstrip().split(" ")[0:2])
   access_number = line_split[5]
   if access_number !='-' and specie_name not in already_select : 
      out.write(access_number+"\n") 
      already_select.add(specie_name)
f.close()
out.close()   
