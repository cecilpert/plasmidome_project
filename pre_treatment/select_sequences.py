from Bio import SeqIO
import sys  

def create_list_fasta(list_fasta_n): 
   list_fasta_f = open(list_fasta_n,'r') 
   list_fasta=[]
   for l in list_fasta_f : 
       list_fasta.append(l.rstrip()) 
   list_fasta_f.close() 
   return list_fasta     

def store_selected_seq(list_fasta,acc_list):
   selected_records=[]
   for fasta in list_fasta : 
       for record in SeqIO.parse(fasta,"fasta"): 
          if record.id in acc_list:
              selected_records.append(record) 
   return selected_records

def create_acc_list(selected_acc_n): 
   acc_list=set()
   selected_acc_f=open(selected_acc_n,"r")
   for l in selected_acc_f: 
      acc_list.add(l.rstrip())
   selected_acc_f.close() 
   return acc_list 

def write_records(selected_records,out_fasta): 
   with open(out_fasta, "w") as output_handle:
      SeqIO.write(selected_records, output_handle, "fasta")

list_fasta_n = sys.argv[1] 
selected_acc_n = sys.argv[2]
out_fasta_n = sys.argv[3]

list_fasta=create_list_fasta(list_fasta_n)  
acc_list = create_acc_list(selected_acc_n)
selected_records=store_selected_seq(list_fasta,acc_list) 
write_records(selected_records,out_fasta_n) 

