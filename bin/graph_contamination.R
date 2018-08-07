library(ggplot2)

args = commandArgs(trailingOnly=TRUE) 

if (length(args)!=3) {
  stop("usage : RScript --vanilla graphs.R <assemblies file> <outdir> <prefix>", call.=FALSE)
}

outputName <- function(outdir,prefix,suffix){
	g=paste(outdir,prefix,sep="/")
	g=paste(g,suffix,sep="") 
	return(g)   
}

outdir=args[2]
prefix=args[3]

f=read.table(args[1],header=TRUE,sep="\t")

f$Assembler=factor(f$Assembler,levels=c("megahit","plasflow50","plasflow70","cbar","cbar_plasflow50","cbar_plasflow70","chrm80","chrm90","chrm95","chrm97","chrm99","chrm_all")) 

g1=outputName(outdir,prefix,"_contamination.pdf")

pdf(g1) 
ggplot(f,aes(y=X.Contamination.length,x=Assembler,fill=Assembler))+geom_bar(stat="identity")+theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.title.y=element_text(size=14),axis.ticks.x=element_blank())+labs(y="% contaminated contigs")
dev.off() 

g2=outputName(outdir,prefix,"_reference_cov.pdf") 
pdf(g2) 
ggplot(f,aes(y=X..Reference.coverage,x=Assembler,fill=Assembler))+geom_bar(stat="identity")+theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.title.y=element_text(size=14),axis.ticks.x=element_blank())+labs(y="% Reference coverage")
dev.off() 
