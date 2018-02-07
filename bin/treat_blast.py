import sys 

blast_in = sys.argv[1]
out_all = sys.argv[2]
out_interest = sys.argv[3]
perc_qcov = sys.argv[4]
perc_scov = sys.argv[5]

blast_in_f=open(blast_in,"r")
out_f=open(out_all,'w')
out_interest_f=open(out_interest,"w")  
out_f.write("query_id\tsbjct_id\tquery_len\tsbjct_len\tquery_coverage\tsbjct_coverage\n")  
out_interest_f.write("query_id\tsbjct_id\tquery_coverage\tsbjct_coverage\n")  


for l in blast_in_f: 
   l_split = l.split("\t") 
   length = l_split[5]
   qlen = l_split[3]
   slen = l_split[4]
   query = l_split[0]
   sbjct = l_split[1]
   query_cov =(int(length)/int(qlen))*100 
   sbjct_cov=(int(length)/int(slen))*100
   out_f.write(query+"\t"+sbjct+"\t"+str(qlen)+"\t"+str(slen)+"\t"+str(query_cov)+"\t"+str(sbjct_cov)+"\n")
   if query_cov >= int(perc_qcov) and sbjct_cov >= int(perc_scov): 
      out_interest_f.write(query+"\t"+sbjct+"\t"+str(qlen)+"\t"+str(slen)+"\t"+str(query_cov)+"\t"+str(sbjct_cov)+"\t"+str(length)+"\n")
out_interest_f.close()
out_f.close() 
    
