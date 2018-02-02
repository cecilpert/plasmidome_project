import sys 

def select_subgroup(in_file,stats_n):
   f=open(in_file,"r")  
   stats_f = open(stats_n,'w') 
   selected_subgroups = []
   dic_stats = {}
   for line in f : 
      line_split = line.split("\t")
      specie_name = " ".join(line_split[0].rstrip().split(" ")[0:2])
      access_number = line_split[5]
      subgroup = line_split[3] 
      if subgroup in dic_stats:
         dic_stats[subgroup]+=1 
      else: 
         dic_stats[subgroup]=1
   
   for subgroup in dic_stats: 
      if dic_stats[subgroup]>=50:
         selected_subgroups.append(subgroup)
         stats_f.write(subgroup+"\t"+str(dic_stats[subgroup]))
   f.close() 
   stats_f.close() 
   return selected_subgroups  

def select_plasmids(in_file,out_file,selected_specie_file,subdb,selected_subgroup):
   f = open(in_file,"r")
   out = open(out_file,"w")
   selected_species = open(selected_specie_file,"w") 
   subdb_f = open(subdb,"w")   
   already_select = set() 
   for line in f:
      line_split=line.split("\t") 
      access_number = line_split[5]
      subgroup = line_split[3]
      specie_name = " ".join(line_split[0].split(" ")[:2])
      if access_number !='-' and specie_name not in already_select and subgroup in selected_subgroup and specie_name[0]!='[': 
          out.write(access_number+"\n") 
          selected_species.write(specie_name+"\n")
          subdb_f.write(line)   
          already_select.add(specie_name)     
   f.close() 
   out.close() 
   selected_species.close() 
   subdb_f.close() 

file_name = sys.argv[1]
out_name = sys.argv[2]
list_selected_n = sys.argv[3]
subdb_n = sys.argv[4]
stats_subgroup_n = sys.argv[5]

selected_subgroup = select_subgroup(file_name,stats_subgroup_n) 
select_plasmids(file_name,out_name,list_selected_n,subdb_n,selected_subgroup) 




